import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/alert_card.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/medallion.dart';
import '../../core/widgets/notification_row.dart';
import '../../core/widgets/screen.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/subject_tile.dart';
import '../../core/widgets/zitoun.dart';
import '../../data/mock/mock_clock.dart';
import '../../data/models/models.dart';
import '../../l10n/app_localizations.dart';

/// Board 4 · Accueil parent.
///
/// Board 4b ("page entière") is this same screen with `height: auto` — the
/// scroll view already provides that, so it is not a separate screen.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(parentRepositoryProvider);
    final clock = ref.watch(clockProvider);
    final childId = ref.watch(selectedChildProvider);
    final dismissed = ref.watch(alertDismissedProvider);

    final child = repo.childById(childId);
    final unread = child.notifications.where((n) => n.unread).length;
    final showAlert = child.hasAlert && !dismissed;

    return AppScreen(
      children: [
        // ------------------------------------------------------- header
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(clock.todayLabel, style: AppTextStyles.meta),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    l10n.greeting(repo.parentName),
                    style: AppTextStyles.h1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x12),
            Semantics(
              button: true,
              label: l10n.notificationsWithCount(unread),
              child: ExcludeSemantics(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.push(Routes.notifications),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                BorderRadius.circular(AppRadii.button),
                            boxShadow: AppShadows.card,
                          ),
                          child: const AppIcon(AppIcons.bell, size: 24),
                        ),
                        PositionedDirectional(
                          top: 7,
                          end: 7,
                          child: UnreadBadge(
                            count: unread,
                            size: 18,
                            fontSize: 11,
                            borderColor: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // -------------------------------------------------- child switcher
        Semantics(
          label: l10n.chooseChild,
          container: true,
          child: Row(
            children: [
              for (final c in repo.children) ...[
                if (c != repo.children.first)
                  const SizedBox(width: AppSpacing.x10),
                _ChildTab(
                  child: c,
                  selected: c.id == childId,
                  onTap: () =>
                      ref.read(selectedChildProvider.notifier).set(c.id),
                ),
              ],
            ],
          ),
        ),

        // ----------------------------------------------------- alert card
        if (showAlert)
          AlertCard(
            semanticLabel: l10n.importantChange,
            icon: AppIcons.swap,
            kicker: 'Demain · mardi 24',
            title: 'Mme Trabelsi sera absente',
            body:
                'L\'éveil scientifique de 14h est remplacé par une séance '
                'd\'arts.',
            actions: Row(
              children: [
                NavyButton(
                  label: l10n.seeTomorrow,
                  height: 48,
                  radius: AppRadii.r14,
                  expand: false,
                  withShadow: false,
                  onPressed: () => context.go(Routes.week),
                ),
                const SizedBox(width: AppSpacing.x8),
                OutlineButton(
                  label: l10n.understood,
                  height: 48,
                  radius: AppRadii.r14,
                  expand: false,
                  onPressed: () =>
                      ref.read(alertDismissedProvider.notifier).set(true),
                ),
              ],
            ),
          ),

        // ----------------------------------------------------- day ribbon
        _DayRibbon(child: child, hasChange: child.hasAlert),

        // ------------------------------------------------------ shortcuts
        Semantics(
          label: l10n.shortcuts,
          container: true,
          // IntrinsicHeight lets the three cards share the tallest height,
          // which is what `align-items: stretch` does in the mockup grid.
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _Shortcut(
                    icon: AppIcons.message,
                    tint: AppColors.infoTint,
                    ink: AppColors.info,
                    title: l10n.write,
                    subtitle: child.mainTeacher,
                    onTap: () => context.push(Routes.chat),
                  ),
                ),
                const SizedBox(width: AppSpacing.x10),
                Expanded(
                  child: _Shortcut(
                    icon: AppIcons.book,
                    tint: AppColors.successTint,
                    ink: AppColors.success,
                    title: l10n.lessonsLabel,
                    subtitle: child.newLessonsLabel,
                    subtitleColor: AppColors.success,
                    subtitleBold: true,
                    onTap: () => context.go(Routes.lessons),
                  ),
                ),
                const SizedBox(width: AppSpacing.x10),
                Expanded(
                  child: _Shortcut(
                    icon: AppIcons.calendar,
                    tint: AppColors.warnTint,
                    ink: AppColors.warn,
                    title: l10n.theWeek,
                    subtitle: l10n.timetable,
                    onTap: () => context.go(Routes.week),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ------------------------------------------------------- recently
        Semantics(
          label: l10n.recently,
          container: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionTitle(
                l10n.recently,
                style: AppTextStyles.h6,
                trailing: AppTextLink(
                  label: l10n.seeAll,
                  minHeight: 44,
                  onPressed: () => context.push(Routes.notifications),
                ),
              ),
              const SizedBox(height: AppSpacing.x6),
              NotificationList(
                children: [
                  for (var i = 0; i < child.notifications.length; i++)
                    _notificationRow(child.notifications[i], i > 0),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _notificationRow(AppNotification n, bool divider) {
    final style = notificationStyle(n.kind);
    return NotificationRow(
      icon: style.icon,
      tint: style.tint,
      ink: style.ink,
      title: n.title,
      body: n.body,
      time: n.time,
      unread: n.unread,
      showDivider: divider,
    );
  }
}

/// Medallion colours per notification category, from the mockups.
({String icon, Color tint, Color ink}) notificationStyle(
  NotificationKind kind,
) => switch (kind) {
  NotificationKind.lesson => (
    icon: AppIcons.book,
    tint: AppColors.successTint,
    ink: AppColors.success,
  ),
  NotificationKind.change => (
    icon: AppIcons.swap,
    tint: AppColors.warnTint,
    ink: AppColors.warn,
  ),
  NotificationKind.school => (
    icon: AppIcons.mega,
    tint: AppColors.infoTint,
    ink: AppColors.info,
  ),
  NotificationKind.message => (
    icon: AppIcons.message,
    tint: AppColors.sportTint,
    ink: AppColors.navy,
  ),
};

class _ChildTab extends StatelessWidget {
  const _ChildTab({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  final Child child;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.white : AppColors.navy;
    return Semantics(
      button: true,
      selected: selected,
      label: '${child.name}, ${child.grade}',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            height: 52,
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 16, 0),
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : AppColors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: selected ? AppColors.navy : AppColors.cardBorder,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InitialAvatar(
                  initials: child.initial,
                  background: child.avatarBackground,
                  foreground: child.avatarForeground,
                  size: 36,
                  fontSize: 17,
                ),
                const SizedBox(width: AppSpacing.x10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      child.name,
                      style: AppTextStyles.nunito(
                        size: 15,
                        weight: FontWeight.w800,
                        height: 1.15,
                        color: fg,
                      ),
                    ),
                    Text(
                      child.grade,
                      style: AppTextStyles.nunito(
                        size: 12,
                        weight: FontWeight.w700,
                        height: 1.15,
                        color: fg.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The navy "ruban de la journée": a proportional timeline with the mascot
/// standing at the current time, the current course, and the next one.
class _DayRibbon extends ConsumerWidget {
  const _DayRibbon({required this.child, required this.hasChange});

  final Child child;
  final bool hasChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final now = ref.watch(clockProvider).now;
    final lessons = child.timetable;

    final currentIndex = lessons.indexWhere(
      (b) => b.start.minutes <= now.minutes && now.minutes < b.end.minutes,
    );
    final current = lessons[currentIndex];
    final next = currentIndex + 1 < lessons.length
        ? lessons[currentIndex + 1]
        : current;

    final currentStyle = AppSubjects.of(current.subject);
    final nextStyle = AppSubjects.of(next.subject);

    double pct(MinuteOfDay m) =>
        (m.minutes - MockClock.dayStart.minutes) / MockClock.daySpan;

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(18, 20, 18, 14),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppRadii.r28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.dayOf(child.name),
                  style: AppTextStyles.fredoka(
                    size: 20,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              StatusChip(
                label: hasChange ? l10n.changeTomorrow : l10n.normalDay,
                background: hasChange
                    ? AppColors.arabicTint
                    : AppColors.successTint,
                foreground: hasChange ? AppColors.danger : AppColors.success,
                height: 28,
                fontSize: 12,
                horizontalPadding: 10,
                leadingDot: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x14),

          // ---- timeline
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 50),
            child: SizedBox(
              height: 30,
              child: LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Lunch break, drawn behind the segments.
                      PositionedDirectional(
                        start: w * 0.5,
                        width: w * 0.25 - 3,
                        height: 30,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppRadii.seg),
                            border: Border.all(
                              color: AppColors.navyDash,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            l10n.breakLabel,
                            style: AppTextStyles.nunito(
                              size: 11,
                              weight: FontWeight.w800,
                              color: AppColors.onNavySubtle,
                            ),
                          ),
                        ),
                      ),
                      for (final b in lessons)
                        PositionedDirectional(
                          start: w * pct(b.start),
                          width:
                              w * (b.durationMinutes / MockClock.daySpan) - 3,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppSubjects.of(b.subject).tint.withValues(
                                alpha: b.end.minutes <= now.minutes ? 0.35 : 1,
                              ),
                              borderRadius:
                                  BorderRadius.circular(AppRadii.seg),
                              boxShadow:
                                  b.start.minutes <= now.minutes &&
                                      now.minutes < b.end.minutes
                                  ? AppShadows.ringNow
                                  : null,
                            ),
                          ),
                        ),
                      // "Now" marker line.
                      PositionedDirectional(
                        start: w * pct(now) - 1.5,
                        top: -6,
                        child: Container(
                          width: 3,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Zitoun standing at "now".
                      PositionedDirectional(
                        start: w * pct(now) - 22,
                        bottom: 34,
                        child: const Zitoun(size: 44, excludeSemantics: true),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 0),
          Transform.translate(
            offset: const Offset(0, -6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final t in const ['8h', '10h', '12h', '14h', '16h'])
                  Text(
                    t,
                    style: AppTextStyles.nunito(
                      size: 11,
                      weight: FontWeight.w700,
                      color: AppColors.onNavySubtle,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x14),

          // ---- current course
          Container(
            padding: const EdgeInsets.all(AppSpacing.x14),
            decoration: BoxDecoration(
              color: AppColors.navyCard,
              borderRadius: BorderRadius.circular(AppRadii.r20),
            ),
            child: Row(
              children: [
                SubjectTile(
                  subject: current.subject,
                  size: 56,
                  excludeSemantics: true,
                ),
                const SizedBox(width: AppSpacing.x14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nowRemaining(current.end.minutes - now.minutes),
                        style: AppTextStyles.kicker(color: AppColors.yellow),
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      Text(
                        currentStyle.name,
                        style: AppTextStyles.fredoka(
                          size: 19,
                          height: 1.2,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      Text(
                        '${current.range} · ${current.teacher} · '
                        '${current.room}',
                        style: AppTextStyles.nunito(
                          size: 13,
                          weight: FontWeight.w400,
                          color: AppColors.onNavyMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x6),
                      _Progress(
                        value:
                            (now.minutes - current.start.minutes) /
                            current.durationMinutes,
                        track: AppColors.navyTrack,
                        fill: AppColors.yellow,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---- next course
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.go(Routes.week),
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 42,
                    child: Text(
                      next.start.hhmm,
                      style: AppTextStyles.nunito(
                        size: 13,
                        weight: FontWeight.w800,
                        color: AppColors.onNavySubtle,
                      ),
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: nextStyle.tint,
                      borderRadius: BorderRadius.circular(AppRadii.xs),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x12),
                  Expanded(
                    child: Text(
                      l10n.nextLesson(nextStyle.name),
                      style: AppTextStyles.nunito(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const AppIcon(
                    AppIcons.chevron,
                    size: 20,
                    strokeWidth: 2.2,
                    color: AppColors.onNavySubtle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({
    required this.value,
    required this.track,
    required this.fill,
  });

  final double value;
  final Color track;
  final Color fill;

  /// Matches the 6px track of the mockups.
  static const double height = 6;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: track)),
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.icon,
    required this.tint,
    required this.ink,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.subtitleColor = AppColors.inkSubtle,
    this.subtitleBold = false,
  });

  final String icon;
  final Color tint;
  final Color ink;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color subtitleColor;
  final bool subtitleBold;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title, $subtitle',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 108),
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x12,
              vertical: AppSpacing.x14,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r20),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Medallion(
                  icon: icon,
                  background: tint,
                  foreground: ink,
                  size: 40,
                  iconSize: 22,
                ),
                const SizedBox(height: AppSpacing.x10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.nunito(
                        size: 14,
                        weight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      subtitle,
                      style: AppTextStyles.nunito(
                        size: 12,
                        weight: subtitleBold
                            ? FontWeight.w800
                            : FontWeight.w700,
                        color: subtitleColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
