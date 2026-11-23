import 'package:flutter/widgets.dart';

import '../theme/app_colors.dart';
import 'app_icon_paths.dart';
import 'svg_path_parser.dart';

/// A stroke icon from the mockup icon set.
///
/// Reproduces the mockups' SVG conventions exactly: a `0 0 24 24` viewBox,
/// no fill, `stroke: currentColor`, round caps and round joins. The default
/// stroke width is `2`, matching the component's default.
///
/// Pass [semanticLabel] for an icon that carries meaning on its own; icons
/// inside a labelled button stay `aria-hidden`, as in the mockups.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.name, {
    super.key,
    this.size = 24,
    this.strokeWidth = 2,
    this.color,
    this.semanticLabel,
  });

  /// A glyph name from [AppIcons].
  final String name;

  /// Rendered box size, in logical pixels. The viewBox is scaled to fit.
  final double size;

  /// Stroke width *in viewBox units*, exactly as `stroke-width` in the mockups.
  final double strokeWidth;

  /// Defaults to the inherited [DefaultTextStyle] colour, which is how
  /// `stroke: currentColor` behaves in the mockups.
  final Color? color;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final shapes = kIconShapes[name];
    assert(shapes != null, 'Unknown icon "$name"');

    final resolved =
        color ?? DefaultTextStyle.of(context).style.color ?? AppColors.ink;

    Widget child = CustomPaint(
      size: Size(size, size),
      painter: _IconPainter(
        shapes: shapes ?? const [],
        color: resolved,
        strokeWidth: strokeWidth,
      ),
    );

    if (semanticLabel != null) {
      child = Semantics(label: semanticLabel, image: true, child: child);
    } else {
      child = ExcludeSemantics(child: child);
    }

    return SizedBox(width: size, height: size, child: child);
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter({
    required this.shapes,
    required this.color,
    required this.strokeWidth,
  });

  final List<IconShape> shapes;
  final Color color;
  final double strokeWidth;

  static const double _viewBox = 24;

  /// Parsed paths are shared across every instance of a glyph — parsing the
  /// same data on each paint would be wasteful.
  static final Map<String, Path> _cache = {};

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / _viewBox;

    canvas.save();
    canvas.scale(scale);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      // `stroke-width` is in viewBox units, and the canvas is already scaled,
      // so the value is used as-is.
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    for (final shape in shapes) {
      switch (shape) {
        case IconPath(:final d):
          canvas.drawPath(_cache[d] ??= parseSvgPath(d), paint);
        case IconCircle(:final cx, :final cy, :final r):
          canvas.drawCircle(Offset(cx, cy), r, paint);
        case IconRect(:final x, :final y, :final w, :final h, :final rx):
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, y, w, h),
              Radius.circular(rx),
            ),
            paint,
          );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_IconPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      !identical(old.shapes, shapes);
}
