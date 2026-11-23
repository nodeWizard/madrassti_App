import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/fields.dart';
import '../../core/widgets/screen.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/subject_tile.dart';
import '../../data/models/models.dart';
import '../../l10n/app_localizations.dart';

/// Board 6 · Leçons et documents.
class LessonsScreen extends ConsumerStatefulWidget {
  const LessonsScreen({super.key});

  @override
  ConsumerState<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends ConsumerState<LessonsScreen> {
  /// `null` means "Toutes".
  Subject? _filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(parentRepositoryProvider);
    final child = repo.childById(ref.watch(selectedChildProvider));

    final filters = <({Subject? subject, String label})>[
      (subject: null, label: l10n.filterAll),
      (subject: Subject.fr, label: l10n.filterFrench),
      (subject: Subject.ma, label: l10n.filterMaths),
      (subject: Subject.ar, label: l10n.filterArabic),
      (subject: Subject.ev, label: l10n.filterScience),
    ];

    final groups = repo.documentGroups
        .where((g) => _filter == null || g.subject == _filter)
        .toList();

    return AppScreen(
      gap: AppSpacing.x16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${child.name} · ${child.grade}', style: AppTextStyles.meta),
            const SizedBox(height: AppSpacing.x2),
            Text(l10n.lessonsTitle, style: AppTextStyles.h2),
          ],
        ),

        // --------------------------------------------------------- search
        Container(
          height: 52,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.button),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              const AppIcon(
                AppIcons.search,
                size: 20,
                color: AppColors.inkSubtle,
              ),
              const SizedBox(width: AppSpacing.x10),
              Expanded(
                child: EditableTextField(
                  hintText: l10n.searchLesson,
                  semanticLabel: l10n.searchLesson,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // -------------------------------------------------------- filters
        // The mockup lets this row bleed to the screen edges; a full-width
        // horizontal list with matching padding gives the same result.
        Semantics(
          label: l10n.filterBySubject,
          container: true,
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: filters.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.x8),
              itemBuilder: (context, i) => _FilterChip(
                label: filters[i].label,
                selected: _filter == filters[i].subject,
                onTap: () => setState(() => _filter = filters[i].subject),
              ),
            ),
          ),
        ),

        // --------------------------------------------------------- groups
        for (final g in groups) _Group(group: g),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.r20),
            border: Border.all(
              color: selected ? AppColors.navy : AppColors.cardBorder,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.nunito(
              size: 14,
              weight: FontWeight.w800,
              color: selected ? AppColors.white : AppColors.navy,
            ),
          ),
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.group});

  final DocumentGroup group;

  @override
  Widget build(BuildContext context) {
    final style = AppSubjects.of(group.subject);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SubjectTile(
              subject: group.subject,
              size: 32,
              excludeSemantics: true,
            ),
            const SizedBox(width: AppSpacing.x10),
            Expanded(
              child: Text(style.name, style: AppTextStyles.cardTitle),
            ),
            Text(
              group.countLabel,
              style: AppTextStyles.nunito(
                size: 13,
                weight: FontWeight.w800,
                color: AppColors.inkSubtle,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x10),
        for (final d in group.documents) ...[
          if (d != group.documents.first)
            const SizedBox(height: AppSpacing.x8),
          _DocumentRow(
            document: d,
            band: AppSubjects.documentBand[group.subject] ?? AppColors.yellow,
          ),
        ],
      ],
    );
  }
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.document, required this.band});

  final LessonDocument document;
  final Color band;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadii.r20),
      ),
      child: Row(
        children: [
          _Thumbnail(band: band, type: document.type),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  // Arabic titles must read right-to-left on their own.
                  textDirection: _directionOf(document.title),
                  style: AppTextStyles.nunito(
                    size: 15,
                    weight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  document.meta,
                  style: AppTextStyles.nunito(
                    size: 13,
                    color: AppColors.inkSubtle,
                  ),
                ),
                if (document.isNew || document.offline) ...[
                  const SizedBox(height: AppSpacing.x5),
                  Row(
                    children: [
                      if (document.isNew) StatusChip.isNew(),
                      if (document.offline) StatusChip.offline(),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x12),
          IconSquareButton(
            icon: document.offline ? AppIcons.file : AppIcons.download,
            semanticLabel: l10n.download(document.title),
            background: AppColors.background,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  /// Arabic blocks read RTL; everything else follows the ambient direction.
  TextDirection? _directionOf(String text) =>
      RegExp(r'[؀-ۿ]').hasMatch(text) ? TextDirection.rtl : null;
}

/// The little page preview: a coloured band, four grey rules and a type badge.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.band, required this.type});

  final Color band;
  final String type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 64,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.thumb),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.thumb),
            border: Border.all(color: AppColors.thumbBorder, width: 1.5),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(height: 10, color: band),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(7, 16, 7, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final w in const [1.0, 0.8, 0.9, 0.6]) ...[
                      if (w != 1.0) const SizedBox(height: AppSpacing.x4),
                      FractionallySizedBox(
                        widthFactor: w,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.cardShadow,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              PositionedDirectional(
                bottom: 4,
                end: 4,
                child: Container(
                  height: 16,
                  alignment: Alignment.center,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    type,
                    textScaler: TextScaler.noScaling,
                    style: AppTextStyles.badgeMicro.copyWith(
                      color: AppColors.white,
                    ),
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
