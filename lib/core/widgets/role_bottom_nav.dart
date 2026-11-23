import 'package:flutter/widgets.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';
import 'app_icon_paths.dart';

/// The three roles of the app.
enum AppRole { parent, eleve, enseignant }

/// One tab of the bottom navigation bar.
class NavTab {
  const NavTab({
    required this.id,
    required this.icon,
    required this.label,
    this.badge,
  });

  final String id;
  final String icon;
  final String label;

  /// Badge text, as a literal string in the mockups ("2", "1", "5").
  final String? badge;

  bool get hasBadge => badge != null && badge!.isNotEmpty;
}

/// Tab sets transcribed from the `Nav` component. See `docs/SPEC.md` §3.4.
abstract final class NavTabs {
  static const parent = <NavTab>[
    NavTab(id: 'home', icon: AppIcons.home, label: 'Accueil'),
    NavTab(id: 'week', icon: AppIcons.calendar, label: 'Semaine'),
    NavTab(id: 'lessons', icon: AppIcons.book, label: 'Leçons'),
    NavTab(id: 'messages', icon: AppIcons.message, label: 'Messages', badge: '2'),
    NavTab(id: 'profile', icon: AppIcons.user, label: 'Profil'),
  ];

  static const eleve = <NavTab>[
    NavTab(id: 'home', icon: AppIcons.home, label: 'Accueil'),
    NavTab(id: 'week', icon: AppIcons.calendar, label: 'Ma semaine'),
    NavTab(id: 'lessons', icon: AppIcons.book, label: 'Leçons'),
    NavTab(id: 'alerts', icon: AppIcons.bell, label: 'Alertes', badge: '1'),
  ];

  static const enseignant = <NavTab>[
    NavTab(id: 'home', icon: AppIcons.home, label: 'Accueil'),
    NavTab(id: 'publish', icon: AppIcons.upload, label: 'Publier'),
    NavTab(id: 'change', icon: AppIcons.swap, label: 'Changements'),
    NavTab(id: 'messages', icon: AppIcons.message, label: 'Messages', badge: '5'),
    NavTab(id: 'profile', icon: AppIcons.user, label: 'Profil'),
  ];

  static List<NavTab> of(AppRole role) => switch (role) {
    AppRole.parent => parent,
    AppRole.eleve => eleve,
    AppRole.enseignant => enseignant,
  };
}

/// The bottom navigation bar.
///
/// Student tabs are deliberately larger: a `68 × 44` pill, a 28px icon and a
/// 14px label, which makes the bar 96 tall instead of 82.
class RoleBottomNav extends StatelessWidget {
  const RoleBottomNav({
    super.key,
    required this.role,
    required this.activeId,
    required this.onTap,
  });

  final AppRole role;

  /// Id of the active tab, or an empty string when none is highlighted.
  final String activeId;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final tabs = NavTabs.of(role);
    final kid = role == AppRole.eleve;

    final pillWidth = kid ? 68.0 : 56.0;
    final pillHeight = kid ? 44.0 : 32.0;
    final iconSize = kid ? 28.0 : 22.0;
    final fontSize = kid ? 14.0 : 12.0;

    return Container(
      width: double.infinity,
      padding: AppSpacing.nav,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.navTop,
        boxShadow: AppShadows.bottomBar,
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: _NavItem(
                tab: tabs[i],
                selected: tabs[i].id == activeId,
                pillWidth: pillWidth,
                pillHeight: pillHeight,
                iconSize: iconSize,
                fontSize: fontSize,
                onTap: () => onTap(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.pillWidth,
    required this.pillHeight,
    required this.iconSize,
    required this.fontSize,
    required this.onTap,
  });

  final NavTab tab;
  final bool selected;
  final double pillWidth;
  final double pillHeight;
  final double iconSize;
  final double fontSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.navy : AppColors.inkSubtle;

    return Semantics(
      button: true,
      selected: selected,
      label: tab.hasBadge
          ? '${tab.label}, ${tab.badge} non lus'
          : tab.label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: pillWidth,
                  height: pillHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.yellow
                                : const Color(0x00000000),
                            borderRadius: BorderRadius.circular(AppRadii.r20),
                          ),
                          alignment: Alignment.center,
                          child: AppIcon(
                            tab.icon,
                            size: iconSize,
                            color: foreground,
                          ),
                        ),
                      ),
                      if (tab.hasBadge)
                        PositionedDirectional(
                          top: 0,
                          end: 8,
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 16),
                            height: 16,
                            alignment: Alignment.center,
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.dangerStrong,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tab.badge!,
                              textScaler: TextScaler.noScaling,
                              style: AppTextStyles.badgeTiny.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Flexible(
                  child: Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: AppTextStyles.nunito(
                      size: fontSize,
                      weight: FontWeight.w800,
                      color: foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
