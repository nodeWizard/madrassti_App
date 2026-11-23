import 'package:flutter/widgets.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';

/// The rounded-square icon holder used all over the mockups.
///
/// The recurring sizes are `40/r13` (list rows, shortcuts), `44/r14` and
/// `44/r15` (alert cards, chat avatar), `52/r18` and `56/r18`
/// (bell, "now" card, moderation sheet), `60/r20` and `64/r22`.
class Medallion extends StatelessWidget {
  const Medallion({
    super.key,
    required this.icon,
    required this.background,
    required this.foreground,
    this.size = 40,
    this.radius = AppRadii.medallion,
    this.iconSize,
    this.strokeWidth = 2,
  });

  final String icon;
  final Color background;
  final Color foreground;
  final double size;
  final double radius;
  final double? iconSize;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: AppIcon(
        icon,
        size: iconSize ?? (size * 0.5).roundToDouble(),
        strokeWidth: strokeWidth,
        color: foreground,
      ),
    );
  }
}

/// An initial-letter avatar, always typeset in Fredoka.
class InitialAvatar extends StatelessWidget {
  const InitialAvatar({
    super.key,
    required this.initials,
    required this.background,
    required this.foreground,
    this.size = 40,
    this.radius,
    this.fontSize,
    this.fontWeight = FontWeight.w600,
    this.boxShadow,
  });

  final String initials;
  final Color background;
  final Color foreground;
  final double size;

  /// `null` means a full circle, which is what most avatars use.
  final double? radius;
  final double? fontSize;
  final FontWeight fontWeight;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: radius == null ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: radius == null ? null : BorderRadius.circular(radius!),
        boxShadow: boxShadow,
      ),
      child: Text(
        initials,
        // A fixed-size emblem: it must not outgrow its circle.
        textScaler: TextScaler.noScaling,
        style: AppTextStyles.fredoka(
          size: fontSize ?? (size * 0.46).roundToDouble(),
          weight: fontWeight,
          height: 1,
          color: foreground,
        ),
      ),
    );
  }
}

/// A white card with the signature hard 2px shadow.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = AppRadii.r24,
    this.color = AppColors.white,
    this.boxShadow,
    this.border,
    this.width,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color color;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: boxShadow,
        border: border,
      ),
      child: child,
    );
  }
}
