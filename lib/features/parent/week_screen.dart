import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/medallion.dart';
import '../../core/widgets/screen.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/subject_tile.dart';
import '../../core/widgets/zitoun.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../l10n/app_localizations.dart';

/// Board 5 · Semaine — the week timetable.
///
/// Blocks are sized by duration (`max(68, round(minutes * 0.9))`), tinted with
/// the lighter subject *wash*, and carry the "En cours" / "Modifié" chips.
class WeekScreen extends ConsumerStatefulWidget {
  const WeekScreen({super.key});

  @override
  ConsumerState<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends ConsumerState<WeekScreen> {
  int _day = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(parentRepositoryProvider);
    final clock = ref.watch(clockProvider);
    final child = repo.childById(ref.watch(selectedChildProvider));
    final week = repo.week;
    final day = week[_day];
    final isToday = _day == clock.todayIndex;
    final now = clock.now;

    final first = day.lessons.first.start;
    final last = day.lessons.last.end;

    return AppScreen(
      gap: AppSpacing.x16,
      children: [
        // --------------------------------------------------------- header
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.weekRange, style: AppTextStyles.meta),
                  const SizedBox(height: AppSpacing.x2),
                  Text(l10n.timetable, style: AppTextStyles.h2),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x12),
            Container(
              height: 48,
              padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 12, 0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadii.r24),
                border: Border.all(color: AppColors.cardBorder, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InitialAvatar(
                    initials: child.initial,
                    background: child.avatarBackground,
                    foreground: child.avatarForeground,
                    size: 34,
                    fontSize: 16,
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  Text(child.name, style: AppTextStyles.buttonSmall),
                ],
              ),
            ),
          ],
        ),

        // ------------------------------------------------------ day tabs
        Semantics(
          label: l10n.weekDays,
          container: true,
          child: Row(
            children: [
              for (var i = 0; i < week.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.x6),
                Expanded(
                  child: _DayTab(
                    day: week[i],
                    selected: i == _day,
                    isToday: i == clock.todayIndex,
                    onTap: () => setState(() => _day = i),
                  ),
                ),
              ],
            ],
          ),
        ),

        // --------------------------------------------------- day summary
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                isToday ? l10n.todayWithDay(day.fullLabel) : day.fullLabel,
                style: AppTextStyles.h6,
              ),
            ),
            const SizedBox(width: AppSpacing.x8),
            Text(
              l10n.daySummary(day.lessons.length, first.short, last.short),
              style: AppTextStyles.nunito(
                size: 13,
                weight: FontWeight.w800,
                color: AppColors.inkSubtle,
              ),
            ),
          ],
        ),

        // ---------------------------------------------------------- rows
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _rows(context, repo, day, isToday, now),
        ),
      ],
    );
  }

  List<Widget> _rows(
    BuildContext context,
    ParentRepository repo,
    SchoolDay day,
    bool isToday,
    MinuteOfDay now,
  ) {
    final l10n = AppL10n.of(context);
    final rows = <Widget>[];
    var pauseDone = false;

    void gap() {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: AppSpacing.x8));
    }

    for (final b in day.lessons) {
      // The lunch break is inserted before the first afternoon course.
      if (b.start.minutes >= 840 && !pauseDone) {
        gap();
        rows.add(
          _TimelineRow(
            start: '12:00',
            end: '14:00',
            child: Container(
              height: 52,
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.button),
                border: Border.all(
                  color: AppColors.dashedBorder,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const AppIcon(
                    AppIcons.sun,
                    size: 18,
                    color: AppColors.inkSubtle,
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  Text(
                    l10n.lunchBreak,
                    style: AppTextStyles.nunito(
                      size: 14,
                      weight: FontWeight.w800,
                      color: AppColors.inkSubtle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        pauseDone = true;
      }

      final past = isToday && b.end.minutes <= now.minutes;
      final isNow =
          isToday && b.start.minutes <= now.minutes && now.minutes < b.end.minutes;

      gap();
      rows.add(
        Opacity(
          opacity: past ? 0.5 : 1,
          child: _TimelineRow(
            start: b.start.hhmm,
            end: b.end.hhmm,
            child: _LessonBlock(
              lesson: b,
              isNow: isNow,
              now: now,
              whoLabel: repo.whoLabel(b.subject),
            ),
          ),
        ),
      );
    }

    // Wednesdays and Saturdays have no afternoon.
    if (!pauseDone) {
      gap();
      rows.add(
        _TimelineRow(
          start: '12:00',
          end: '',
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.x14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r20),
            ),
            child: Row(
              children: [
                const Zitoun(
                  size: 52,
                  mood: ZitounMood.bravo,
                  excludeSemantics: true,
                ),
                const SizedBox(width: AppSpacing.x12),
                Expanded(
                  child: Text(
                    l10n.freeAfternoon,
                    style: AppTextStyles.nunito(
                      size: 15,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return rows;
  }
}

/// A row: the start/end times in a fixed 46px gutter, then the block.
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.start,
    required this.end,
    required this.child,
  });

  final String start;
  final String end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 46,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(top: AppSpacing.x10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  start,
                  style: AppTextStyles.nunito(
                    size: 14,
                    weight: FontWeight.w800,
                  ),
                ),
                if (end.isNotEmpty)
                  Text(end, style: AppTextStyles.metaSmall),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x10),
        Expanded(child: child),
      ],
    );
  }
}

class _LessonBlock extends StatelessWidget {
  const _LessonBlock({
    required this.lesson,
    required this.isNow,
    required this.now,
    required this.whoLabel,
  });

  final Lesson lesson;
  final bool isNow;
  final MinuteOfDay now;
  final String whoLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final style = AppSubjects.of(lesson.subject);
    // The mockup sizes blocks by duration.
    final minHeight = (lesson.durationMinutes * 0.9).round().clamp(68, 9999);

    return Container(
      constraints: BoxConstraints(minHeight: minHeight.toDouble()),
      padding: const EdgeInsets.all(AppSpacing.x12),
      decoration: BoxDecoration(
        color: isNow ? AppColors.white : style.wash,
        borderRadius: BorderRadius.circular(AppRadii.r20),
        boxShadow: isNow ? AppShadows.ringNow : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubjectTile(
            subject: lesson.subject,
            size: 44,
            excludeSemantics: true,
          ),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(style.name, style: AppTextStyles.blockTitle),
                    ),
                    if (isNow) ...[
                      const SizedBox(width: AppSpacing.x6),
                      StatusChip.inProgress(),
                    ] else if (lesson.changed) ...[
                      const SizedBox(width: AppSpacing.x6),
                      StatusChip.changed(),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  whoLabel,
                  style: AppTextStyles.nunito(
                    size: 13,
                    color: AppColors.inkMuted,
                  ),
                ),
                if (lesson.changed) ...[
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    l10n.replacesScience,
                    style: AppTextStyles.nunito(
                      size: 13,
                      weight: FontWeight.w700,
                      height: 1.4,
                      color: AppColors.danger,
                    ),
                  ),
                ],
                if (isNow) ...[
                  const SizedBox(height: AppSpacing.x6),
                  // The mockup hard-codes 39%; the real figure at 10:20 is
                  // 38.9%, so it is computed instead (docs/SPEC.md §5.1 A8).
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: SizedBox(
                      height: 6,
                      child: Stack(
                        children: [
                          const Positioned.fill(
                            child: ColoredBox(color: AppColors.white),
                          ),
                          FractionallySizedBox(
                            widthFactor:
                                ((now.minutes - lesson.start.minutes) /
                                        lesson.durationMinutes)
                                    .clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.info,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayTab extends StatelessWidget {
  const _DayTab({
    required this.day,
    required this.selected,
    required this.isToday,
    required this.onTap,
  });

  final SchoolDay day;
  final bool selected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final bg = selected ? AppColors.navy : AppColors.white;
    final fg = selected ? AppColors.white : AppColors.navy;

    return Semantics(
      button: true,
      selected: selected,
      label: '${day.fullLabel}'
          '${day.hasChange ? ', ${l10n.changeLabel}' : ''}',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 68,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(AppRadii.button),
                    border: Border.all(
                      color: isToday && !selected
                          ? AppColors.yellow
                          : const Color(0x00000000),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.shortLabel,
                        style: AppTextStyles.nunito(
                          size: 12,
                          weight: FontWeight.w800,
                          color: fg.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        '${day.dayNumber}',
                        style: AppTextStyles.fredoka(
                          size: 20,
                          height: 1,
                          color: fg,
                        ),
                      ),
                    ],
                  ),
                ),
                if (day.hasChange)
                  PositionedDirectional(
                    top: 6,
                    end: 6,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: AppColors.dangerDot,
                        shape: BoxShape.circle,
                        border: Border.all(color: bg, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
