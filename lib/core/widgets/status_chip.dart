import 'package:flutter/widgets.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';
import 'app_icon_paths.dart';

/// The small pill labels of the mockups ("En cours", "Modifié", "Nouveau"…).
///
/// See `docs/SPEC.md` §3.6.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.background,
    this.foreground = AppColors.navy,
    this.height = 24,
    this.fontSize = 11,
    this.horizontalPadding = 9,
    this.icon,
    this.iconSize = 12,
    this.iconStrokeWidth = 3,
    this.leadingDot = false,
  });

  final String label;
  final Color background;
  final Color foreground;
  final double height;
  final double fontSize;
  final double horizontalPadding;

  /// Optional leading glyph, e.g. the check of "Hors connexion".
  final String? icon;
  final double iconSize;
  final double iconStrokeWidth;

  /// The day-status chip carries an 8px dot in the foreground colour.
  final bool leadingDot;

  /// `En cours` — yellow on navy ink.
  factory StatusChip.inProgress() => const StatusChip(
    label: 'En cours',
    background: AppColors.yellow,
  );

  /// `Modifié` — coral tint on danger ink.
  factory StatusChip.changed() => const StatusChip(
    label: 'Modifié',
    background: AppColors.arabicTint,
    foreground: AppColors.danger,
  );

  /// `Nouveau` — green tint on success ink.
  factory StatusChip.isNew() => const StatusChip(
    label: 'Nouveau',
    background: AppColors.successTint,
    foreground: AppColors.success,
    height: 22,
    horizontalPadding: 8,
  );

  /// `Hors connexion` — blue tint with a check.
  factory StatusChip.offline() => const StatusChip(
    label: 'Hors connexion',
    background: AppColors.background,
    foreground: AppColors.info,
    height: 22,
    horizontalPadding: 8,
    icon: AppIcons.check,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsetsDirectional.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingDot) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: foreground,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.x6),
          ],
          if (icon != null) ...[
            AppIcon(
              icon!,
              size: iconSize,
              strokeWidth: iconStrokeWidth,
              color: foreground,
            ),
            const SizedBox(width: AppSpacing.x4),
          ],
          Text(
            label,
            style: AppTextStyles.nunito(
              size: fontSize,
              weight: FontWeight.w800,
              color: foreground,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

/// A red count badge.
class UnreadBadge extends StatelessWidget {
  const UnreadBadge({
    super.key,
    required this.count,
    this.size = 22,
    this.fontSize = 12,
    this.borderColor,
  });

  final int count;
  final double size;
  final double fontSize;

  /// The dashboard bell badge is ringed with a 2px white border.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: size),
      height: size,
      alignment: Alignment.center,
      padding: EdgeInsetsDirectional.symmetric(horizontal: size >= 22 ? 6 : 4),
      decoration: BoxDecoration(
        color: AppColors.dangerStrong,
        borderRadius: BorderRadius.circular(size / 2),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 2),
      ),
      child: Text(
        '$count',
        textScaler: TextScaler.noScaling,
        style: AppTextStyles.nunito(
          size: fontSize,
          weight: FontWeight.w800,
          color: AppColors.white,
        ),
      ),
    );
  }
}

/// The small unread dot at the end of a notification row.
class UnreadDot extends StatelessWidget {
  const UnreadDot({super.key, this.size = 9});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Non lu',
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.dangerStrong,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
