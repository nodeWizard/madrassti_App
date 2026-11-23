import '../../core/theme/app_subjects.dart';
import '../models/models.dart';

/// Where "now" comes from.
///
/// The mockups are drawn at a fixed instant — Monday 23 November, 10:20 — and
/// every "En cours" ring, progress bar and dimmed past course derives from it.
/// Injecting the clock keeps the app matching the mockups and keeps golden
/// tests deterministic.
abstract interface class Clock {
  /// Minutes since midnight.
  MinuteOfDay get now;

  /// "Lundi 23 novembre"
  String get todayLabel;

  /// Index of today in the Monday-to-Saturday week.
  int get todayIndex;
}

/// Parent-facing data.
abstract interface class ParentRepository {
  /// The signed-in parent's first name.
  String get parentName;

  List<Child> get children;

  Child childById(String id);

  /// Yassine's week, as shown on the week screen.
  List<SchoolDay> get week;

  /// "Mme Ben Salah · Salle 4" — teacher and room for a subject, as shown on
  /// the parent week screen.
  String whoLabel(Subject s);

  List<DocumentGroup> get documentGroups;

  /// Notifications grouped by the section titles of the mockups.
  List<({String title, List<AppNotification> items})> get notificationSections;

  /// The pinned "À retenir" item, or `null` when there is none.
  AppNotification? get pinnedNotification;

  List<Conversation> get conversations;

  /// The opening messages of the conversation with Mme Ben Salah.
  List<ChatMessage> get chatThread;

  /// Canned replies offered above the chat input.
  List<String> get quickReplies;
}

/// Student-facing data (Lina's view).
abstract interface class StudentRepository {
  String get studentName;

  /// The course happening right now.
  Lesson get currentLesson;

  /// Today's steps, including the lunch break.
  List<({Subject? subject, bool isLunch, String time, bool done, bool now})>
  get daySteps;

  /// Morning and afternoon courses for each weekday.
  List<({String label, List<({Subject subject, String time})> morning,
         List<({Subject subject, String time})> afternoon})> get week;

  /// Lessons per subject, keyed by subject.
  Map<Subject, List<({String glyph, String title, bool isNew})>> get lessons;
}

/// Teacher-facing data (Mme Ben Salah's view).
abstract interface class TeacherRepository {
  String get teacherName;

  /// "Lundi 23 novembre · École Ibn Khaldoun"
  String get headerLabel;

  List<TeacherSlot> get todaySlots;

  int get unreadMessageCount;

  int get lessonsPublishedThisWeek;

  List<Conversation> get conversations;

  /// Sessions offered on the absence / change screen.
  List<TeacherSession> get sessions;

  /// Classes a lesson can be published to, with their family counts.
  List<({String id, String label, int familyCount})> get classes;
}

/// Dummy accounts for mock sign-in, from `assets/mock_data/users.json`.
abstract interface class AuthRepository {
  List<UserAccount> get users;

  /// Returns the matching account, or `null` if the phone/password pair
  /// doesn't match any dummy user.
  UserAccount? signIn({required String phone, required String password});
}
