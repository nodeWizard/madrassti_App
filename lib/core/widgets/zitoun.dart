import 'package:flutter/widgets.dart';

import '../theme/app_colors.dart';
import 'svg_path_parser.dart';

/// Zitoun's three expressions, as defined by the mockup component.
enum ZitounMood {
  /// Both arms down, open eyes, small smile.
  content,

  /// Left arm waving, open eyes, small smile.
  salut,

  /// Both arms up, laughing eyes, wide grin.
  bravo,
}

/// Zitoun, the Madrassti olive mascot.
///
/// Redrawn from the `Zitoun` component of `mockups/composants.html`: a single
/// `0 0 120 130` viewBox whose expression is selected by toggling groups on and
/// off. The mockup does this with `opacity: 0|1`; here the hidden groups are
/// simply not painted, which is visually identical and cheaper.
///
/// See `docs/SPEC.md` §3.1.
class Zitoun extends StatelessWidget {
  const Zitoun({
    super.key,
    this.size = 240,
    this.mood = ZitounMood.content,
    this.excludeSemantics = false,
  });

  final double size;
  final ZitounMood mood;

  /// Set when Zitoun is purely decorative inside an already-labelled element.
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    Widget child = CustomPaint(
      size: Size(size, size),
      painter: _ZitounPainter(mood),
    );

    child = excludeSemantics
        ? ExcludeSemantics(child: child)
        : Semantics(
            label: 'Zitoun, la mascotte de Madrassti',
            image: true,
            child: child,
          );

    return SizedBox(width: size, height: size, child: child);
  }
}

class _ZitounPainter extends CustomPainter {
  _ZitounPainter(this.mood);

  final ZitounMood mood;

  // The mockup viewBox. It is taller than it is wide, so it is letterboxed
  // inside the square box the component is given — exactly what
  // `width:100%; height:100%` on a non-square viewBox does in the browser.
  static const double _vbW = 120;
  static const double _vbH = 130;

  static final Map<String, Path> _cache = {};
  static Path _p(String d) => _cache[d] ??= parseSvgPath(d);

  Paint _fill(Color c, [double opacity = 1]) => Paint()
    ..style = PaintingStyle.fill
    ..color = opacity == 1 ? c : c.withValues(alpha: c.a * opacity)
    ..isAntiAlias = true;

  Paint _stroke(
    Color c,
    double w, {
    StrokeJoin join = StrokeJoin.round,
    StrokeCap cap = StrokeCap.round,
  }) => Paint()
    ..style = PaintingStyle.stroke
    ..color = c
    ..strokeWidth = w
    ..strokeCap = cap
    ..strokeJoin = join
    ..isAntiAlias = true;

  void _ellipse(
    Canvas canvas,
    double cx,
    double cy,
    double rx,
    double ry,
    Paint paint,
  ) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2),
      paint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // `object-fit: contain` on the square box.
    final scale = (size.width / _vbW) < (size.height / _vbH)
        ? size.width / _vbW
        : size.height / _vbH;
    final dx = (size.width - _vbW * scale) / 2;
    final dy = (size.height - _vbH * scale) / 2;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);

    final armUp = mood == ZitounMood.salut || mood == ZitounMood.bravo;
    final bravo = mood == ZitounMood.bravo;

    // ---- ground shadow
    _ellipse(canvas, 58, 124, 28, 4, _fill(AppColors.navy, 0.12));

    // ---- satchel, behind the body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(78, 50, 30, 44),
        const Radius.circular(10),
      ),
      _fill(AppColors.yellow),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(78, 50, 30, 15),
        const Radius.circular(7),
      ),
      _fill(AppColors.yellowDark),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(90, 61, 6, 6),
        const Radius.circular(1.5),
      ),
      _fill(AppColors.navy),
    );

    // ---- arms
    final arm = _stroke(AppColors.oliveBody, 9);
    if (armUp) {
      canvas.drawPath(_p('M30 70 Q 15 60 16 42'), arm); // waving
    } else {
      canvas.drawPath(_p('M28 78 Q 17 88 20 101'), arm);
    }
    if (bravo) {
      canvas.drawPath(_p('M88 70 Q 103 60 102 42'), arm);
    } else {
      canvas.drawPath(_p('M90 80 Q 99 90 96 102'), arm);
    }

    // ---- feet
    final navy = _fill(AppColors.navy);
    _ellipse(canvas, 46, 117, 10, 5.5, navy);
    _ellipse(canvas, 70, 117, 10, 5.5, navy);

    // ---- body
    _ellipse(canvas, 58, 74, 36, 42, _fill(AppColors.oliveBody));

    // Highlight: an ellipse rotated 20° about its own centre.
    canvas.save();
    canvas.translate(42, 52);
    canvas.rotate(20 * 3.141592653589793 / 180);
    canvas.translate(-42, -52);
    _ellipse(canvas, 42, 52, 7, 11, _fill(AppColors.oliveHighlight));
    canvas.restore();

    // ---- satchel strap across the body
    canvas.drawPath(
      _p('M84 44 Q 93 74 87 104'),
      _stroke(AppColors.yellowDark, 5),
    );

    // ---- stem and leaf
    canvas.drawPath(
      _p('M58 33 Q 59 22 65 15'),
      _stroke(AppColors.oliveLeafStroke, 4),
    );
    final leaf = _p('M64 16 C 70 5, 86 4, 92 10 C 85 19, 72 22, 64 16 Z');
    canvas.drawPath(leaf, _fill(AppColors.oliveLeaf));
    canvas.drawPath(leaf, _stroke(AppColors.oliveLeafStroke, 2));
    canvas.drawPath(
      _p('M67 15 Q 78 12 88 10'),
      _stroke(AppColors.oliveLeafStroke, 1.5),
    );

    // ---- eyes
    if (bravo) {
      final happy = _stroke(AppColors.navy, 3.5);
      canvas.drawPath(_p('M38 72 Q 46 62 54 72'), happy);
      canvas.drawPath(_p('M62 72 Q 70 62 78 72'), happy);
    } else {
      final white = _fill(AppColors.white);
      _ellipse(canvas, 46, 70, 9, 10.5, white);
      _ellipse(canvas, 70, 70, 9, 10.5, white);
      canvas.drawCircle(const Offset(48, 72), 5, navy);
      canvas.drawCircle(const Offset(72, 72), 5, navy);
      canvas.drawCircle(const Offset(50, 69.5), 1.8, white);
      canvas.drawCircle(const Offset(74, 69.5), 1.8, white);
    }

    // ---- blush
    final blush = _fill(AppColors.coral, 0.6);
    _ellipse(canvas, 36, 86, 6, 4, blush);
    _ellipse(canvas, 80, 86, 6, 4, blush);

    // ---- mouth
    if (bravo) {
      final grin = _p('M48 86 Q 58 103 68 86 Z');
      canvas.drawPath(grin, _fill(AppColors.navy));
      canvas.drawPath(grin, _stroke(AppColors.navy, 2));
      canvas.drawPath(_p('M53 93 Q 58 98 63 93'), _fill(AppColors.coral));
    } else {
      canvas.drawPath(
        _p('M50 88 Q 58 96 66 88'),
        _stroke(AppColors.navy, 3.5),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_ZitounPainter old) => old.mood != mood;
}
