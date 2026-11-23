import 'package:flutter/widgets.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import 'app_icon.dart';
import 'app_icon_paths.dart';

/// The toggle switch of the mockups.
///
/// A `52 × 32` track with `3px` padding and a `26 × 26` white thumb that sits
/// at one end or the other. See `docs/SPEC.md` §3.7.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    this.offColor = AppColors.fieldBorder,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String semanticLabel;

  /// The mockups use two different "off" greys: `#C9D6EC` on the settings and
  /// publish screens, `#A9B3D6` on the teacher availability banner.
  final Color offColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      toggled: value,
      container: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        // The track is 32 high but the touch target must reach 48.
        child: SizedBox(
          width: 52,
          height: 48,
          child: Center(
            child: Container(
              width: 52,
              height: 32,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: value ? AppColors.success : offColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Align(
                alignment: value
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.switchThumb,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The "always on" variant: a full green track carrying a padlock instead of
/// a thumb. Used by the "Absences et changements" setting.
class AppSwitchLocked extends StatelessWidget {
  const AppSwitchLocked({super.key, this.semanticLabel = 'Toujours activé'});

  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Container(
        width: 52,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const AppIcon(
          AppIcons.lock,
          size: 16,
          strokeWidth: 2.5,
          color: AppColors.white,
        ),
      ),
    );
  }
}
