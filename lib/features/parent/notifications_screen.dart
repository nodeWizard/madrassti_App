import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/alert_card.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/medallion.dart';
import '../../core/widgets/notification_row.dart';
import '../../core/widgets/screen.dart';
import '../../data/models/models.dart';
import '../../l10n/app_localizations.dart';
import 'dashboard_screen.dart' show notificationStyle;

/// Board 7 · Notifications.
///
/// A segmented filter, a pinned "À retenir" card, then sections by date.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  /// `null` means "Tout".
  NotificationKind? _filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(parentRepositoryProvider);
    final allRead = ref.watch(notificationsReadProvider);

    final filters = <({NotificationKind? kind, String label})>[
      (kind: null, label: l10n.filterEverything),
      (kind: NotificationKind.change, label: l10n.filterChanges),
      (kind: NotificationKind.lesson, label: l10n.filterLessons),
      (kind: NotificationKind.school, label: l10n.filterSchool),
    ];

    // The pinned card only shows under "Tout" and "Changements".
    final showPinned =
        _filter == null || _filter == NotificationKind.change;

    final sections = repo.notificationSections
        .map(
          (s) => (
            title: s.title,
            items: s.items
                .where((n) => _filter == null || n.kind == _filter)
                .toList(),
          ),
        )
        .where((s) => s.items.isNotEmpty)
        .toList();

    final pinned = repo.pinnedNotification;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppScreen(
        gap: AppSpacing.x16,
        children: [
          // -------------------------------------------------------- header
          Row(
            children: [
              IconSquareButton(
                icon: AppIcons.back,
                semanticLabel: l10n.backToHome,
                boxShadow: AppShadows.card,
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go(Routes.dashboard),
              ),
              const SizedBox(width: AppSpacing.x12),
              Expanded(child: Text(l10n.notifications, style: AppTextStyles.h2)),
              AppTextLink(
                label: l10n.markAllRead,
                onPressed: () =>
                    ref.read(notificationsReadProvider.notifier).set(true),
              ),
            ],
          ),

          // ------------------------------------------------------- filters
          Semantics(
            label: l10n.filter,
            container: true,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.x4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadii.r20),
              ),
              child: Row(
                children: [
                  for (var i = 0; i < filters.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.x4),
                    Expanded(
                      child: _SegmentButton(
                        label: filters[i].label,
                        selected: _filter == filters[i].kind,
                        onTap: () =>
                            setState(() => _filter = filters[i].kind),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // -------------------------------------------------------- pinned
          if (showPinned && pinned != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.toRemember.toUpperCase(),
                  style: AppTextStyles.sectionHeader(color: AppColors.danger),
                ),
                const SizedBox(height: AppSpacing.x8),
                AlertCard(
                  icon: AppIcons.user,
                  kicker: 'Absence · mardi 24',
                  trailingKicker: pinned.time,
                  title: pinned.title,
                  body: pinned.body,
                  titleSize: 17,
                  footer: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (pinned.who case final who?)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InitialAvatar(
                              initials: who.initial,
                              background: who.background,
                              foreground: who.foreground,
                              size: 22,
                              fontSize: 11,
                            ),
                            const SizedBox(width: AppSpacing.x6),
                            Text(
                              who.name,
                              style: AppTextStyles.nunito(
                                size: 13,
                                weight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      NavyButton(
                        label: l10n.seeTuesday,
                        height: 44,
                        radius: AppRadii.r14,
                        expand: false,
                        withShadow: false,
                        onPressed: () => context.go(Routes.week),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          // ------------------------------------------------------ sections
          for (final s in sections)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  s.title.toUpperCase(),
                  style: AppTextStyles.sectionHeader(),
                ),
                const SizedBox(height: AppSpacing.x8),
                NotificationList(
                  children: [
                    for (var i = 0; i < s.items.length; i++)
                      _row(s.items[i], i > 0, allRead),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _row(AppNotification n, bool divider, bool allRead) {
    final style = notificationStyle(n.kind);
    return NotificationRow(
      icon: style.icon,
      tint: style.tint,
      ink: style.ink,
      title: n.title,
      body: n.body,
      time: n.time,
      unread: n.unread && !allRead,
      showDivider: divider,
      whoChip: n.who == null
          ? null
          : WhoChip(
              name: n.who!.name,
              avatarColor: n.who!.background,
              avatarInk: n.who!.foreground,
            ),
    );
  }
}

/// One button of a segmented control.
class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.height = 44,
    this.radius = AppRadii.field,
    this.fontSize = 13,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double height;
  final double radius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : const Color(0x00000000),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.nunito(
              size: fontSize,
              weight: FontWeight.w800,
              height: 1.15,
              color: selected ? AppColors.white : AppColors.navy,
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable segmented button, also used by the teacher forms.
class SegmentButton extends StatelessWidget {
  const SegmentButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.height = 44,
    this.radius = AppRadii.r14,
    this.fontSize = 14,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double height;
  final double radius;
  final double fontSize;

  @override
  Widget build(BuildContext context) => _SegmentButton(
    label: label,
    selected: selected,
    onTap: onTap,
    height: height,
    radius: radius,
    fontSize: fontSize,
  );
}
