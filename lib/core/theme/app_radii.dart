import 'package:flutter/painting.dart';

/// Corner radii measured in the mockups. See `docs/SPEC.md` §2.3.
abstract final class AppRadii {
  static const double xs = 4;
  static const double sm = 8;

  /// Timeline segments.
  static const double seg = 9;

  /// Document thumbnail.
  static const double thumb = 10;

  /// Small chip.
  static const double chip = 11;

  static const double r12 = 12;

  /// 40px medallion.
  static const double medallion = 13;

  /// Compact navy button, 44px icon button.
  static const double r14 = 14;

  static const double r15 = 15;

  /// Fields and 48px icon buttons.
  static const double field = 16;

  static const double r17 = 17;

  /// Primary 56px button, 52px bell.
  static const double button = 18;

  /// Card, nav pill, chip row.
  static const double r20 = 20;

  /// Alert card, list container.
  static const double r22 = 22;

  /// Card, role button, sheet corner.
  static const double r24 = 24;

  static const double r26 = 26;

  /// Large card (day ribbon, hero).
  static const double r28 = 28;

  /// Moderation sheet.
  static const double r30 = 30;

  // -------------------------------------------------------------- composed
  /// Bottom nav and the sticky send bar.
  static const navTop = BorderRadius.only(
    topLeft: Radius.circular(r24),
    topRight: Radius.circular(r24),
  );

  /// Chat header.
  static const headerBottom = BorderRadius.only(
    bottomLeft: Radius.circular(r24),
    bottomRight: Radius.circular(r24),
  );

  /// Teacher success sheet.
  static const sheetTop = BorderRadius.only(
    topLeft: Radius.circular(r28),
    topRight: Radius.circular(r28),
  );

  /// Moderation sheet.
  static const modSheetTop = BorderRadius.only(
    topLeft: Radius.circular(r30),
    topRight: Radius.circular(r30),
  );

  /// Received chat bubble: 20 20 20 6.
  static const bubbleIn = BorderRadius.only(
    topLeft: Radius.circular(r20),
    topRight: Radius.circular(r20),
    bottomRight: Radius.circular(r20),
    bottomLeft: Radius.circular(6),
  );

  /// Sent chat bubble: 20 20 6 20.
  static const bubbleOut = BorderRadius.only(
    topLeft: Radius.circular(r20),
    topRight: Radius.circular(r20),
    bottomRight: Radius.circular(6),
    bottomLeft: Radius.circular(r20),
  );

  /// Student speech bubble: 22 22 22 6.
  static const bubbleKid = BorderRadius.only(
    topLeft: Radius.circular(r22),
    topRight: Radius.circular(r22),
    bottomRight: Radius.circular(r22),
    bottomLeft: Radius.circular(6),
  );
}
