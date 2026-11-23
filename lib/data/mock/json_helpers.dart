import 'package:flutter/painting.dart';

import '../../core/theme/app_subjects.dart';
import '../models/models.dart';

/// Small helpers for turning the parsed JSON in `assets/mock_data/*.json`
/// into the app's model types.
abstract final class JsonHelpers {
  /// `"#FFC83D"` → `Color(0xFFFFC83D)`.
  static Color color(String hex) {
    final clean = hex.replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  static Subject subject(String code) => Subject.values.byName(code);

  static MinuteOfDay minute(int m) => MinuteOfDay(m);

  static Lesson lesson(Map<String, dynamic> j) => Lesson(
    subject: subject(j['subject'] as String),
    start: minute(j['start'] as int),
    end: minute(j['end'] as int),
    teacher: j['teacher'] as String? ?? '',
    room: j['room'] as String? ?? '',
    changed: j['changed'] as bool? ?? false,
  );

  static NotificationKind notificationKind(String code) =>
      NotificationKind.values.byName(code);

  static List<T> list<T>(
    dynamic json,
    T Function(Map<String, dynamic>) parse,
  ) => (json as List).cast<Map<String, dynamic>>().map(parse).toList();
}
