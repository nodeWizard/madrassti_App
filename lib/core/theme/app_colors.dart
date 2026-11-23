import 'package:flutter/painting.dart';

/// Every colour used by the Madrassti mockups.
///
/// Values are transcribed verbatim from the inline `style="…"` attributes of
/// `mockups/*.html`. See `docs/SPEC.md` §2.1. Never hard-code a hex anywhere
/// else in the app.
abstract final class AppColors {
  // ---------------------------------------------------------------- brand
  /// Primary ink and dark surfaces. The most used colour in the mockups.
  static const navy = Color(0xFF1B2559);

  /// Cards sitting on top of [navy] surfaces.
  static const navyCard = Color(0xFF26336E);

  /// Decorative circles on [navy] backgrounds (splash, child profile hero).
  static const navyDeep = Color(0xFF222F6B);

  /// Hard 3px shadow under a navy button.
  static const navyShadow = Color(0xFF0E1640);

  /// Progress-bar track on a navy surface.
  static const navyTrack = Color(0xFF3A4785);

  /// Dashed "Pause" outline inside the navy day ribbon.
  static const navyDash = Color(0xFF56628F);

  static const white = Color(0xFFFFFFFF);

  /// App background.
  static const background = Color(0xFFEEF5FF);

  /// Primary accent: buttons, active nav pill, "now" marker.
  static const yellow = Color(0xFFFFC83D);

  /// Hard shadow under a yellow button.
  static const yellowShadow = Color(0xFFE0A51A);

  /// Mascot satchel flap.
  static const yellowDark = Color(0xFFF0B323);

  // ----------------------------------------------------------------- text
  static const ink = navy;

  /// Secondary body copy.
  static const inkMuted = Color(0xFF3A4570);

  /// Meta text and labels.
  static const inkSubtle = Color(0xFF5A6488);

  static const onNavy = white;

  /// Subtitle on a navy surface.
  static const onNavyMuted = Color(0xFFC9D1EE);

  /// Meta text on a navy surface.
  static const onNavySubtle = Color(0xFFA9B3D6);

  // ------------------------------------------------- borders & separators
  /// Hard 2px shadow under a white card — the signature of this design.
  static const cardShadow = Color(0xFFD6E4F7);

  /// Same value, used as a 1.5px card border.
  static const cardBorder = Color(0xFFD6E4F7);

  /// 1.5px separator between list rows.
  static const divider = Color(0xFFEEF2FA);

  /// 1.5px border of a text field.
  static const fieldBorder = Color(0xFFC9D6EC);

  /// 2px dashed border (upload button, "add a child").
  static const dashedBorder = Color(0xFFA9C3E6);

  /// Chat input fill.
  static const fieldFill = Color(0xFFF7FAFF);

  /// Neutral chip fill.
  static const chipFill = Color(0xFFF3F6FC);

  /// Document thumbnail border.
  static const thumbBorder = Color(0xFFE3EAF6);

  // ------------------------------------------------------------ semantic
  static const success = Color(0xFF1E7A57);
  static const successTint = Color(0xFFD9F5E8);

  /// Moderation suggestion fill.
  static const successTintAlt = Color(0xFFEDFAF3);

  /// Moderation suggestion border, and the 4px shadow of the green kid card.
  static const successBorder = Color(0xFFA9E5CB);

  static const info = Color(0xFF1F5FBF);
  static const infoTint = Color(0xFFDCEBFF);

  /// Announcement medallion, inactive carousel dots.
  static const infoTintAlt = Color(0xFFA9D1FF);

  /// Preview border for an announcement.
  static const infoBorder = Color(0xFFC9DDF7);

  static const danger = Color(0xFFB83C30);

  /// Unread badge.
  static const dangerStrong = Color(0xFFC8473A);

  /// "Change" dot on a day tab.
  static const dangerDot = Color(0xFFE8604F);

  static const coral = Color(0xFFFF7A6B);
  static const coralTint = Color(0xFFFFE9E5);
  static const coralBorder = Color(0xFFFFC2B8);

  /// Border of the sign-out button.
  static const coralBorderSoft = Color(0xFFE6B3AC);

  static const warn = Color(0xFF8A5A00);
  static const warnTint = Color(0xFFFFF0C7);

  /// "Schedule changed" preview fill.
  static const warnTintAlt = Color(0xFFFFF8E4);

  /// Gold border, and the 4px shadow of the gold kid card.
  static const warnBorder = Color(0xFFF3D88A);

  /// "In progress" row in the teacher's agenda.
  static const warnRow = Color(0xFFFFF6DA);

  // ------------------------------------------------------- subject accents
  /// Arts ink — only used by the subject palette and the student "now" card.
  static const arts = Color(0xFFA8326A);
  static const artsTint = Color(0xFFFFE3EE);

  /// 4px shadow of the pink student card.
  static const artsBorder = Color(0xFFF5C2D6);

  static const arabicTint = Color(0xFFFFE1DC);
  static const sportTint = Color(0xFFE3E7F5);

  // -------------------------------------------------------- document bands
  static const bandFrench = yellow;
  static const bandMaths = Color(0xFF5B9BEA);
  static const bandArabic = coral;
  static const bandScience = Color(0xFF7FD8B4);

  // ---------------------------------------------------------------- mascot
  static const oliveBody = Color(0xFF3FA97C);
  static const oliveHighlight = Color(0xFF8FDDB8);
  static const oliveLeaf = Color(0xFF7FD8B4);
  static const oliveLeafStroke = Color(0xFF2E5E46);

  // ---------------------------------------------------------------- scrims
  /// Success-sheet scrim.
  static const scrimStrong = Color(0x8C1B2559); // rgba(27,37,89,.55)

  /// Moderation-sheet scrim.
  static const scrim = Color(0x731B2559); // rgba(27,37,89,.45)

  // ------------------------------------------------------- soft shadow inks
  static const shadow06 = Color(0x0F1B2559); // rgba(27,37,89,.06)
  static const shadow08 = Color(0x141B2559); // rgba(27,37,89,.08)
  static const shadow10 = Color(0x1A1B2559); // rgba(27,37,89,.10)
  static const shadow14 = Color(0x241B2559); // rgba(27,37,89,.14)
  static const shadow22 = Color(0x381B2559); // rgba(27,37,89,.22)
  static const shadow25 = Color(0x401B2559); // rgba(27,37,89,.25)
}
