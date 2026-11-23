import 'package:flutter/widgets.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';

/// Shared tap behaviour: an opaque hit target with no Material ink, since the
/// mockups show no ripple anywhere.
class _Tappable extends StatelessWidget {
  const _Tappable({
    required this.onTap,
    required this.child,
    this.semanticLabel,
  });

  final VoidCallback? onTap;
  final Widget child;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final core = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
    if (semanticLabel == null) {
      return Semantics(button: true, enabled: onTap != null, child: core);
    }
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      child: ExcludeSemantics(child: core),
    );
  }
}

/// The primary yellow button: navy text on `#FFC83D` with a hard `3px`
/// darker-yellow bottom shadow. See `docs/SPEC.md` §3.5.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 56,
    this.radius = AppRadii.button,
    this.expand = true,
    this.padding,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Optional leading glyph name.
  final String? icon;
  final double height;
  final double radius;

  /// Whether the button fills its parent's width.
  final bool expand;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final style = textStyle ??
        (height >= 56 ? AppTextStyles.button : AppTextStyles.buttonCompact);

    Widget content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          AppIcon(icon!, size: 18, color: AppColors.navy),
          const SizedBox(width: AppSpacing.x8),
        ],
        Flexible(
          child: Text(
            label,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return _Tappable(
      onTap: onPressed,
      child: Container(
        height: height,
        width: expand ? double.infinity : null,
        padding: padding ??
            (expand
                ? null
                : const EdgeInsetsDirectional.symmetric(horizontal: 16)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(radius),
          boxShadow:
              height >= 56 ? AppShadows.yellowButton : AppShadows.yellowButton,
        ),
        child: content,
      ),
    );
  }
}

/// The navy button: white text with a hard `3px` `#0E1640` shadow.
class NavyButton extends StatelessWidget {
  const NavyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 56,
    this.radius = AppRadii.button,
    this.expand = true,
    this.withShadow = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? icon;
  final double height;
  final double radius;
  final bool expand;

  /// Compact navy buttons inside cards carry no shadow in the mockups.
  final bool withShadow;

  @override
  Widget build(BuildContext context) {
    final style = height >= 56
        ? AppTextStyles.nunito(
            size: 16,
            weight: FontWeight.w800,
            color: AppColors.white,
          )
        : AppTextStyles.nunito(
            size: 14,
            weight: FontWeight.w800,
            color: AppColors.white,
          );

    return _Tappable(
      onTap: onPressed,
      child: Container(
        height: height,
        width: expand ? double.infinity : null,
        padding: expand
            ? null
            : const EdgeInsetsDirectional.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: withShadow ? AppShadows.navyButton : AppShadows.none,
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, size: 20, color: AppColors.white),
              const SizedBox(width: AppSpacing.x8),
            ],
            Flexible(
              child: Text(
                label,
                style: style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The outline button: a `1.5px` navy border on a transparent fill.
class OutlineButton extends StatelessWidget {
  const OutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 48,
    this.radius = AppRadii.r14,
    this.expand = true,
    this.borderColor = AppColors.navy,
    this.foregroundColor = AppColors.navy,
    this.fillColor,
    this.fontSize,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? icon;
  final double height;
  final double radius;
  final bool expand;
  final Color borderColor;
  final Color foregroundColor;

  /// The sign-out button is white-filled rather than transparent.
  final Color? fillColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final size = fontSize ?? (height >= 56 ? 16.0 : 14.0);
    return _Tappable(
      onTap: onPressed,
      child: Container(
        height: height,
        width: expand ? double.infinity : null,
        padding: expand
            ? null
            : const EdgeInsetsDirectional.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, size: 20, color: foregroundColor),
              const SizedBox(width: AppSpacing.x8),
            ],
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.nunito(
                  size: size,
                  weight: FontWeight.w800,
                  color: foregroundColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A square icon button, e.g. the back chevron or the attach button.
class IconSquareButton extends StatelessWidget {
  const IconSquareButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.size = 48,
    this.radius = AppRadii.field,
    this.background = AppColors.white,
    this.foreground = AppColors.navy,
    this.iconSize = 22,
    this.strokeWidth = 2,
    this.boxShadow,
  });

  final String icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final double size;
  final double radius;
  final Color background;
  final Color foreground;
  final double iconSize;
  final double strokeWidth;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return _Tappable(
      onTap: onPressed,
      semanticLabel: semanticLabel,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: boxShadow ?? AppShadows.none,
        ),
        child: AppIcon(
          icon,
          size: iconSize,
          strokeWidth: strokeWidth,
          color: foreground,
        ),
      ),
    );
  }
}

/// A round icon button — the chunky student control.
class IconRoundButton extends StatelessWidget {
  const IconRoundButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.size = 48,
    this.background = AppColors.yellow,
    this.foreground = AppColors.navy,
    this.iconSize = 22,
    this.strokeWidth = 2,
    this.boxShadow = AppShadows.yellowButton,
  });

  final String icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final double size;
  final Color background;
  final Color foreground;
  final double iconSize;
  final double strokeWidth;
  final List<BoxShadow> boxShadow;

  @override
  Widget build(BuildContext context) {
    return _Tappable(
      onTap: onPressed,
      semanticLabel: semanticLabel,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          boxShadow: boxShadow,
        ),
        child: AppIcon(
          icon,
          size: iconSize,
          strokeWidth: strokeWidth,
          color: foreground,
        ),
      ),
    );
  }
}

/// A text-only link, sized to keep a 48dp touch target.
class AppTextLink extends StatelessWidget {
  const AppTextLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.info,
    this.fontSize = 14,
    this.minHeight = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double fontSize;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return _Tappable(
      onTap: onPressed,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.nunito(
            size: fontSize,
            weight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }
}
