import 'package:flutter/widgets.dart';

/// Flex gaps and screen paddings measured in the mockups.
/// See `docs/SPEC.md` §2.5.
abstract final class AppSpacing {
  static const double x2 = 2;
  static const double x3 = 3;
  static const double x4 = 4;
  static const double x5 = 5;
  static const double x6 = 6;
  static const double x8 = 8;
  static const double x10 = 10;
  static const double x12 = 12;
  static const double x14 = 14;
  static const double x16 = 16;
  static const double x18 = 18;
  static const double x20 = 20;
  static const double x24 = 24;
  static const double x28 = 28;

  /// Scrollable body of a parent / teacher screen: `20px 16px 24px`.
  static const screen = EdgeInsetsDirectional.fromSTEB(x16, x20, x16, x24);

  /// Scrollable body of a student screen: `18px 16px 20px`.
  static const screenKid = EdgeInsetsDirectional.fromSTEB(x16, x18, x16, x20);

  /// Onboarding screens: `20px 20px 28px`.
  static const screenOnboarding =
      EdgeInsetsDirectional.fromSTEB(x20, x20, x20, x28);

  /// Bottom navigation bar: `8px 6px 18px`.
  static const nav = EdgeInsetsDirectional.fromSTEB(x6, x8, x6, x18);

  /// Sticky action bar: `14px 16px 22px`.
  static const stickyBar = EdgeInsetsDirectional.fromSTEB(x16, x14, x16, 22);

  /// Chat send bar: `12px 12px 20px`.
  static const sendBar = EdgeInsetsDirectional.fromSTEB(x12, x12, x12, x20);

  /// The reference frame of every mockup board.
  static const Size frame = Size(390, 844);
}
