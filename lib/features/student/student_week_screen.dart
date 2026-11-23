import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/screen.dart';
import '../../core/widgets/subject_tile.dart';
import '../../core/widgets/zitoun.dart';
import '../../l10n/app_localizations.dart';

/// Board 11 · Ma semaine (élève).
///
/// Subject names here use the student's short forms ("Maths", "Éveil") —
/// deliberately different from the parent's full names
/// (`docs/SPEC.md` §4.3).
class StudentWeekScreen extends ConsumerStatefulWidget {
  const StudentWeekScreen({super.key});

  @override
  ConsumerState<StudentWeekScreen> createState() => _StudentWeekScreenState();
}

class _StudentWeekScreenState extends ConsumerState<StudentWeekScreen> {
  int _day = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(studentRepositoryProvider);
    final clock = ref.watch(clockProvider);
    final week = repo.week;
    final day = week[_day];
    final isToday = _day == clock.todayIndex;

    return AppScreen(
      padding: AppSpacing.screenKid,
      gap: AppSpacing.x14,
      children: [
        Text(l10n.myWeek, style: AppTextStyles.titleKid),

        Semantics(
          label: l10n.days,
          container: true,
          child: Row(
            children: [
              for (var i = 0; i < week.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.x6),
                Expanded(
                  child: _DayButton(
                    label: week[i].label,
                    selected: i == _day,
                    isToday: i == clock.todayIndex,
                    onTap: () => setState(() => _day = i),
                  ),
                ),
              ],
            ],
          ),
        ),

        Row(
          children: [
            const AppIcon(AppIcons.sun, size: 22, color: AppColors.warn),
            const SizedBox(width: AppSpacing.x8),
            Text(l10n.morning, style: AppTextStyles.h6),
          ],
        ),
        for (var i = 0; i < day.morning.length; i++)
          Padding(
            padding: EdgeInsetsDirectional.only(
              top: i > 0 ? AppSpacing.x8 : 0,
            ),
            child: _CourseRow(
              subject: day.morning[i].subject,
              time: day.morning[i].time,
              ring: isToday && i == 2,
            ),
          ),

        Row(
          children: [
            const AppIcon(AppIcons.moon, size: 20, color: AppColors.info),
            const SizedBox(width: AppSpacing.x8),
            Text(l10n.afternoon, style: AppTextStyles.h6),
          ],
        ),
        if (day.afternoon.isNotEmpty)
          for (var i = 0; i < day.afternoon.length; i++)
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: i > 0 ? AppSpacing.x8 : 0,
              ),
              child: _CourseRow(
                subject: day.afternoon[i].subject,
                time: day.afternoon[i].time,
                ring: false,
              ),
            )
        else
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 16, 12),
            decoration: BoxDecoration(
              color: AppColors.successTint,
              borderRadius: BorderRadius.circular(AppRadii.r24),
            ),
            child: Row(
              children: [
                const Zitoun(
                  size: 64,
                  mood: ZitounMood.bravo,
                  excludeSemantics: true,
                ),
                const SizedBox(width: AppSpacing.x12),
                Expanded(
                  child: Text(
                    l10n.noSchoolPlay,
                    style: AppTextStyles.fredoka(size: 20),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DayButton extends StatelessWidget {
  const _DayButton({
    required this.label,
    required this.selected,
    required this.isToday,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r20),
              border: Border.all(
                color: isToday && !selected
                    ? AppColors.yellow
                    : const Color(0x00000000),
                width: 2.5,
              ),
              boxShadow: selected
                  ? AppShadows.selectedKidDay
                  : AppShadows.card,
            ),
            child: Text(
              label,
              style: AppTextStyles.fredoka(
                size: 17,
                color: selected ? AppColors.white : AppColors.navy,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseRow extends StatelessWidget {
  const _CourseRow({
    required this.subject,
    required this.time,
    required this.ring,
  });

  final Subject subject;
  final String time;
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final style = AppSubjects.of(subject);
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 14, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadii.r24),
        boxShadow: ring ? AppShadows.ringNowKid : null,
      ),
      child: Row(
        children: [
          SubjectTile(subject: subject, size: 60, excludeSemantics: true),
          const SizedBox(width: AppSpacing.x14),
          Expanded(
            child: Text(style.shortName, style: AppTextStyles.fredoka(size: 21)),
          ),
          Container(
            height: 34,
            alignment: Alignment.center,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Text(
              time,
              style: AppTextStyles.nunito(size: 15, weight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
