import '../models/models.dart';
import '../repositories/repositories.dart';
import 'json_helpers.dart';

/// Teacher-facing dummy data (Mme Ben Salah's view), parsed from
/// `assets/mock_data/teacher.json`.
///
/// `sessions` swaps the subjects of the first two slots relative to the
/// mockup's own text, so this screen agrees with the teacher's agenda and
/// the parent week screen (`docs/SPEC.md` §5.1 A2) — the JSON file itself
/// carries that note under `sessionsNote`.
class MockTeacherRepository implements TeacherRepository {
  MockTeacherRepository.fromJson(Map<String, dynamic> json)
    : teacherName = json['teacherName'] as String,
      headerLabel = json['headerLabel'] as String,
      todaySlots = JsonHelpers.list(json['todaySlots'], _slot),
      unreadMessageCount = json['unreadMessageCount'] as int,
      lessonsPublishedThisWeek = json['lessonsPublishedThisWeek'] as int,
      sessions = JsonHelpers.list(json['sessions'], _session),
      classes = JsonHelpers.list(json['classes'], _klass),
      conversations = JsonHelpers.list(json['conversations'], _conversation);

  @override
  final String teacherName;
  @override
  final String headerLabel;
  @override
  final List<TeacherSlot> todaySlots;
  @override
  final int unreadMessageCount;
  @override
  final int lessonsPublishedThisWeek;
  @override
  final List<TeacherSession> sessions;
  @override
  final List<({String id, String label, int familyCount})> classes;
  @override
  final List<Conversation> conversations;

  static TeacherSlot _slot(Map<String, dynamic> j) => TeacherSlot(
    time: JsonHelpers.minute(j['time'] as int),
    subject: JsonHelpers.subject(j['subject'] as String),
    className: j['className'] as String,
    room: j['room'] as String,
    state: TeacherSlotState.values.byName(j['state'] as String),
  );

  static TeacherSession _session(Map<String, dynamic> j) => TeacherSession(
    time: JsonHelpers.minute(j['time'] as int),
    subject: JsonHelpers.subject(j['subject'] as String),
    className: j['className'] as String,
    familyCount: j['familyCount'] as int,
  );

  static ({String id, String label, int familyCount}) _klass(
    Map<String, dynamic> j,
  ) => (
    id: j['id'] as String,
    label: j['label'] as String,
    familyCount: j['familyCount'] as int,
  );

  static Conversation _conversation(Map<String, dynamic> j) => Conversation(
    initials: j['initials'] as String,
    name: j['name'] as String,
    role: j['role'] as String,
    childLabel: j['childLabel'] as String?,
    classLabel: j['classLabel'] as String?,
    lastMessage: j['lastMessage'] as String,
    time: j['time'] as String,
    unread: j['unread'] as int,
    avatarBackground: JsonHelpers.color(j['avatarBackground'] as String),
    avatarForeground: JsonHelpers.color(j['avatarForeground'] as String),
  );
}
