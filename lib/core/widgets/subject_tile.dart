import 'package:flutter/widgets.dart';

import '../theme/app_subjects.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';

/// The rounded subject tile ("pastille matière").
///
/// Reproduces the `Subject` component: a square whose radius, glyph size and
/// icon size are all derived from [size]:
///  * `radius = round(size * 0.32)`
///  * text glyph `fontSize = round(size * k)`, with `k` per subject
///  * icon `size = round(size * 0.5)`, stroke `2.2`
///
/// See `docs/SPEC.md` §3.3.
class SubjectTile extends StatelessWidget {
  const SubjectTile({
    super.key,
    required this.subject,
    this.size = 64,
    this.excludeSemantics = false,
  });

  final Subject subject;
  final double size;

  /// Set when the tile sits inside an already-labelled row or button.
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    final style = AppSubjects.of(subject);
    final radius = (size * 0.32).roundToDouble();

    Widget glyph;
    if (style.isText) {
      final fontSize = (size * style.glyphRatio).roundToDouble();
      glyph = Text(
        style.glyph!,
        textAlign: TextAlign.center,
        // The glyph is a fixed-size emblem, so it must not grow with the
        // system text scale or it would overflow the tile.
        textScaler: TextScaler.noScaling,
        style: style.isArabicGlyph
            ? AppTextStyles.baloo(
                size: fontSize,
                weight: FontWeight.w700,
                height: 1,
                color: style.ink,
              )
            : AppTextStyles.fredoka(
                size: fontSize,
                weight: FontWeight.w700,
                height: 1,
                color: style.ink,
              ),
      );
    } else {
      glyph = AppIcon(
        style.icon!,
        size: (size * 0.5).roundToDouble(),
        strokeWidth: 2.2,
        color: style.ink,
      );
    }

    final tile = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: style.tint,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: glyph,
    );

    if (excludeSemantics) return ExcludeSemantics(child: tile);
    return Semantics(label: style.name, image: true, child: tile);
  }
}
