import 'dart:math' as math;
import 'dart:ui';

/// Minimal but complete SVG path-data parser.
///
/// Supports every command the mockup icons and the Zitoun mascot use:
/// `M m L l H h V v C c S s Q q T t A a Z z`, including implicit repeated
/// coordinate pairs (`M3 10.5 12 3` = move then line).
///
/// Elliptical arcs are converted to cubic Béziers, so the result is a plain
/// [Path] that renders identically to the browser and can be stroked
/// synchronously — which keeps golden tests deterministic.
Path parseSvgPath(String d) {
  final path = Path();
  final tokens = _Tokenizer(d);

  // Current point.
  var cx = 0.0;
  var cy = 0.0;
  // Start of the current subpath, for `Z`.
  var sx = 0.0;
  var sy = 0.0;
  // Previous cubic control point, for `S`/`s`.
  double? lastC2x;
  double? lastC2y;
  // Previous quadratic control point, for `T`/`t`.
  double? lastQx;
  double? lastQy;

  var command = '';

  while (true) {
    final next = tokens.peekCommand();
    if (next != null) {
      command = next;
      tokens.consumeCommand();
    } else if (command.isEmpty) {
      break;
    } else if (!tokens.hasMoreNumbers) {
      break;
    } else if (command == 'M') {
      // Extra pairs after a moveto are implicit linetos.
      command = 'L';
    } else if (command == 'm') {
      command = 'l';
    } else if (command == 'Z' || command == 'z') {
      break;
    }

    final relative = command == command.toLowerCase();
    switch (command.toUpperCase()) {
      case 'M':
        final x = tokens.number();
        final y = tokens.number();
        cx = relative ? cx + x : x;
        cy = relative ? cy + y : y;
        sx = cx;
        sy = cy;
        path.moveTo(cx, cy);
        lastC2x = lastC2y = lastQx = lastQy = null;

      case 'L':
        final x = tokens.number();
        final y = tokens.number();
        cx = relative ? cx + x : x;
        cy = relative ? cy + y : y;
        path.lineTo(cx, cy);
        lastC2x = lastC2y = lastQx = lastQy = null;

      case 'H':
        final x = tokens.number();
        cx = relative ? cx + x : x;
        path.lineTo(cx, cy);
        lastC2x = lastC2y = lastQx = lastQy = null;

      case 'V':
        final y = tokens.number();
        cy = relative ? cy + y : y;
        path.lineTo(cx, cy);
        lastC2x = lastC2y = lastQx = lastQy = null;

      case 'C':
        var x1 = tokens.number();
        var y1 = tokens.number();
        var x2 = tokens.number();
        var y2 = tokens.number();
        var x = tokens.number();
        var y = tokens.number();
        if (relative) {
          x1 += cx;
          y1 += cy;
          x2 += cx;
          y2 += cy;
          x += cx;
          y += cy;
        }
        path.cubicTo(x1, y1, x2, y2, x, y);
        lastC2x = x2;
        lastC2y = y2;
        lastQx = lastQy = null;
        cx = x;
        cy = y;

      case 'S':
        var x2 = tokens.number();
        var y2 = tokens.number();
        var x = tokens.number();
        var y = tokens.number();
        if (relative) {
          x2 += cx;
          y2 += cy;
          x += cx;
          y += cy;
        }
        // Reflect the previous second control point about the current point.
        final x1 = lastC2x == null ? cx : 2 * cx - lastC2x;
        final y1 = lastC2y == null ? cy : 2 * cy - lastC2y;
        path.cubicTo(x1, y1, x2, y2, x, y);
        lastC2x = x2;
        lastC2y = y2;
        lastQx = lastQy = null;
        cx = x;
        cy = y;

      case 'Q':
        var x1 = tokens.number();
        var y1 = tokens.number();
        var x = tokens.number();
        var y = tokens.number();
        if (relative) {
          x1 += cx;
          y1 += cy;
          x += cx;
          y += cy;
        }
        path.quadraticBezierTo(x1, y1, x, y);
        lastQx = x1;
        lastQy = y1;
        lastC2x = lastC2y = null;
        cx = x;
        cy = y;

      case 'T':
        var x = tokens.number();
        var y = tokens.number();
        if (relative) {
          x += cx;
          y += cy;
        }
        final x1 = lastQx == null ? cx : 2 * cx - lastQx;
        final y1 = lastQy == null ? cy : 2 * cy - lastQy;
        path.quadraticBezierTo(x1, y1, x, y);
        lastQx = x1;
        lastQy = y1;
        lastC2x = lastC2y = null;
        cx = x;
        cy = y;

      case 'A':
        final rx = tokens.number();
        final ry = tokens.number();
        final rotation = tokens.number();
        final largeArc = tokens.flag();
        final sweep = tokens.flag();
        var x = tokens.number();
        var y = tokens.number();
        if (relative) {
          x += cx;
          y += cy;
        }
        _arcToCubics(path, cx, cy, x, y, rx, ry, rotation, largeArc, sweep);
        lastC2x = lastC2y = lastQx = lastQy = null;
        cx = x;
        cy = y;

      case 'Z':
        path.close();
        cx = sx;
        cy = sy;
        lastC2x = lastC2y = lastQx = lastQy = null;
    }

    if (!tokens.hasMoreNumbers && tokens.peekCommand() == null) break;
  }

  return path;
}

