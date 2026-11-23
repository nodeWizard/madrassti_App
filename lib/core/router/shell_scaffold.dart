import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../widgets/role_bottom_nav.dart';

/// The frame shared by every screen that sits inside a role's bottom
/// navigation: the app background, the branch content, and the nav bar.
class ShellScaffold extends StatelessWidget {
  const ShellScaffold({super.key, required this.role, required this.shell});

  final AppRole role;
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final tabs = NavTabs.of(role);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(child: shell),
          RoleBottomNav(
            role: role,
            activeId: tabs[shell.currentIndex].id,
            onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
          ),
        ],
      ),
    );
  }
}
