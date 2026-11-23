// Renders built screens at the 390x844 reference frame for side-by-side
// comparison with the mockups. Not an assertion test.
import 'dart:io';
import 'dart:ui' show ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:madrassti_app/core/providers/providers.dart';
import 'package:madrassti_app/core/theme/app_theme.dart';
import 'package:madrassti_app/data/mock/mock_data_loader.dart';
import 'package:madrassti_app/features/auth/login_screen.dart';
import 'package:madrassti_app/features/auth/signup_details_screen.dart';
import 'package:madrassti_app/features/onboarding/role_screen.dart';
import 'package:madrassti_app/features/onboarding/splash_screen.dart';
import 'package:madrassti_app/features/onboarding/welcome_screen.dart';
import 'package:madrassti_app/features/parent/chat_screen.dart';
import 'package:madrassti_app/features/parent/child_profile_screen.dart';
import 'package:madrassti_app/features/parent/dashboard_screen.dart';
import 'package:madrassti_app/features/parent/lessons_screen.dart';
import 'package:madrassti_app/features/parent/messages_screen.dart';
import 'package:madrassti_app/features/parent/notifications_screen.dart';
import 'package:madrassti_app/features/parent/week_screen.dart';
import 'package:madrassti_app/features/shared/settings_screen.dart';
import 'package:madrassti_app/features/student/student_alerts_screen.dart';
import 'package:madrassti_app/features/student/student_home_screen.dart';
import 'package:madrassti_app/features/student/student_lessons_screen.dart';
import 'package:madrassti_app/features/student/student_week_screen.dart';
import 'package:madrassti_app/features/teacher/teacher_absence_screen.dart';
import 'package:madrassti_app/features/teacher/teacher_home_screen.dart';
import 'package:madrassti_app/features/teacher/teacher_messages_screen.dart';
import 'package:madrassti_app/features/teacher/teacher_publish_screen.dart';
import 'package:madrassti_app/l10n/app_localizations.dart';

Future<void> _shot(WidgetTester tester, Widget screen, String name) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  final data = await tester.runAsync(MockData.load);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        parentRepositoryProvider.overrideWithValue(data!.parent),
        studentRepositoryProvider.overrideWithValue(data.student),
        teacherRepositoryProvider.overrideWithValue(data.teacher),
        authRepositoryProvider.overrideWithValue(data.auth),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(),
        locale: const Locale('fr'),
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: AppL10n.supportedLocales,
        home: RepaintBoundary(child: screen),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byType(RepaintBoundary).first,
  );
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2.0);
    final data = await image.toByteData(format: ImageByteFormat.png);
    return data!.buffer.asUint8List();
  });
  File('build/preview/$name.png')
    ..parent.createSync(recursive: true)
    ..writeAsBytesSync(bytes!);
}

void main() {
  // Onboarding & auth
  testWidgets('splash', (t) => _shot(t, const SplashScreen(), 'splash'));
  testWidgets('welcome', (t) => _shot(t, const WelcomeScreen(), 'welcome'));
  testWidgets(
    'role',
    (t) => _shot(t, const RoleScreen(), 'role'),
  );
  testWidgets('login', (t) => _shot(t, const LoginScreen(), 'login'));
  testWidgets(
    'signup_details',
    (t) => _shot(t, const SignupDetailsScreen(), 'signup_details'),
  );

  // Parent
  testWidgets(
    'dashboard',
    (t) => _shot(t, const DashboardScreen(), 'dashboard'),
  );
  testWidgets('week', (t) => _shot(t, const WeekScreen(), 'week'));
  testWidgets('lessons', (t) => _shot(t, const LessonsScreen(), 'lessons'));
  testWidgets(
    'notifications',
    (t) => _shot(t, const NotificationsScreen(), 'notifications'),
  );
  testWidgets('messages', (t) => _shot(t, const MessagesScreen(), 'messages'));
  testWidgets('chat', (t) => _shot(t, const ChatScreen(), 'chat'));
  testWidgets(
    'child_profile',
    (t) => _shot(t, const ChildProfileScreen(), 'child_profile'),
  );

  // Student
  testWidgets(
    'student_home',
    (t) => _shot(t, const StudentHomeScreen(), 'student_home'),
  );
  testWidgets(
    'student_week',
    (t) => _shot(t, const StudentWeekScreen(), 'student_week'),
  );
  testWidgets(
    'student_lessons',
    (t) => _shot(t, const StudentLessonsScreen(), 'student_lessons'),
  );
  testWidgets(
    'student_alerts',
    (t) => _shot(t, const StudentAlertsScreen(), 'student_alerts'),
  );

  // Teacher
  testWidgets(
    'teacher_home',
    (t) => _shot(t, const TeacherHomeScreen(), 'teacher_home'),
  );
  testWidgets(
    'teacher_publish',
    (t) => _shot(t, const TeacherPublishScreen(), 'teacher_publish'),
  );
  testWidgets(
    'teacher_absence',
    (t) => _shot(t, const TeacherAbsenceScreen(), 'teacher_absence'),
  );
  testWidgets(
    'teacher_messages',
    (t) => _shot(t, const TeacherMessagesScreen(), 'teacher_messages'),
  );

  // Shared
  testWidgets('settings', (t) => _shot(t, const SettingsScreen(), 'settings'));
}
