import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/mock_clock.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../widgets/role_bottom_nav.dart';

/// "Now", fixed at Monday 23 November 10:20 so the app matches the mockups.
/// Override this in tests or when a real clock is wired in.
final clockProvider = Provider<Clock>((ref) => const MockClock());

/// These three repositories are always overridden in `main.dart` once
/// `MockData.load()` has parsed `assets/mock_data/*.json`. The `UnimplementedError`
/// defaults make any accidental use before that override loud rather than
/// silently returning empty data.
final parentRepositoryProvider = Provider<ParentRepository>(
  (ref) => throw UnimplementedError(
    'parentRepositoryProvider must be overridden — see main.dart',
  ),
);

final studentRepositoryProvider = Provider<StudentRepository>(
  (ref) => throw UnimplementedError(
    'studentRepositoryProvider must be overridden — see main.dart',
  ),
);

final teacherRepositoryProvider = Provider<TeacherRepository>(
  (ref) => throw UnimplementedError(
    'teacherRepositoryProvider must be overridden — see main.dart',
  ),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => throw UnimplementedError(
    'authRepositoryProvider must be overridden — see main.dart',
  ),
);

/// The signed-in dummy account, once login or sign-up succeeds.
final currentUserProvider = NotifierProvider<ValueNotifierOf<UserAccount?>, UserAccount?>(
  () => ValueNotifierOf(null),
);

/// A tiny notifier for a single mutable value.
class ValueNotifierOf<T> extends Notifier<T> {
  ValueNotifierOf(this._initial);

  final T _initial;

  @override
  T build() => _initial;

  void set(T value) => state = value;
}

/// Which child the parent screens are showing. The dashboard's child switcher
/// writes here, and the rest of the parent section reads it.
final selectedChildProvider = NotifierProvider<ValueNotifierOf<String>, String>(
  () => ValueNotifierOf('yassine'),
);

/// Whether the dashboard alert card has been dismissed.
final alertDismissedProvider = NotifierProvider<ValueNotifierOf<bool>, bool>(
  () => ValueNotifierOf(false),
);

/// The role chosen during onboarding, used to pick the home screen after a
/// mock sign-in.
final selectedRoleProvider =
    NotifierProvider<ValueNotifierOf<AppRole>, AppRole>(
      () => ValueNotifierOf(AppRole.parent),
    );

/// Whether every notification has been marked as read.
final notificationsReadProvider =
    NotifierProvider<ValueNotifierOf<bool>, bool>(() => ValueNotifierOf(false));
