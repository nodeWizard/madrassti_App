import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// Shadows measured in the mockups. See `docs/SPEC.md` §2.4.
///
/// The mockups lean on *hard* shadows (`0 Npx 0 <colour>`): an offset with no
/// blur. They are a core part of the look, so they are never softened.
abstract final class AppShadows {
  /// `0 2px 0 #D6E4F7` — a white card resting on the background.
  static const card = <BoxShadow>[
    BoxShadow(color: AppColors.cardShadow, offset: Offset(0, 2), blurRadius: 0),
  ];

  /// `0 3px 0 #D6E4F7` — the student speech bubble.
  static const cardLifted = <BoxShadow>[
    BoxShadow(color: AppColors.cardShadow, offset: Offset(0, 3), blurRadius: 0),
  ];

  /// `0 3px 0 #E0A51A` — the primary yellow button.
  static const yellowButton = <BoxShadow>[
    BoxShadow(
      color: AppColors.yellowShadow,
      offset: Offset(0, 3),
      blurRadius: 0,
    ),
  ];

  /// `0 4px 0 #E0A51A` — the chunkier round student button.
  static const yellowButtonKid = <BoxShadow>[
    BoxShadow(
      color: AppColors.yellowShadow,
      offset: Offset(0, 4),
      blurRadius: 0,
    ),
  ];

  /// `0 3px 0 #0E1640` — the navy button.
  static const navyButton = <BoxShadow>[
    BoxShadow(color: AppColors.navyShadow, offset: Offset(0, 3), blurRadius: 0),
  ];

  /// `0 4px 0 #1B2559` — a selected card (role, student subject).
  static const selected = <BoxShadow>[
    BoxShadow(color: AppColors.navy, offset: Offset(0, 4), blurRadius: 0),
  ];

  /// `0 4px 0 #0E1640` — the selected student day tab.
  static const selectedKidDay = <BoxShadow>[
    BoxShadow(color: AppColors.navyShadow, offset: Offset(0, 4), blurRadius: 0),
  ];

  /// `0 4px 0 <tint>` — a large tinted student card.
  static List<BoxShadow> tinted(Color color) => <BoxShadow>[
    BoxShadow(color: color, offset: const Offset(0, 4), blurRadius: 0),
  ];

  /// `0 1px 3px rgba(27,37,89,.25)` — the switch thumb.
  static const switchThumb = <BoxShadow>[
    BoxShadow(color: AppColors.shadow25, offset: Offset(0, 1), blurRadius: 3),
  ];

  /// `0 -4px 16px rgba(27,37,89,.08)` — bottom nav / sticky bar.
  static const bottomBar = <BoxShadow>[
    BoxShadow(color: AppColors.shadow08, offset: Offset(0, -4), blurRadius: 16),
  ];

  /// `0 -4px 16px rgba(27,37,89,.06)` — chat send bar.
  static const sendBar = <BoxShadow>[
    BoxShadow(color: AppColors.shadow06, offset: Offset(0, -4), blurRadius: 16),
  ];

  /// `0 4px 16px rgba(27,37,89,.06)` — chat header.
  static const header = <BoxShadow>[
    BoxShadow(color: AppColors.shadow06, offset: Offset(0, 4), blurRadius: 16),
  ];

  /// `0 8px 20px rgba(27,37,89,.1)` — floating card, welcome slide 3.
  static const floating = <BoxShadow>[
    BoxShadow(color: AppColors.shadow10, offset: Offset(0, 8), blurRadius: 20),
  ];

  /// `0 10px 24px rgba(27,37,89,.1)` — tilted white card, welcome slide 2.
  static const tiltedLight = <BoxShadow>[
    BoxShadow(color: AppColors.shadow10, offset: Offset(0, 10), blurRadius: 24),
  ];

  /// `0 10px 24px rgba(27,37,89,.14)` — tilted alert card, welcome slide 2.
  static const tiltedAlert = <BoxShadow>[
    BoxShadow(color: AppColors.shadow14, offset: Offset(0, 10), blurRadius: 24),
  ];

  /// `0 12px 28px rgba(27,37,89,.22)` — tilted navy card, welcome slide 1.
  static const tiltedNavy = <BoxShadow>[
    BoxShadow(color: AppColors.shadow22, offset: Offset(0, 12), blurRadius: 28),
  ];

  // ------------------------------------------------------------------ rings
  // `box-shadow: 0 0 0 Npx <colour>` draws an outline *outside* the box, so it
  // maps to a zero-blur shadow with a spread rather than to a border (a border
  // would eat into the box and shift the content).

  /// `0 0 0 2.5px #FFC83D` — the "in progress" ring.
  static const ringNow = <BoxShadow>[
    BoxShadow(
      color: AppColors.yellow,
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 2.5,
    ),
  ];

  /// `0 0 0 3px #FFC83D` — the student ring (current lesson / course).
  static const ringNowKid = <BoxShadow>[
    BoxShadow(
      color: AppColors.yellow,
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 3,
    ),
  ];

  /// `0 0 0 3px #FFFFFF, 0 0 0 6px #FFC83D` — the current step on the student
  /// day strip: a white gap, then a yellow ring.
  static const ringStepKid = <BoxShadow>[
    BoxShadow(
      color: AppColors.yellow,
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 6,
    ),
    BoxShadow(
      color: AppColors.white,
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 3,
    ),
  ];

  /// `0 0 0 3px #FF7A6B` — the outline of the "Nouveau" student alert card.
  static const ringCoral = <BoxShadow>[
    BoxShadow(
      color: AppColors.coral,
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 3,
    ),
  ];

  static const none = <BoxShadow>[];
}