/// Appends an SVG elliptical arc to [path] as one to four cubic segments,
/// following the conversion in the SVG 1.1 implementation notes (F.6.5).
void _arcToCubics(
  Path path,
  double x1,
  double y1,
  double x2,
  double y2,
  double rx,
  double ry,
  double rotationDeg,
  bool largeArc,
  bool sweep,
) {
  if (rx == 0 || ry == 0) {
    path.lineTo(x2, y2);
    return;
  }
  if (x1 == x2 && y1 == y2) return;

  rx = rx.abs();
  ry = ry.abs();

  final phi = rotationDeg * math.pi / 180.0;
  final cosPhi = math.cos(phi);
  final sinPhi = math.sin(phi);

  // Step 1: map the endpoints into the ellipse's own frame.
  final dx2 = (x1 - x2) / 2.0;
  final dy2 = (y1 - y2) / 2.0;
  final x1p = cosPhi * dx2 + sinPhi * dy2;
  final y1p = -sinPhi * dx2 + cosPhi * dy2;

  // Step 2: scale the radii up if they are too small to span the endpoints.
  final lambda = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry);
  if (lambda > 1) {
    final s = math.sqrt(lambda);
    rx *= s;
    ry *= s;
  }

  // Step 3: centre of the ellipse, in its own frame.
  final rxSq = rx * rx;
  final rySq = ry * ry;
  final x1pSq = x1p * x1p;
  final y1pSq = y1p * y1p;
  var num = rxSq * rySq - rxSq * y1pSq - rySq * x1pSq;
  final den = rxSq * y1pSq + rySq * x1pSq;
  if (num < 0) num = 0;
  var coef = den == 0 ? 0.0 : math.sqrt(num / den);
  if (largeArc == sweep) coef = -coef;
  final cxp = coef * (rx * y1p / ry);
  final cyp = coef * -(ry * x1p / rx);

  // Step 4: back to user space.
  final cx = cosPhi * cxp - sinPhi * cyp + (x1 + x2) / 2.0;
  final cy = sinPhi * cxp + cosPhi * cyp + (y1 + y2) / 2.0;

  // Step 5: start angle and sweep.
  double angle(double ux, double uy, double vx, double vy) {
    final dot = ux * vx + uy * vy;
    final len = math.sqrt((ux * ux + uy * uy) * (vx * vx + vy * vy));
    var a = math.acos((dot / len).clamp(-1.0, 1.0));
    if (ux * vy - uy * vx < 0) a = -a;
    return a;
  }

  final ux = (x1p - cxp) / rx;
  final uy = (y1p - cyp) / ry;
  final vx = (-x1p - cxp) / rx;
  final vy = (-y1p - cyp) / ry;

  final theta1 = angle(1, 0, ux, uy);
  var deltaTheta = angle(ux, uy, vx, vy);
  if (!sweep && deltaTheta > 0) {
    deltaTheta -= 2 * math.pi;
  } else if (sweep && deltaTheta < 0) {
    deltaTheta += 2 * math.pi;
  }

  // Split into segments of at most 90° so the cubic approximation stays tight.
  final segments = math.max(1, (deltaTheta.abs() / (math.pi / 2)).ceil());
  final delta = deltaTheta / segments;
  // Control-point handle length for a cubic approximating a circular arc.
  final t = 4 / 3 * math.tan(delta / 4);

  var theta = theta1;
  for (var i = 0; i < segments; i++) {
    final cosT1 = math.cos(theta);
    final sinT1 = math.sin(theta);
    final theta2 = theta + delta;
    final cosT2 = math.cos(theta2);
    final sinT2 = math.sin(theta2);

    // Endpoint of this segment, in user space.
    final ex = cx + rx * cosPhi * cosT2 - ry * sinPhi * sinT2;
    final ey = cy + rx * sinPhi * cosT2 + ry * cosPhi * sinT2;

    // Tangents at both ends, scaled by the handle length.
    final dx1 = -rx * cosPhi * sinT1 - ry * sinPhi * cosT1;
    final dy1 = -rx * sinPhi * sinT1 + ry * cosPhi * cosT1;
    final dxe = -rx * cosPhi * sinT2 - ry * sinPhi * cosT2;
    final dye = -rx * sinPhi * sinT2 + ry * cosPhi * cosT2;

    final startX = cx + rx * cosPhi * cosT1 - ry * sinPhi * sinT1;
    final startY = cy + rx * sinPhi * cosT1 + ry * cosPhi * sinT1;

    path.cubicTo(
      startX + t * dx1,
      startY + t * dy1,
      ex - t * dxe,
      ey - t * dye,
      ex,
      ey,
    );

    theta = theta2;
  }
}

