import '../../core/theme/app_subjects.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';
import 'json_helpers.dart';

/// Parent-facing dummy data, parsed from `assets/mock_data/parent.json`.
///
/// Every name, time, label and body string lives in that JSON file, not in
/// this class — this is purely a typed view over the parsed document, built
/// once by [MockParentRepository.fromJson].
class MockParentRepository implements ParentRepository {
  MockParentRepository.fromJson(Map<String, dynamic> json)
    : parentName = json['parentName'] as String,
      children = JsonHelpers.list(json['children'], _child),
      week = JsonHelpers.list(json['week'], _schoolDay),
      documentGroups = JsonHelpers.list(json['documentGroups'], _group),
      _people = {
        for (final e in (json['people'] as Map<String, dynamic>).entries)
          e.key: _person(e.value as Map<String, dynamic>),
      },
      _teacherDirectory = json['teacherDirectory'] as Map<String, dynamic>,
      quickReplies = (json['quickReplies'] as List).cast<String>() {
    pinnedNotification = _notification(
      json['pinnedNotification'] as Map<String, dynamic>,
      _people,
    );
    notificationSections = JsonHelpers.list(
      json['notificationSections'],
      (j) => (
        title: j['title'] as String,
        items: JsonHelpers.list(
          j['items'],
          (n) => _notification(n, _people),
        ),
      ),
    );
    conversations = JsonHelpers.list(json['conversations'], _conversation);
    chatThread = JsonHelpers.list(json['chatThread'], _chatMessage);
  }

  final Map<String, Person> _people;
  final Map<String, dynamic> _teacherDirectory;

  @override
  final String parentName;
  @override
  final List<Child> children;
  @override
  final List<SchoolDay> week;
  @override
  final List<DocumentGroup> documentGroups;
  @override
  late final AppNotification? pinnedNotification;
  @override
  late final List<({String title, List<AppNotification> items})>
  notificationSections;
  @override
  late final List<Conversation> conversations;
  @override
  late final List<ChatMessage> chatThread;
  @override
  final List<String> quickReplies;

  @override
  Child childById(String id) => children.firstWhere((c) => c.id == id);

  @override
  String whoLabel(Subject s) {
    final d = _teacherDirectory[s.name] as Map<String, dynamic>;
    return '${d['name']} · ${d['room']}';
  }

  static Child _child(Map<String, dynamic> j) => Child(
    id: j['id'] as String,
    name: j['name'] as String,
    grade: j['grade'] as String,
    avatarBackground: JsonHelpers.color(j['avatarBackground'] as String),
    avatarForeground: JsonHelpers.color(j['avatarForeground'] as String),
    mainTeacher: j['mainTeacher'] as String,
    hasAlert: j['hasAlert'] as bool,
    newLessonsLabel: j['newLessonsLabel'] as String,
    timetable: JsonHelpers.list(j['timetable'], JsonHelpers.lesson),
    notifications: JsonHelpers.list(
      j['notifications'],
      (n) => _notification(n, const {}),
    ),
  );

  static SchoolDay _schoolDay(Map<String, dynamic> j) => SchoolDay(
    shortLabel: j['shortLabel'] as String,
    dayNumber: j['dayNumber'] as int,
    fullLabel: j['fullLabel'] as String,
    hasChange: j['hasChange'] as bool? ?? false,
    lessons: JsonHelpers.list(j['lessons'], JsonHelpers.lesson),
  );

  static DocumentGroup _group(Map<String, dynamic> j) => DocumentGroup(
    subject: JsonHelpers.subject(j['subject'] as String),
    documents: JsonHelpers.list(j['documents'], _document),
  );

  static LessonDocument _document(Map<String, dynamic> j) => LessonDocument(
    title: j['title'] as String,
    meta: j['meta'] as String,
    type: j['type'] as String,
    isNew: j['isNew'] as bool? ?? false,
    offline: j['offline'] as bool? ?? false,
  );

  static Person _person(Map<String, dynamic> j) => Person(
    name: j['name'] as String,
    background: JsonHelpers.color(j['background'] as String),
    foreground: JsonHelpers.color(j['foreground'] as String),
  );

  static AppNotification _notification(
    Map<String, dynamic> j,
    Map<String, Person> people,
  ) => AppNotification(
    kind: JsonHelpers.notificationKind(j['kind'] as String),
    title: j['title'] as String,
    body: j['body'] as String,
    time: j['time'] as String,
    unread: j['unread'] as bool? ?? false,
    who: j['who'] == null ? null : people[j['who'] as String],
  );

  static Conversation _conversation(Map<String, dynamic> j) => Conversation(
    initials: j['initials'] as String,
    name: j['name'] as String,
    role: j['role'] as String,
    lastMessage: j['lastMessage'] as String,
    time: j['time'] as String,
    unread: j['unread'] as int,
    avatarBackground: JsonHelpers.color(j['avatarBackground'] as String),
    avatarForeground: JsonHelpers.color(j['avatarForeground'] as String),
    locked: j['locked'] as bool? ?? false,
  );

  static ChatMessage _chatMessage(Map<String, dynamic> j) => ChatMessage(
    text: j['text'] as String,
    mine: j['mine'] as bool,
    time: j['time'] as String,
    readReceipt: j['readReceipt'] as bool? ?? false,
    attachment: j['attachment'] == null
        ? null
        : _attachment(j['attachment'] as Map<String, dynamic>),
  );

  static ChatAttachment _attachment(Map<String, dynamic> j) => ChatAttachment(
    subject: JsonHelpers.subject(j['subject'] as String),
    title: j['title'] as String,
    meta: j['meta'] as String,
  );
}
