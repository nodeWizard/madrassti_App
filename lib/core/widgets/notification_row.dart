import 'package:flutter/widgets.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'medallion.dart';
import 'status_chip.dart';

/// A notification row. See `docs/SPEC.md` §3.8.
class NotificationRow extends StatelessWidget {
  const NotificationRow({
    super.key,
    required this.icon,
    required this.tint,
    required this.ink,
    required this.title,
    required this.body,
    required this.time,
    this.unread = false,
    this.showDivider = false,
    this.whoChip,
  });

  final String icon;
  final Color tint;
  final Color ink;
  final String title;
  final String body;
  final String time;
  final bool unread;

  /// A 1.5px top separator — every row but the first.
  final bool showDivider;

  /// The "who" pill shown on the notifications screen.
  final Widget? whoChip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.x8,
        AppSpacing.x12,
        AppSpacing.x8,
        AppSpacing.x12,
      ),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                top: BorderSide(color: AppColors.divider, width: 1.5),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Medallion(
            icon: icon,
            background: tint,
            foreground: ink,
            size: 40,
            radius: AppRadii.medallion,
            iconSize: 20,
          ),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(title, style: AppTextStyles.rowTitle)),
                    const SizedBox(width: AppSpacing.x8),
                    Text(
                      time,
                      style: AppTextStyles.metaSmall,
                      maxLines: 1,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(body, style: AppTextStyles.notifBody),
                if (whoChip != null) ...[
                  const SizedBox(height: AppSpacing.x4),
                  whoChip!,
                ],
              ],
            ),
          ),
          if (unread) ...[
            const SizedBox(width: AppSpacing.x12),
            const Padding(
              padding: EdgeInsetsDirectional.only(top: AppSpacing.x6),
              child: UnreadDot(),
            ),
          ],
        ],
      ),
    );
  }
}

/// The white rounded container that holds notification rows.
class NotificationList extends StatelessWidget {
  const NotificationList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x6,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadii.r22),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

/// The "who" pill: a tiny avatar plus a name.
class WhoChip extends StatelessWidget {
  const WhoChip({
    super.key,
    required this.name,
    required this.avatarColor,
    required this.avatarInk,
  });

  final String name;
  final Color avatarColor;
  final Color avatarInk;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsetsDirectional.fromSTEB(3, 0, 8, 0),
      decoration: BoxDecoration(
        color: AppColors.chipFill,
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InitialAvatar(
            initials: name.characters.first,
            background: avatarColor,
            foreground: avatarInk,
            size: 16,
            fontSize: 9,
          ),
          const SizedBox(width: AppSpacing.x5),
          Text(name, style: AppTextStyles.chip12),
        ],
      ),
    );
  }
}
