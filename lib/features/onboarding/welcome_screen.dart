import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/medallion.dart';
import '../../core/widgets/subject_tile.dart';
import '../../core/widgets/zitoun.dart';
import '../../l10n/app_localizations.dart';

/// Board 2 · Bienvenue — a three-slide carousel with a FR / العربية switch.
///
/// The language switch is visual only in the mockup: neither button carries a
/// handler. It is kept interactive here but changes nothing yet, since nothing
/// is translated (see `docs/SPEC.md` §5.1 A4).
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _index = 0;
  bool _french = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final slides = [
      (title: l10n.slide1Title, body: l10n.slide1Body),
      (title: l10n.slide2Title, body: l10n.slide2Body),
      (title: l10n.slide3Title, body: l10n.slide3Body),
    ];
    final isLast = _index == slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenOnboarding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---- language switch + skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    label: l10n.languageGroup,
                    container: true,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.x4),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadii.r22),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _LangButton(
                            label: l10n.languageFrench,
                            selected: _french,
                            onTap: () => setState(() => _french = true),
                            style: AppTextStyles.nunito(
                              size: 14,
                              weight: FontWeight.w800,
                              color: _french
                                  ? AppColors.white
                                  : AppColors.navy,
                            ),
                          ),
                          _LangButton(
                            label: l10n.languageArabic,
                            selected: !_french,
                            onTap: () => setState(() => _french = false),
                            style: AppTextStyles.baloo(
                              size: 16,
                              color: !_french
                                  ? AppColors.white
                                  : AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppTextLink(
                    label: l10n.skip,
                    fontSize: 15,
                    onPressed: () => context.go(Routes.login),
                  ),
                ],
              ),

              // ---- illustration
              Expanded(
                child: Center(
                  child: Container(
                    width: 330,
                    height: 330,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.infoTint,
                      shape: BoxShape.circle,
                    ),
                    child: switch (_index) {
                      0 => const _SlideDay(),
                      1 => const _SlideChanges(),
                      _ => const _SlideChat(),
                    },
                  ),
                ),
              ),

              // ---- dots, title, body
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < slides.length; i++) ...[
                        if (i > 0) const SizedBox(width: AppSpacing.x8),
                        Container(
                          width: i == _index ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _index
                                ? AppColors.navy
                                : AppColors.infoTintAlt,
                            borderRadius: BorderRadius.circular(AppRadii.xs),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x16),
                  Text(
                    slides[_index].title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h1Onboarding,
                  ),
                  const SizedBox(height: AppSpacing.x10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Text(
                      slides[_index].body,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.nunito(
                        size: 16,
                        weight: FontWeight.w400,
                        height: 1.5,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),
              PrimaryButton(
                label: isLast ? l10n.start : l10n.next,
                onPressed: () => isLast
                    ? context.go(Routes.login)
                    : setState(() => _index++),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  const _LangButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.style,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final TextStyle style;

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
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : const Color(0x00000000),
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          child: Text(label, style: style),
        ),
      ),
    );
  }
}