/// Splits path data into commands, numbers and arc flags.
class _Tokenizer {
  _Tokenizer(this._s);

  final String _s;
  int _i = 0;

  static bool _isCommand(int c) {
    // MmLlHhVvCcSsQqTtAaZz
    return c == 0x4D ||
        c == 0x6D ||
        c == 0x4C ||
        c == 0x6C ||
        c == 0x48 ||
        c == 0x68 ||
        c == 0x56 ||
        c == 0x76 ||
        c == 0x43 ||
        c == 0x63 ||
        c == 0x53 ||
        c == 0x73 ||
        c == 0x51 ||
        c == 0x71 ||
        c == 0x54 ||
        c == 0x74 ||
        c == 0x41 ||
        c == 0x61 ||
        c == 0x5A ||
        c == 0x7A;
  }

  static bool _isSeparator(int c) =>
      c == 0x20 || c == 0x2C || c == 0x0A || c == 0x0D || c == 0x09;

  void _skipSeparators() {
    while (_i < _s.length && _isSeparator(_s.codeUnitAt(_i))) {
      _i++;
    }
  }

  String? peekCommand() {
    _skipSeparators();
    if (_i >= _s.length) return null;
    final c = _s.codeUnitAt(_i);
    return _isCommand(c) ? _s[_i] : null;
  }

  void consumeCommand() => _i++;

  bool get hasMoreNumbers {
    _skipSeparators();
    if (_i >= _s.length) return false;
    final c = _s.codeUnitAt(_i);
    // digit, '-', '+' or '.'
    return (c >= 0x30 && c <= 0x39) || c == 0x2D || c == 0x2B || c == 0x2E;
  }

  double number() {
    _skipSeparators();
    final start = _i;
    if (_i < _s.length) {
      final c = _s.codeUnitAt(_i);
      if (c == 0x2D || c == 0x2B) _i++;
    }
    var sawDot = false;
    while (_i < _s.length) {
      final c = _s.codeUnitAt(_i);
      if (c >= 0x30 && c <= 0x39) {
        _i++;
      } else if (c == 0x2E && !sawDot) {
        sawDot = true;
        _i++;
      } else if (c == 0x65 || c == 0x45) {
        // exponent
        _i++;
        if (_i < _s.length) {
          final n = _s.codeUnitAt(_i);
          if (n == 0x2D || n == 0x2B) _i++;
        }
      } else {
        break;
      }
    }
    final text = _s.substring(start, _i);
    final value = double.tryParse(text);
    if (value == null) {
      throw FormatException('Invalid number "$text" in path data', _s, start);
    }
    return value;
  }

  /// An arc flag is a single `0` or `1`, which may be written without any
  /// separator (`a6 6 0 0 1 12 0`).
  bool flag() {
    _skipSeparators();
    final c = _s.codeUnitAt(_i);
    _i++;
    return c == 0x31;
  }
}
