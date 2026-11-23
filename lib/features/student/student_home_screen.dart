import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/screen.dart';
import '../../core/widgets/subject_tile.dart';
import '../../core/widgets/zitoun.dart';
import '../../l10n/app_localizations.dart';

/// Board 10 · Accueil élève.
///
/// Student screens use 64dp+ touch targets and larger type throughout
/// (`docs/SPEC.md` §4.3).
class StudentHomeScreen extends ConsumerWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(studentRepositoryProvider);
    final clock = ref.watch(clockProvider);
    final style = AppSubjects.of(repo.currentLesson.subject);
    final remaining = repo.currentLesson.end.minutes - clock.now.minutes;
    final progress = 1 - remaining / repo.currentLesson.durationMinutes;

    return AppScreen(
      padding: AppSpacing.screenKid,
      gap: AppSpacing.x16,
      children: [
        // --------------------------------------------------------- header
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.studentGreeting(repo.studentName),
                style: AppTextStyles.displayKid,
              ),
            ),
            IconSquareButton(
              icon: AppIcons.lock,
              semanticLabel: l10n.exitKidMode,
              foreground: AppColors.inkSubtle,
              onPressed: () => context.push(Routes.role),
            ),
          ],
        ),

        // ----------------------------------------------------- speech bubble
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Zitoun(
              size: 112,
              mood: ZitounMood.salut,
              excludeSemantics: true,
            ),
            const SizedBox(width: AppSpacing.x6),
            Expanded(
              child: Container(
                margin: const EdgeInsetsDirectional.only(bottom: 34),
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 12, 12),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppRadii.bubbleKid,
                  boxShadow: AppShadows.cardLifted,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.timeForSubject(style.name.toLowerCase()),
                        style: AppTextStyles.fredoka(size: 19, height: 1.25),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x10),
                    IconRoundButton(
                      icon: AppIcons.speaker,
                      semanticLabel: l10n.listen,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // --------------------------------------------------------- now card
        Semantics(
          label: l10n.now,
          container: true,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.x18),
            decoration: BoxDecoration(
              color: style.tint,
              borderRadius: BorderRadius.circular(AppRadii.r30),
              boxShadow: AppShadows.tinted(AppColors.artsBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SubjectTile(
                      subject: repo.currentLesson.subject,
                      size: 88,
                      excludeSemantics: true,
                    ),
                    const SizedBox(width: AppSpacing.x16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.nowUpper,
                            style: AppTextStyles.kickerKid(color: style.ink),
                          ),
                          Text(
                            style.name,
                            style: AppTextStyles.fredoka(
                              size: 34,
                              weight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                          Text(
                            l10n.withTeacher(repo.currentLesson.teacher),
                            style: AppTextStyles.nunito(
                              size: 15,
                              weight: FontWeight.w700,
                              color: AppColors.inkMuted,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 16,
                          child: Stack(
                            children: [
                              const Positioned.fill(
                                child: ColoredBox(color: AppColors.white),
                              ),
                              FractionallySizedBox(
                                widthFactor: progress.clamp(0.0, 1.0),
                                child: Container(color: style.ink),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(AppIcons.clock, size: 16, color: style.ink),
                        const SizedBox(width: AppSpacing.x4),
                        Text(
                          l10n.untilTime(repo.currentLesson.end.short),
                          style: AppTextStyles.nunito(
                            size: 14,
                            weight: FontWeight.w800,
                            color: style.ink,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // -------------------------------------------------------- day strip
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.r26),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                child: Text(l10n.myDay, style: AppTextStyles.h6),
              ),
              const SizedBox(height: AppSpacing.x12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [for (final s in repo.daySteps) _DayStep(step: s)],
              ),
            ],
          ),
        ),

        // ------------------------------------------------------- shortcuts
        // IntrinsicHeight lets both cards share the taller one's height,
        // which is what `align-items: stretch` does in the mockup grid —
        // a plain stretch here would hand the cards an infinite height from
        // the enclosing scroll view.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _BigCard(
                  icon: AppIcons.book,
                  background: AppColors.successTint,
                  iconForeground: AppColors.success,
                  title: l10n.myLessons,
                  badge: l10n.oneNewLesson,
                  onTap: () => context.go(Routes.studentLessons),
                ),
              ),
              const SizedBox(width: AppSpacing.x12),
              Expanded(
                child: _BigCard(
                  icon: AppIcons.calendar,
                  background: AppColors.warnTint,
                  iconForeground: AppColors.warn,
                  title: l10n.myWeek,
                  onTap: () => context.go(Routes.studentWeek),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayStep extends StatelessWidget {
  const _DayStep({required this.step});

  final ({Subject? subject, bool isLunch, String time, bool done, bool now})
  step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    Widget medallion;
    if (step.isLunch) {
      medallion = Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.warnTint,
          borderRadius: BorderRadius.circular(AppRadii.r14),
        ),
        child: const AppIcon(AppIcons.sun, size: 22, color: AppColors.warn),
      );
    } else {
      medallion = SubjectTile(
        subject: step.subject!,
        size: 44,
        excludeSemantics: true,
      );
    }

    return Opacity(
      opacity: step.done ? 0.55 : 1,
      child: Semantics(
        label: step.isLunch ? l10n.lunch : null,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: step.now ? AppShadows.ringStepKid : null,
                  ),
                  child: medallion,
                ),
                if (step.done)
                  const PositionedDirectional(
                    top: -6,
                    end: -6,
                    child: _DoneBadge(),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(step.time, style: AppTextStyles.metaSmall),
          ],
        ),
      ),
    );
  }
}

class _DoneBadge extends StatelessWidget {
  const _DoneBadge();

  @override
  Widget build(BuildContext context) => Container(
    width: 20,
    height: 20,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.success,
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.white, width: 2),
    ),
    child: const AppIcon(
      AppIcons.check,
      size: 12,
      strokeWidth: 3.5,
      color: AppColors.white,
    ),
  );
}

class _BigCard extends StatelessWidget {
  const _BigCard({
    required this.icon,
    required this.background,
    required this.iconForeground,
    required this.title,
    required this.onTap,
    this.badge,
  });

  final String icon;
  final Color background;
  final Color iconForeground;
  final String title;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: badge == null ? title : '$title, $badge',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 118),
            padding: const EdgeInsets.all(AppSpacing.x16),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadii.r26),
              boxShadow: AppShadows.tinted(
                Color.lerp(background, AppColors.navy, 0.18)!,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadii.field),
                      ),
                      child: AppIcon(icon, size: 28, color: iconForeground),
                    ),
                    Text(title, style: AppTextStyles.fredoka(size: 20)),
                  ],
                ),
                if (badge != null)
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    child: Container(
                      height: 26,
                      alignment: Alignment.center,
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: iconForeground,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        badge!,
                        style: AppTextStyles.nunito(
                          size: 13,
                          weight: FontWeight.w800,
                          color: AppColors.white,
                        ),
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
