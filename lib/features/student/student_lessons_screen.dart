import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/screen.dart';
import '../../core/widgets/subject_tile.dart';
import '../../core/widgets/zitoun.dart';
import '../../l10n/app_localizations.dart';

/// Board 12 · Mes leçons (élève).
///
/// A 3-column subject grid, then the selected subject's lessons. The ☀ and ✿
/// glyphs for Éveil and Arts fall back to the system font — they are not
/// among the mockups' 39 icons (`docs/SPEC.md` §5.1 A7).
class StudentLessonsScreen extends ConsumerStatefulWidget {
  const StudentLessonsScreen({super.key});

  @override
  ConsumerState<StudentLessonsScreen> createState() =>
      _StudentLessonsScreenState();
}

class _StudentLessonsScreenState extends ConsumerState<StudentLessonsScreen> {
  Subject _subject = Subject.ar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(studentRepositoryProvider);
    final lessons = repo.lessons[_subject] ?? const [];
    final style = AppSubjects.of(_subject);

    return AppScreen(
      padding: AppSpacing.screenKid,
      gap: AppSpacing.x14,
      children: [
        Text(l10n.myLessons, style: AppTextStyles.titleKid),

        Semantics(
          label: l10n.subjects,
          container: true,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.x10,
            mainAxisSpacing: AppSpacing.x10,
            childAspectRatio: 1,
            children: [
              for (final s in Subject.values)
                _SubjectButton(
                  subject: s,
                  selected: s == _subject,
                  hasNew: (repo.lessons[s] ?? const [])
                      .any((l) => l.isNew),
                  onTap: () => setState(() => _subject = s),
                ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.x6),
          child: Text(style.name, style: AppTextStyles.h4),
        ),

        if (lessons.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.x18),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r24),
            ),
            child: Column(
              children: [
                const Zitoun(size: 90, excludeSemantics: true),
                const SizedBox(height: AppSpacing.x8),
                Text(
                  l10n.nothingNewHere,
                  style: AppTextStyles.fredoka(size: 19),
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  l10n.teacherWillAdd,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.nunito(
                    size: 15,
                    weight: FontWeight.w600,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          )
        else
          for (var i = 0; i < lessons.length; i++)
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: i > 0 ? AppSpacing.x8 : 0,
              ),
              child: _LessonRow(
                subject: _subject,
                glyph: lessons[i].glyph,
                title: lessons[i].title,
                isNew: lessons[i].isNew,
              ),
            ),
      ],
    );
  }
}

class _SubjectButton extends StatelessWidget {
  const _SubjectButton({
    required this.subject,
    required this.selected,
    required this.hasNew,
    required this.onTap,
  });

  final Subject subject;
  final bool selected;
  final bool hasNew;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = AppSubjects.of(subject);
    return Semantics(
      button: true,
      selected: selected,
      label: hasNew ? '${style.name}, nouveau' : style.name,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadii.r24),
                  border: Border.all(
                    color: selected
                        ? AppColors.navy
                        : const Color(0x00000000),
                    width: 3,
                  ),
                  boxShadow: selected ? AppShadows.selected : AppShadows.card,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SubjectTile(
                      subject: subject,
                      size: 56,
                      excludeSemantics: true,
                    ),
                    const SizedBox(height: AppSpacing.x8),
                    Text(
                      style.shortName,
                      style: AppTextStyles.nunito(
                        size: 15,
                        weight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasNew)
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: const AppIcon(
                      AppIcons.sparkle,
                      size: 16,
                      strokeWidth: 2.5,
                      color: AppColors.navy,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  const _LessonRow({
    required this.subject,
    required this.glyph,
    required this.title,
    required this.isNew,
  });

  final Subject subject;
  final String glyph;
  final String title;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final style = AppSubjects.of(subject);
    final isArabic = RegExp(r'[؀-ۿ]').hasMatch(glyph);

    return Semantics(
      button: true,
      label: isNew ? '${l10n.newExclaim} $title' : title,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.x12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r24),
              boxShadow: isNew ? AppShadows.ringNowKid : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 72,
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: style.tint,
                    borderRadius: BorderRadius.circular(AppRadii.thumb),
                  ),
                  child: Text(
                    glyph,
                    textDirection: isArabic ? TextDirection.rtl : null,
                    style: isArabic
                        ? AppTextStyles.baloo(
                            size: 30,
                            weight: FontWeight.w700,
                            color: style.ink,
                          )
                        : AppTextStyles.fredoka(
                            size: 30,
                            weight: FontWeight.w700,
                            color: style.ink,
                          ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isNew) ...[
                        Container(
                          height: 24,
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 10,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            l10n.newExclaim,
                            style: AppTextStyles.nunito(
                              size: 12,
                              weight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                      ],
                      Text(
                        title,
                        textDirection: isArabic ? TextDirection.rtl : null,
                        style: AppTextStyles.fredoka(size: 19, height: 1.25),
                      ),
                    ],
                  ),
                ),
                IconRoundButton(
                  icon: AppIcons.chevron,
                  semanticLabel: l10n.openLesson(title),
                  size: 60,
                  iconSize: 28,
                  strokeWidth: 3,
                  boxShadow: AppShadows.yellowButtonKid,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
