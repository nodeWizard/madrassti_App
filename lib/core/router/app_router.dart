import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_details_screen.dart';
import '../../features/onboarding/role_screen.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/parent/chat_screen.dart';
import '../../features/parent/child_profile_screen.dart';
import '../../features/parent/dashboard_screen.dart';
import '../../features/parent/lessons_screen.dart';
import '../../features/parent/messages_screen.dart';
import '../../features/parent/notifications_screen.dart';
import '../../features/parent/week_screen.dart';
import '../../features/shared/settings_screen.dart';
import '../../features/student/student_alerts_screen.dart';
import '../../features/student/student_home_screen.dart';
import '../../features/student/student_lessons_screen.dart';
import '../../features/student/student_week_screen.dart';
import '../../features/teacher/teacher_absence_screen.dart';
import '../../features/teacher/teacher_home_screen.dart';
import '../../features/teacher/teacher_messages_screen.dart';
import '../../features/teacher/teacher_publish_screen.dart';
import '../widgets/role_bottom_nav.dart';
import 'shell_scaffold.dart';

/// Route paths. Each mirrors a mockup board.
abstract final class Routes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const login = '/login';
  static const signupRole = '/signup/role';
  static const signupDetails = '/signup/details';

  /// The standalone role picker, reached from settings and the kid-mode lock.
  static const role = '/role';

  // Parent shell
  static const dashboard = '/parent/dashboard';
  static const week = '/parent/week';
  static const lessons = '/parent/lessons';
  static const messages = '/parent/messages';
  static const settings = '/parent/settings';
  // Parent detail screens, pushed above the shell.
  static const notifications = '/parent/notifications';
  static const chat = '/parent/chat';
  static const childProfile = '/parent/child';

  // Student shell
  static const studentHome = '/student/home';
  static const studentWeek = '/student/week';
  static const studentLessons = '/student/lessons';
  static const studentAlerts = '/student/alerts';

  // Teacher shell
  static const teacherHome = '/teacher/home';
  static const teacherPublish = '/teacher/publish';
  static const teacherAbsence = '/teacher/absence';
  static const teacherMessages = '/teacher/messages';
}

final _rootKey = GlobalKey<NavigatorState>();

/// The app router.
///
/// Each role's bottom navigation lives in its own [StatefulShellRoute], so
/// switching tabs preserves each branch's scroll position and state, and the
/// nav bar stays mounted. Detail screens that the mockups show without a nav
/// bar (chat, notifications, the teacher forms) are pushed on the root
/// navigator instead.
GoRouter createRouter() => GoRouter(
  navigatorKey: _rootKey,
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.signupRole,
      builder: (context, state) => const RoleScreen(mode: RoleScreenMode.signup),
    ),
    GoRoute(
      path: Routes.signupDetails,
      builder: (context, state) => const SignupDetailsScreen(),
    ),
    GoRoute(
      path: Routes.role,
      builder: (context, state) =>
          const RoleScreen(mode: RoleScreenMode.standalone),
    ),

    // ----------------------------------------------------------- parent
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) =>
          ShellScaffold(role: AppRole.parent, shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.dashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.week,
              builder: (context, state) => const WeekScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.lessons,
              builder: (context, state) => const LessonsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.messages,
              builder: (context, state) => const MessagesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),

    // ------------------------------------------------------------ student
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) =>
          ShellScaffold(role: AppRole.eleve, shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.studentHome,
              builder: (context, state) => const StudentHomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.studentWeek,
              builder: (context, state) => const StudentWeekScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.studentLessons,
              builder: (context, state) => const StudentLessonsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.studentAlerts,
              builder: (context, state) => const StudentAlertsScreen(),
            ),
          ],
        ),
      ],
    ),

    // ------------------------------------------------------------ teacher
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) =>
          ShellScaffold(role: AppRole.enseignant, shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.teacherHome,
              builder: (context, state) => const TeacherHomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.teacherPublish,
              builder: (context, state) => const TeacherPublishScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.teacherAbsence,
              builder: (context, state) => const TeacherAbsenceScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.teacherMessages,
              builder: (context, state) => const TeacherMessagesScreen(),
            ),
          ],
        ),
        // The teacher's "Profil" tab opens the shared settings screen, as in
        // the mockups, where its nav target is Settings.dc.html.
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/teacher/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),

    // ---------------------------------------- detail screens, no nav bar
    GoRoute(
      path: Routes.notifications,
      parentNavigatorKey: _rootKey,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: Routes.chat,
      parentNavigatorKey: _rootKey,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: Routes.childProfile,
      parentNavigatorKey: _rootKey,
      builder: (context, state) => const ChildProfileScreen(),
    ),
  ],
);