/// Slide 1 — a tilted navy card showing a miniature day ribbon.
class _SlideDay extends StatelessWidget {
  const _SlideDay();

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Transform.rotate(
      angle: -3 * 3.141592653589793 / 180,
      child: Container(
        width: 290,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(AppRadii.r26),
          boxShadow: AppShadows.tiltedNavy,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.slide1CardTitle,
              style: AppTextStyles.fredoka(size: 17, color: AppColors.white),
            ),
            const SizedBox(height: 54),
            // Mini timeline: six segments, the second ringed as "now".
            SizedBox(
              height: 26,
              child: LayoutBuilder(
                builder: (context, c) {
                  Widget seg(double left, double width, Color color,
                      {double opacity = 1, bool ring = false, bool dashed = false}) {
                    return PositionedDirectional(
                      start: c.maxWidth * left,
                      width: c.maxWidth * width,
                      height: 26,
                      child: Container(
                        decoration: BoxDecoration(
                          color: dashed
                              ? null
                              : color.withValues(alpha: opacity),
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                          border: dashed
                              ? Border.all(
                                  color: AppColors.navyDash,
                                  width: 1.5,
                                )
                              : null,
                          boxShadow: ring ? AppShadows.ringNow : null,
                        ),
                      ),
                    );
                  }

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      seg(0, 0.18, AppColors.arabicTint, opacity: 0.4),
                      seg(0.195, 0.18, AppColors.infoTint, ring: true),
                      seg(0.39, 0.09, AppColors.warnTint),
                      seg(0.50, 0.24, AppColors.navy, dashed: true),
                      seg(0.755, 0.115, AppColors.successTint),
                      seg(0.885, 0.115, AppColors.sportTint),
                      PositionedDirectional(
                        start: c.maxWidth * 0.27 - 22,
                        bottom: 30,
                        child: const Zitoun(size: 44, excludeSemantics: true),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.x14),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x12,
                vertical: AppSpacing.x10,
              ),
              decoration: BoxDecoration(
                color: AppColors.navyCard,
                borderRadius: BorderRadius.circular(AppRadii.field),
              ),
              child: Row(
                children: [
                  const SubjectTile(
                    subject: Subject.ma,
                    size: 40,
                    excludeSemantics: true,
                  ),
                  const SizedBox(width: AppSpacing.x10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.nowUpper,
                        style: AppTextStyles.nunito(
                          size: 10,
                          weight: FontWeight.w800,
                          color: AppColors.yellow,
                          letterSpacing: 10 * 0.08,
                        ),
                      ),
                      Text(
                        AppSubjects.of(Subject.ma).name,
                        style: AppTextStyles.fredoka(
                          size: 15,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Slide 2 — two tilted cards: an alert and a new lesson.
class _SlideChanges extends StatelessWidget {
  const _SlideChanges();

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return SizedBox(
      width: 290,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.rotate(
            angle: 2 * 3.141592653589793 / 180,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.x14),
              decoration: BoxDecoration(
                color: AppColors.coralTint,
                borderRadius: BorderRadius.circular(AppRadii.r22),
                border: Border.all(color: AppColors.coralBorder, width: 1.5),
                boxShadow: AppShadows.tiltedAlert,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Medallion(
                    icon: AppIcons.swap,
                    background: AppColors.coral,
                    foreground: AppColors.navy,
                    iconSize: 20,
                  ),
                  const SizedBox(width: AppSpacing.x12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.tomorrowUpper,
                          style: AppTextStyles.nunito(
                            size: 11,
                            weight: FontWeight.w800,
                            color: AppColors.danger,
                            letterSpacing: 11 * 0.08,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          'Mme Trabelsi sera absente',
                          style: AppTextStyles.fredoka(size: 16),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          'Arts à la place de l’éveil (14h)',
                          style: AppTextStyles.nunito(
                            size: 13,
                            weight: FontWeight.w400,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          Transform.rotate(
            angle: -2 * 3.141592653589793 / 180,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.x14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadii.r22),
                boxShadow: AppShadows.tiltedLight,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Medallion(
                    icon: AppIcons.book,
                    background: AppColors.successTint,
                    foreground: AppColors.success,
                    iconSize: 20,
                  ),
                  const SizedBox(width: AppSpacing.x12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nouvelle leçon · Français',
                          style: AppTextStyles.fredoka(size: 16),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          'Les adjectifs qualificatifs',
                          style: AppTextStyles.nunito(
                            size: 13,
                            weight: FontWeight.w400,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
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

/// Slide 3 — two chat bubbles and the moderation badge.
class _SlideChat extends StatelessWidget {
  const _SlideChat();

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return SizedBox(
      width: 290,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 230),
            child: Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x14,
                vertical: AppSpacing.x12,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: AppRadii.bubbleIn,
                boxShadow: AppShadows.floating,
              ),
              child: Text(
                'Bonjour ! Yassine a très bien participé aujourd’hui.',
                style: AppTextStyles.nunito(
                  size: 14,
                  weight: FontWeight.w400,
                  height: 1.45,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x10),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 230),
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x14,
                  vertical: AppSpacing.x12,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: AppRadii.bubbleOut,
                ),
                child: Text(
                  'Merci beaucoup Madame, il en sera ravi !',
                  style: AppTextStyles.nunito(
                    size: 14,
                    weight: FontWeight.w400,
                    height: 1.45,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x10),
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 12, 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.field),
              boxShadow: AppShadows.floating,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Zitoun(
                  size: 40,
                  mood: ZitounMood.bravo,
                  excludeSemantics: true,
                ),
                const SizedBox(width: AppSpacing.x8),
                Flexible(
                  child: Text(
                    l10n.moderationBadge,
                    style: AppTextStyles.nunito(
                      size: 13,
                      weight: FontWeight.w800,
                      color: AppColors.success,
                    ),
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
