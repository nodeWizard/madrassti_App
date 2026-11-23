import 'package:flutter/widgets.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'medallion.dart';

/// The coral alert card. See `docs/SPEC.md` §3.9.
///
/// Used by the parent dashboard ("Mme Trabelsi sera absente") and, with other
/// colours, by the teacher's "what parents will see" preview.
class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.icon,
    required this.kicker,
    required this.title,
    required this.body,
    this.semanticLabel,
    this.background = AppColors.coralTint,
    this.borderColor = AppColors.coralBorder,
    this.iconBackground = AppColors.coral,
    this.kickerColor = AppColors.danger,
    this.trailingKicker,
    this.titleSize = 18,
    this.bodySize = 14,
    this.kickerSize = 12,
    this.medallionSize = 44,
    this.medallionRadius = AppRadii.r14,
    this.actions,
    this.footer,
  });

  final String icon;
  final String kicker;
  final String title;
  final String body;
  final String? semanticLabel;
  final Color background;
  final Color borderColor;
  final Color iconBackground;
  final Color kickerColor;

  /// Right-aligned text on the kicker line, e.g. "il y a 2 h".
  final String? trailingKicker;
  final double titleSize;
  final double bodySize;
  final double kickerSize;
  final double medallionSize;
  final double medallionRadius;

  /// Buttons below the body, inside the text column.
  final Widget? actions;

  /// A full-width row below everything, e.g. the pinned notification footer.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final kickerRow = trailingKicker == null
        ? Text(
            kicker.toUpperCase(),
            style: AppTextStyles.nunito(
              size: kickerSize,
              weight: FontWeight.w800,
              color: kickerColor,
              letterSpacing: kickerSize * 0.08,
            ),
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  kicker.toUpperCase(),
                  style: AppTextStyles.nunito(
                    size: kickerSize,
                    weight: FontWeight.w800,
                    color: kickerColor,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              Text(trailingKicker!, style: AppTextStyles.metaSmall),
            ],
          );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Medallion(
              icon: icon,
              background: iconBackground,
              foreground: AppColors.navy,
              size: medallionSize,
              radius: medallionRadius,
              iconSize: medallionSize == 44 ? 22 : 20,
              strokeWidth: medallionSize == 44 ? 2.2 : 2,
            ),
            const SizedBox(width: AppSpacing.x14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kickerRow,
                  const SizedBox(height: AppSpacing.x5),
                  Text(
                    title,
                    style: AppTextStyles.fredoka(size: titleSize, height: 1.25),
                  ),
                  const SizedBox(height: AppSpacing.x5),
                  Text(
                    body,
                    style: AppTextStyles.nunito(
                      size: bodySize,
                      weight: FontWeight.w400,
                      height: 1.45,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  if (actions != null) ...[
                    const SizedBox(height: AppSpacing.x8),
                    actions!,
                  ],
                ],
              ),
            ),
          ],
        ),
        if (footer != null) ...[
          const SizedBox(height: AppSpacing.x10),
          footer!,
        ],
      ],
    );

    final card = Container(
      padding: const EdgeInsets.all(AppSpacing.x16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.r22),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: content,
    );

    if (semanticLabel == null) return card;
    return Semantics(label: semanticLabel, container: true, child: card);
  }
}
