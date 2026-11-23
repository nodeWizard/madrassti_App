import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/zitoun.dart';
import '../../l10n/app_localizations.dart';

/// Board 1 · Splash.
///
/// The whole surface is one link. The navy field carries two large circles and
/// three small confetti shapes behind Zitoun.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Semantics(
        button: true,
        label: l10n.openApp,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.go(Routes.welcome),
          child: Stack(
            children: [
              // Decorative shapes, positioned exactly as in the mockup.
              Positioned(
                top: -150,
                right: -170,
                child: _Circle(size: 420, color: AppColors.navyDeep),
              ),
              Positioned(
                bottom: -110,
                left: -130,
                child: _Circle(size: 300, color: AppColors.navyDeep),
              ),
              Positioned(
                top: 170,
                left: 64,
                child: Transform.rotate(
                  angle: 18 * 3.141592653589793 / 180,
                  child: _Square(
                    size: 18,
                    radius: 6,
                    color: AppColors.yellow,
                  ),
                ),
              ),
              Positioned(
                top: 240,
                right: 72,
                child: _Circle(size: 14, color: AppColors.oliveLeaf),
              ),
              Positioned(
                bottom: 230,
                right: 96,
                child: Transform.rotate(
                  angle: -14 * 3.141592653589793 / 180,
                  child: _Square(
                    size: 16,
                    radius: 5,
                    color: AppColors.coral,
                  ),
                ),
              ),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 196,
                      height: 196,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.infoTint,
                        shape: BoxShape.circle,
                      ),
                      child: const Zitoun(
                        size: 160,
                        mood: ZitounMood.salut,
                        excludeSemantics: true,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x18 + AppSpacing.x14),
                    Text('madrassti', style: AppTextStyles.logo),
                    const SizedBox(height: AppSpacing.x14),
                    Text(
                      l10n.appNameArabic,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.baloo(
                        size: 34,
                        height: 1.1,
                        color: AppColors.yellow,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x14 + AppSpacing.x6),
                    Text(
                      l10n.appTagline,
                      style: AppTextStyles.nunito(
                        size: 16,
                        weight: FontWeight.w700,
                        color: AppColors.onNavyMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Three progress dots, fading out.
              const Positioned(
                bottom: 72,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Dot(opacity: 1),
                    SizedBox(width: AppSpacing.x8),
                    _Dot(opacity: 0.55),
                    SizedBox(width: AppSpacing.x8),
                    _Dot(opacity: 0.25),
                  ],
                ),
              ),
            ],
          ),
        ),
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

class _Square extends StatelessWidget {
  const _Square({
    required this.size,
    required this.radius,
    required this.color,
  });

  final double size;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

class _Dot extends StatelessWidget {
  const _Dot({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(
      color: AppColors.yellow.withValues(alpha: opacity),
      shape: BoxShape.circle,
    ),
  );
}
