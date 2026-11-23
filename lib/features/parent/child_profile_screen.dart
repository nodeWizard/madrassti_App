import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/medallion.dart';
import '../../core/widgets/screen.dart';
import '../../core/widgets/subject_tile.dart';
import '../../l10n/app_localizations.dart';

/// Board 9 · Profil de l'enfant.
///
/// The bracketed placeholders ("[Adresse de l'école]", "[JJ/MM/AAAA]",
/// "[Nom · téléphone]") are literal text in the mockup and reproduced as-is.
class ChildProfileScreen extends ConsumerWidget {
  const ChildProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(parentRepositoryProvider);
    final child = repo.childById(ref.watch(selectedChildProvider));

    // "Ses enseignants" — the mockup lists all four school teachers, not
    // only the ones teaching this particular child.
    const teachers = [
      (subject: Subject.ma, name: 'Mme Ben Salah',
        role: 'Enseignante principale · arabe et maths'),
      (subject: Subject.fr, name: 'M. Gharbi', role: 'Français'),
      (subject: Subject.ev, name: 'Mme Trabelsi', role: 'Éveil scientifique'),
      (subject: Subject.sp, name: 'M. Jlassi', role: 'Sport'),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppScreen(
        gap: AppSpacing.x14,
        children: [
          Row(
            children: [
              IconSquareButton(
                icon: AppIcons.back,
                semanticLabel: l10n.back,
                boxShadow: AppShadows.card,
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go(Routes.settings),
              ),
              const SizedBox(width: AppSpacing.x12),
              Expanded(
                child: Text(l10n.childProfile, style: AppTextStyles.h3),
              ),
            ],
          ),

          // -------------------------------------------------------- hero
          Container(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsetsDirectional.fromSTEB(18, 22, 18, 18),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(AppRadii.r28),
            ),
            child: Stack(
              children: [
                const PositionedDirectional(
                  top: -60,
                  end: -50,
                  child: _Circle(size: 180, color: AppColors.navyDeep),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InitialAvatar(
                          initials: child.initial,
                          background: AppColors.yellow,
                          foreground: AppColors.navy,
                          size: 76,
                          radius: AppRadii.r26,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          boxShadow: AppShadows.yellowButtonKid,
                        ),
                        const SizedBox(width: AppSpacing.x16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                child.name,
                                style: AppTextStyles.fredoka(
                                  size: 26,
                                  height: 1.1,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.x4),
                              Text(
                                '${child.grade} · École primaire Ibn '
                                'Khaldoun',
                                style: AppTextStyles.nunito(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: AppColors.onNavyMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x16),
                    Row(
                      children: [
                        Expanded(
                          child: _Stat(
                            label: l10n.classUpper,
                            value: child.grade.startsWith('4')
                                ? '4e B'
                                : '1re A',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x8),
                        const Expanded(
                          child: _Stat(label: 'SALLE', value: '4'),
                        ),
                        const SizedBox(width: AppSpacing.x8),
                        const Expanded(
                          child: _Stat(label: 'ÉLÈVES', value: '28'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --------------------------------------------------- teachers
          Container(
            padding: const EdgeInsets.all(AppSpacing.x16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 6),
                  child: Text(l10n.histeachers, style: AppTextStyles.sectionTitle),
                ),
                for (var i = 0; i < teachers.length; i++)
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: AppSpacing.x6,
                    ),
                    decoration: BoxDecoration(
                      border: i > 0
                          ? const Border(
                              top: BorderSide(
                                color: AppColors.divider,
                                width: 1.5,
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        SubjectTile(
                          subject: teachers[i].subject,
                          size: 40,
                          excludeSemantics: true,
                        ),
                        const SizedBox(width: AppSpacing.x12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                teachers[i].name,
                                style: AppTextStyles.nunito(
                                  size: 15,
                                  weight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                teachers[i].role,
                                style: AppTextStyles.nunito(
                                  size: 13,
                                  color: AppColors.inkSubtle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconSquareButton(
                          icon: AppIcons.message,
                          semanticLabel: l10n.writeTo(teachers[i].name),
                          background: AppColors.background,
                          iconSize: 20,
                          onPressed: () => context.push(Routes.chat),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // ------------------------------------------------------- school
          Container(
            padding: const EdgeInsets.all(AppSpacing.x16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.theSchool, style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.x12),
                _InfoLine(icon: AppIcons.clock, text: l10n.schoolHours),
                const SizedBox(height: AppSpacing.x12),
                _InfoLine(
                  icon: AppIcons.pin,
                  text: l10n.schoolAddressPlaceholder,
                ),
                const SizedBox(height: AppSpacing.x12),
                OutlineButton(
                  label: l10n.callSchool,
                  icon: AppIcons.phone,
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // -------------------------------------------------- information
          Container(
            padding: const EdgeInsets.all(AppSpacing.x16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.information, style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.x10),
                _InfoRow(
                  label: l10n.birthDate,
                  value: l10n.birthDatePlaceholder,
                ),
                const SizedBox(height: AppSpacing.x10),
                _InfoRow(
                  label: l10n.mainContact,
                  value: 'Samia (vous)',
                ),
                const SizedBox(height: AppSpacing.x10),
                _InfoRow(
                  label: l10n.otherContact,
                  value: l10n.otherContactPlaceholder,
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  l10n.infoWrongNotice,
                  style: AppTextStyles.nunito(
                    size: 13,
                    height: 1.4,
                    color: AppColors.inkSubtle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x12,
        vertical: AppSpacing.x10,
      ),
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        borderRadius: BorderRadius.circular(AppRadii.field),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.nunito(
              size: 11,
              weight: FontWeight.w800,
              color: AppColors.onNavySubtle,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.fredoka(size: 17, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 1),
          child: AppIcon(icon, size: 20, color: AppColors.info),
        ),
        const SizedBox(width: AppSpacing.x12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.nunito(
              size: 14,
              weight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.nunito(
            size: 14,
            weight: FontWeight.w700,
            color: AppColors.inkSubtle,
          ),
        ),
        const SizedBox(width: AppSpacing.x12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.nunito(size: 14, weight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
