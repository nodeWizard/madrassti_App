import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography of the mockups. See `docs/SPEC.md` §2.2.
///
/// Three families are bundled by the mockups:
///  * **Fredoka** (500/600/700) — headings, numerals, the `Aa` / `1+2` glyphs
///  * **Nunito** (400/600/700/800) — body copy, labels, buttons
///  * **Baloo Bhaijaan 2** (600/700) — Arabic text
abstract final class AppTextStyles {
  /// Headings and display text.
  static TextStyle fredoka({
    required double size,
    FontWeight weight = FontWeight.w600,
    double? height,
    Color color = AppColors.ink,
    double? letterSpacing,
    TextDecoration? decoration,
  }) => GoogleFonts.fredoka(
    fontSize: size,
    fontWeight: weight,
    height: height,
    color: color,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );

  /// Body copy, labels and buttons.
  static TextStyle nunito({
    required double size,
    FontWeight weight = FontWeight.w600,
    double? height,
    Color color = AppColors.ink,
    double? letterSpacing,
    TextDecoration? decoration,
  }) => GoogleFonts.nunito(
    fontSize: size,
    fontWeight: weight,
    height: height,
    color: color,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );

  /// Arabic text.
  static TextStyle baloo({
    required double size,
    FontWeight weight = FontWeight.w700,
    double? height,
    Color color = AppColors.ink,
  }) => GoogleFonts.balooBhaijaan2(
    fontSize: size,
    fontWeight: weight,
    height: height,
    color: color,
  );

  // ------------------------------------------------------------------ titles
  /// `56px` Fredoka 700, `letter-spacing: -0.02em` — the "madrassti" logotype.
  static TextStyle get logo => fredoka(
    size: 56,
    weight: FontWeight.w700,
    height: 1,
    color: AppColors.white,
    letterSpacing: 56 * -0.02,
  );

  /// `34px` Fredoka 700 — "Salut Lina !", "Arts".
  static TextStyle get displayKid =>
      fredoka(size: 34, weight: FontWeight.w700, height: 1.1);

  /// `32px` Fredoka 700 — student screen titles.
  static TextStyle get titleKid => fredoka(size: 32, weight: FontWeight.w700);

  /// `28px` Fredoka 600 — parent and onboarding screen titles.
  static TextStyle get h1 => fredoka(size: 28, height: 1.15);

  /// `28px` Fredoka 600, `line-height: 1.2` — onboarding headline.
  static TextStyle get h1Onboarding => fredoka(size: 28, height: 1.2);

  /// `26px` Fredoka 600 — section titles, screen titles.
  static TextStyle get h2 => fredoka(size: 26, height: 1.15);

  /// `24px` Fredoka 600 — teacher screen titles, sheet titles.
  static TextStyle get h3 => fredoka(size: 24);

  /// `22px` Fredoka 600.
  static TextStyle get h4 => fredoka(size: 22);

  /// `21px` Fredoka 600 — moderation sheet title, student course name.
  static TextStyle get h5 => fredoka(size: 21, height: 1.2);

  /// `20px` Fredoka 600 — card and section titles.
  static TextStyle get h6 => fredoka(size: 20);

  /// `19px` Fredoka 600 — card titles.
  static TextStyle get cardTitle => fredoka(size: 19, height: 1.2);

  /// `18px` Fredoka 600 — section titles.
  static TextStyle get sectionTitle => fredoka(size: 18);

  /// `17px` Fredoka 600 — timetable block name.
  static TextStyle get blockTitle => fredoka(size: 17, height: 1.2);

  // -------------------------------------------------------------------- body
  /// `16px` Nunito 600, `line-height: 1.5` — the smallest body size used.
  static TextStyle get body => nunito(size: 16, height: 1.5);

  /// `15px` Nunito 600 — body copy, setting labels.
  static TextStyle get body15 => nunito(size: 15);

  /// `15px` Nunito 400, `line-height: 1.45` — chat bubble text.
  static TextStyle get bubble =>
      nunito(size: 15, weight: FontWeight.w400, height: 1.45);

  /// `14px` Nunito 400, `line-height: 1.4` — notification body.
  static TextStyle get notifBody => nunito(
    size: 14,
    weight: FontWeight.w400,
    height: 1.4,
    color: AppColors.inkMuted,
  );

  /// `14px` Nunito 800 — list row title.
  static TextStyle get rowTitle => nunito(size: 14, weight: FontWeight.w800);

  /// `13px` Nunito 600, `line-height: 1.4` — helper text.
  static TextStyle get helper =>
      nunito(size: 13, height: 1.4, color: AppColors.inkSubtle);

  /// `13px` Nunito 700 — meta line.
  static TextStyle get meta =>
      nunito(size: 13, weight: FontWeight.w700, color: AppColors.inkSubtle);

  /// `12px` Nunito 700 — timestamp.
  static TextStyle get metaSmall =>
      nunito(size: 12, weight: FontWeight.w700, color: AppColors.inkSubtle);

  // ----------------------------------------------------------------- buttons
  /// `17px` Nunito 800 — primary button.
  static TextStyle get button => nunito(size: 17, weight: FontWeight.w800);

  /// `15px` Nunito 800 — compact button.
  static TextStyle get buttonCompact =>
      nunito(size: 15, weight: FontWeight.w800);

  /// `14px` Nunito 800 — chip, small button.
  static TextStyle get buttonSmall => nunito(size: 14, weight: FontWeight.w800);

  // ---------------------------------------------------------------- kickers
  /// `11px` Nunito 800, `letter-spacing: 0.08em`, upper-case.
  static TextStyle kicker({Color color = AppColors.inkSubtle}) =>
      nunito(
        size: 11,
        weight: FontWeight.w800,
        color: color,
        letterSpacing: 11 * 0.08,
      );

  /// `12px` Nunito 800, `letter-spacing: 0.08em`.
  static TextStyle kicker12({Color color = AppColors.inkSubtle}) =>
      nunito(
        size: 12,
        weight: FontWeight.w800,
        color: color,
        letterSpacing: 12 * 0.08,
      );

  /// `12px` Nunito 800, `letter-spacing: 0.1em`, upper-case — section header.
  static TextStyle sectionHeader({Color color = AppColors.inkSubtle}) =>
      nunito(
        size: 12,
        weight: FontWeight.w800,
        color: color,
        letterSpacing: 12 * 0.1,
      );

  /// `13px` Nunito 800, `letter-spacing: 0.08em` — student "MAINTENANT".
  static TextStyle kickerKid({Color color = AppColors.arts}) => nunito(
    size: 13,
    weight: FontWeight.w800,
    color: color,
    letterSpacing: 13 * 0.08,
  );

  // ------------------------------------------------------------------ badges
  /// `11px` Nunito 800 — status chip, unread badge.
  static TextStyle get chip => nunito(size: 11, weight: FontWeight.w800);

  /// `12px` Nunito 800 — chip, badge.
  static TextStyle get chip12 => nunito(size: 12, weight: FontWeight.w800);

  /// `10px` Nunito 800 — nav badge.
  static TextStyle get badgeTiny => nunito(size: 10, weight: FontWeight.w800);

  /// `9px` Nunito 800 — document type badge, avatar initial in a chip.
  static TextStyle get badgeMicro => nunito(size: 9, weight: FontWeight.w800);
}
