import '../../core/theme/app_subjects.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';
import 'json_helpers.dart';

/// Student-facing dummy data (Lina's view), parsed from
/// `assets/mock_data/student.json`.
class MockStudentRepository implements StudentRepository {
  MockStudentRepository.fromJson(Map<String, dynamic> json)
    : studentName = json['studentName'] as String,
      currentLesson = JsonHelpers.lesson(
        json['currentLesson'] as Map<String, dynamic>,
      ),
      daySteps = JsonHelpers.list(json['daySteps'], _step),
      week = JsonHelpers.list(json['week'], _weekDay),
      lessons = {
        for (final e in (json['lessons'] as Map<String, dynamic>).entries)
          JsonHelpers.subject(e.key): (e.value as List)
              .cast<Map<String, dynamic>>()
              .map(_studentLesson)
              .toList(),
      };

  @override
  final String studentName;
  @override
  final Lesson currentLesson;
  @override
  final List<({Subject? subject, bool isLunch, String time, bool done, bool now})>
  daySteps;
  @override
  final List<({String label, List<({Subject subject, String time})> morning,
         List<({Subject subject, String time})> afternoon})>
  week;
  @override
  final Map<Subject, List<({String glyph, String title, bool isNew})>> lessons;

  static ({Subject? subject, bool isLunch, String time, bool done, bool now})
  _step(Map<String, dynamic> j) => (
    subject: j['subject'] == null
        ? null
        : JsonHelpers.subject(j['subject'] as String),
    isLunch: j['isLunch'] as bool,
    time: j['time'] as String,
    done: j['done'] as bool,
    now: j['now'] as bool,
  );

  static ({Subject subject, String time}) _slot(Map<String, dynamic> j) => (
    subject: JsonHelpers.subject(j['subject'] as String),
    time: j['time'] as String,
  );

  static ({
    String label,
    List<({Subject subject, String time})> morning,
    List<({Subject subject, String time})> afternoon,
  })
  _weekDay(Map<String, dynamic> j) => (
    label: j['label'] as String,
    morning: JsonHelpers.list(j['morning'], _slot),
    afternoon: JsonHelpers.list(j['afternoon'], _slot),
  );

  static ({String glyph, String title, bool isNew}) _studentLesson(
    Map<String, dynamic> j,
  ) => (
    glyph: j['glyph'] as String,
    title: j['title'] as String,
    isNew: j['isNew'] as bool,
  );
}
