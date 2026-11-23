import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/medallion.dart';
import '../../core/widgets/screen.dart';
import '../../core/widgets/subject_tile.dart';
import '../../core/widgets/zitoun.dart';
import '../../l10n/app_localizations.dart';

/// Board 13 · Mes alertes (élève).
///
/// A static board in the mockup: four fixed cards, no interactive state.
class StudentAlertsScreen extends StatelessWidget {
  const StudentAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return AppScreen(
      padding: AppSpacing.screenKid,
      gap: AppSpacing.x14,
      children: [
        Text(l10n.myAlerts, style: AppTextStyles.titleKid),

        // ------------------------------------------------------ swap card
        Container(
          padding: const EdgeInsets.all(AppSpacing.x18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.r28),
            boxShadow: AppShadows.ringCoral,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              PositionedDirectional(
                top: -28,
                start: 18,
                child: Container(
                  height: 26,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 12,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.coral,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    l10n.newLabel,
                    style: AppTextStyles.nunito(
                      size: 13,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.tuesdayChanges,
                          style: AppTextStyles.fredoka(size: 22, height: 1.2),
                        ),
                      ),
                      IconRoundButton(
                        icon: AppIcons.speaker,
                        semanticLabel: l10n.listen,
                        size: 52,
                        iconSize: 24,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x14),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.x12),
                    decoration: BoxDecoration(
                      color: AppColors.chipFill,
                      borderRadius: BorderRadius.circular(AppRadii.r22),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.5,
                          child: Column(
                            children: [
                              const SubjectTile(
                                subject: Subject.ma,
                                size: 64,
                                excludeSemantics: true,
                              ),
                              const SizedBox(height: AppSpacing.x4),
                              Text(
                                'Maths',
                                style: AppTextStyles.nunito(
                                  size: 14,
                                  weight: FontWeight.w800,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x14),
                        const AppIcon(
                          AppIcons.chevron,
                          size: 32,
                          strokeWidth: 3,
                          color: AppColors.danger,
                        ),
                        const SizedBox(width: AppSpacing.x14),
                        Column(
                          children: [
                            const SubjectTile(
                              subject: Subject.sp,
                              size: 64,
                              excludeSemantics: true,
                            ),
                            const SizedBox(height: AppSpacing.x4),
                            Text(
                              'Sport',
                              style: AppTextStyles.nunito(
                                size: 14,
                                weight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: AppSpacing.x14),
                        Container(
                          height: 34,
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 12,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AppIcon(AppIcons.clock, size: 16),
                              const SizedBox(width: AppSpacing.x4),
                              Text(
                                '15h',
                                style: AppTextStyles.nunito(
                                  size: 15,
                                  weight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // -------------------------------------------------- new lesson
        Container(
          padding: const EdgeInsets.all(AppSpacing.x16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.r28),
          ),
          child: Row(
            children: [
              const SubjectTile(
                subject: Subject.ar,
                size: 64,
                excludeSemantics: true,
              ),
              const SizedBox(width: AppSpacing.x14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.newLesson,
                      style: AppTextStyles.fredoka(size: 19, height: 1.2),
                    ),
                    Text(
                      'الحرف ب',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.baloo(
                        size: 22,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),
              IconRoundButton(
                icon: AppIcons.chevron,
                semanticLabel: l10n.seeLesson,
                size: 56,
                iconSize: 26,
                strokeWidth: 3,
                background: AppColors.navy,
                foreground: AppColors.white,
                boxShadow: AppShadows.none,
                onPressed: () {},
              ),
            ],
          ),
        ),

        // ---------------------------------------------------------- tree day
        Container(
          padding: const EdgeInsets.all(AppSpacing.x16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.r28),
          ),
          child: Row(
            children: [
              const Medallion(
                icon: AppIcons.sparkle,
                background: AppColors.successTint,
                foreground: AppColors.success,
                size: 64,
                radius: AppRadii.r22,
                iconSize: 32,
              ),
              const SizedBox(width: AppSpacing.x14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.treeDayTitle,
                      style: AppTextStyles.fredoka(size: 19, height: 1.2),
                    ),
                    Text(
                      l10n.treeDayBody,
                      style: AppTextStyles.nunito(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconRoundButton(
                icon: AppIcons.speaker,
                semanticLabel: l10n.listen,
                size: 52,
                iconSize: 24,
                background: AppColors.background,
                foreground: AppColors.navy,
                boxShadow: AppShadows.none,
                onPressed: () {},
              ),
            ],
          ),
        ),

        // --------------------------------------------------------- bravo
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 14, 16, 14),
          decoration: BoxDecoration(
            color: AppColors.warnTint,
            borderRadius: BorderRadius.circular(AppRadii.r28),
          ),
          child: Row(
            children: [
              const Zitoun(
                size: 84,
                mood: ZitounMood.bravo,
                excludeSemantics: true,
              ),
              const SizedBox(width: AppSpacing.x10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.bravoName('Lina'),
                      style: AppTextStyles.fredoka(
                        size: 22,
                        weight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      l10n.bravoBody,
                      style: AppTextStyles.nunito(
                        size: 15,
                        weight: FontWeight.w700,
                        height: 1.4,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
