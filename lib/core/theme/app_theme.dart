import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_text_styles.dart';

export 'app_colors.dart';
export 'app_radii.dart';
export 'app_shadows.dart';
export 'app_spacing.dart';
export 'app_subjects.dart';
export 'app_text_styles.dart';

/// The app theme.
///
/// Material 3 is the base, but every visible default is overridden so nothing
/// reads as stock Material: no ripples, no elevation tints, no Material
/// typography, no default app bar. The mockups are flat surfaces with hard
/// shadows, and that is what this theme produces.
abstract final class AppTheme {
  static ThemeData build() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.yellow,
      onPrimary: AppColors.navy,
      secondary: AppColors.navy,
      onSecondary: AppColors.white,
      error: AppColors.danger,
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.ink,
      surfaceContainerHighest: AppColors.background,
      outline: AppColors.fieldBorder,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      // The mockups show no ripple or highlight anywhere.
      splashFactory: NoSplash.splashFactory,
      splashColor: const Color(0x00000000),
      highlightColor: const Color(0x00000000),
      hoverColor: const Color(0x00000000),
      focusColor: const Color(0x00000000),
    );

    return base.copyWith(
      textTheme: _textTheme(),
      primaryTextTheme: _textTheme(),
      iconTheme: const IconThemeData(color: AppColors.ink, size: 24),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1.5,
        space: 1.5,
      ),
      // Flat bottom sheets with the mockups' own radius.
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Color(0x00000000),
        elevation: 0,
        modalElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.modSheetTop),
        clipBehavior: Clip.antiAlias,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.navy
              : AppColors.white,
        ),
        checkColor: const WidgetStatePropertyAll(AppColors.white),
        side: const BorderSide(color: AppColors.fieldBorder, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        splashRadius: 0,
      ),
      // Nothing in the mockups uses a Material app bar, but a sane default
      // keeps any accidental use from looking foreign.
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        surfaceTintColor: Color(0x00000000),
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
    );
  }

  /// Nunito for body text, Fredoka for display text — never Roboto.
  static TextTheme _textTheme() => TextTheme(
    displayLarge: AppTextStyles.fredoka(size: 56, weight: FontWeight.w700),
    displayMedium: AppTextStyles.fredoka(size: 34, weight: FontWeight.w700),
    displaySmall: AppTextStyles.fredoka(size: 32, weight: FontWeight.w700),
    headlineLarge: AppTextStyles.h1,
    headlineMedium: AppTextStyles.h2,
    headlineSmall: AppTextStyles.h3,
    titleLarge: AppTextStyles.h4,
    titleMedium: AppTextStyles.h6,
    titleSmall: AppTextStyles.sectionTitle,
    bodyLarge: AppTextStyles.body,
    bodyMedium: AppTextStyles.body15,
    bodySmall: AppTextStyles.helper,
    labelLarge: AppTextStyles.button,
    labelMedium: AppTextStyles.buttonSmall,
    labelSmall: AppTextStyles.chip,
  );
}
