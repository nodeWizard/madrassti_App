import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// The six school subjects of the mockups.
enum Subject { ar, fr, ma, ev, art, sp }

/// How a subject is drawn: either a text glyph or a stroke icon.
enum SubjectGlyphKind { text, icon }

/// Everything the mockups attach to a subject.
///
/// Transcribed from the `Subject` component of `mockups/composants.html`.
/// See `docs/SPEC.md` §2.1.
class SubjectStyle {
  const SubjectStyle({
    required this.name,
    required this.shortName,
    required this.tint,
    required this.wash,
    required this.ink,
    required this.kind,
    this.glyph,
    this.isArabicGlyph = false,
    this.icon,
    required this.glyphRatio,
  });

  /// Full name, as used on parent and teacher screens.
  final String name;

  /// Short name, as used on student screens ("Maths", "Éveil").
  final String shortName;

  /// Saturated tile fill.
  final Color tint;

  /// Lighter wash used behind timetable blocks on the parent week screen.
  /// A deliberately separate token — see `docs/SPEC.md` §2.1.
  final Color wash;

  final Color ink;
  final SubjectGlyphKind kind;

  /// Set when [kind] is [SubjectGlyphKind.text].
  final String? glyph;

  /// Whether [glyph] must be typeset in Baloo Bhaijaan 2.
  final bool isArabicGlyph;

  /// Set when [kind] is [SubjectGlyphKind.icon]; a name from `AppIcons`.
  final String? icon;

  /// `fontSize = round(size * glyphRatio)` for a text glyph;
  /// icons always use `round(size * 0.5)`.
  final double glyphRatio;

  bool get isText => kind == SubjectGlyphKind.text;
  bool get isIcon => kind == SubjectGlyphKind.icon;
}

/// Lookup table for [Subject].
abstract final class AppSubjects {
  static const Map<Subject, SubjectStyle> all = {
    Subject.ar: SubjectStyle(
      name: 'Arabe',
      shortName: 'Arabe',
      tint: AppColors.arabicTint, // #FFE1DC
      wash: Color(0xFFFFF4F2),
      ink: AppColors.danger, // #B83C30
      kind: SubjectGlyphKind.text,
      glyph: 'ع',
      isArabicGlyph: true,
      glyphRatio: 0.56,
    ),
    Subject.fr: SubjectStyle(
      name: 'Français',
      shortName: 'Français',
      tint: AppColors.warnTint, // #FFF0C7
      wash: Color(0xFFFFF9E6),
      ink: AppColors.warn, // #8A5A00
      kind: SubjectGlyphKind.text,
      glyph: 'Aa',
      glyphRatio: 0.42,
    ),
    Subject.ma: SubjectStyle(
      name: 'Mathématiques',
      shortName: 'Maths',
      tint: AppColors.infoTint, // #DCEBFF
      wash: AppColors.background, // #EEF5FF
      ink: AppColors.info, // #1F5FBF
      kind: SubjectGlyphKind.text,
      glyph: '1+2',
      glyphRatio: 0.34,
    ),
    Subject.ev: SubjectStyle(
      name: 'Éveil scientifique',
      shortName: 'Éveil',
      tint: AppColors.successTint, // #D9F5E8
      wash: AppColors.successTintAlt, // #EDFAF3
      ink: AppColors.success, // #1E7A57
      kind: SubjectGlyphKind.icon,
      icon: 'flask',
      glyphRatio: 0.5,
    ),
    Subject.art: SubjectStyle(
      name: 'Arts',
      shortName: 'Arts',
      tint: AppColors.artsTint, // #FFE3EE
      wash: Color(0xFFFFF1F6),
      ink: AppColors.arts, // #A8326A
      kind: SubjectGlyphKind.icon,
      icon: 'palette',
      glyphRatio: 0.5,
    ),
    Subject.sp: SubjectStyle(
      name: 'Sport',
      shortName: 'Sport',
      tint: AppColors.sportTint, // #E3E7F5
      wash: Color(0xFFF1F3FA),
      ink: AppColors.navy, // #1B2559
      kind: SubjectGlyphKind.icon,
      icon: 'ball',
      glyphRatio: 0.5,
    ),
  };

  static SubjectStyle of(Subject s) => all[s]!;

  /// Colour of the band at the top of a document thumbnail (parent lessons).
  static const Map<Subject, Color> documentBand = {
    Subject.fr: AppColors.bandFrench, // #FFC83D
    Subject.ma: AppColors.bandMaths, // #5B9BEA
    Subject.ar: AppColors.bandArabic, // #FF7A6B
    Subject.ev: AppColors.bandScience, // #7FD8B4
  };
}
