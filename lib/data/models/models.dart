import 'package:characters/characters.dart';
import 'package:flutter/painting.dart';

import '../../core/theme/app_subjects.dart';

/// A point in the school day, in minutes since midnight.
///
/// The mockups work entirely in these minute offsets: `480` is 08:00 and
/// `960` is 16:00. Keeping the same unit means the timeline maths in the app
/// is the maths in the mockups.
extension type const MinuteOfDay(int minutes) {
  int get hour => minutes ~/ 60;
  int get minute => minutes % 60;

  /// `08:00`
  String get hhmm =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// `8h` — the compact form used in day summaries and student screens.
  String get short => minute == 0 ? '${hour}h' : hhmm;
}

/// One timetabled course.
class Lesson {
  const Lesson({
    required this.subject,
    required this.start,
    required this.end,
    required this.teacher,
    required this.room,
    this.changed = false,
  });

  final Subject subject;
  final MinuteOfDay start;
  final MinuteOfDay end;
  final String teacher;
  final String room;

  /// Marks a course that replaced another one.
  final bool changed;

  int get durationMinutes => end.minutes - start.minutes;

  /// `08:00–09:30`
  String get range => '${start.hhmm}–${end.hhmm}';
}

/// A child, as seen by a parent.
class Child {
  const Child({
    required this.id,
    required this.name,
    required this.grade,
    required this.avatarBackground,
    required this.avatarForeground,
    required this.mainTeacher,
    required this.hasAlert,
    required this.newLessonsLabel,
    required this.timetable,
    required this.notifications,
  });

  final String id;
  final String name;
  final String grade;
  final Color avatarBackground;
  final Color avatarForeground;
  final String mainTeacher;

  /// Whether this child has a pending change to announce.
  final bool hasAlert;

  /// "2 nouvelles" — a literal label in the mockups.
  final String newLessonsLabel;

  /// Monday's courses.
  final List<Lesson> timetable;
  final List<AppNotification> notifications;

  String get initial => name.characters.first;
}

/// Notification categories, each with its own medallion colours.
enum NotificationKind { lesson, change, school, message }

class AppNotification {
  const AppNotification({
    required this.kind,
    required this.title,
    required this.body,
    required this.time,
    this.unread = false,
    this.who,
  });

  final NotificationKind kind;
  final String title;
  final String body;

  /// A literal label in the mockups ("il y a 1 h", "hier", "jeu. 19").
  final String time;
  final bool unread;

  /// The person the notification is about.
  final Person? who;
}

/// Someone a notification or message is attached to.
class Person {
  const Person({
    required this.name,
    required this.background,
    required this.foreground,
  });

  final String name;
  final Color background;
  final Color foreground;

  String get initial => name.characters.first;
}

/// One day of the week timetable.
class SchoolDay {
  const SchoolDay({
    required this.shortLabel,
    required this.dayNumber,
    required this.fullLabel,
    required this.lessons,
    this.hasChange = false,
  });

  final String shortLabel;
  final int dayNumber;
  final String fullLabel;
  final List<Lesson> lessons;

  /// Shows the red dot on the day tab.
  final bool hasChange;
}

/// A downloadable document attached to a subject.
class LessonDocument {
  const LessonDocument({
    required this.title,
    required this.meta,
    required this.type,
    this.isNew = false,
    this.offline = false,
  });

  final String title;

  /// "M. Gharbi · 23 nov. · PDF 420 Ko"
  final String meta;

  /// The badge on the thumbnail: "PDF" or "IMG".
  final String type;
  final bool isNew;

  /// Already downloaded — the action becomes "open" instead of "download".
  final bool offline;
}

/// A group of documents for one subject.
class DocumentGroup {
  const DocumentGroup({required this.subject, required this.documents});

  final Subject subject;
  final List<LessonDocument> documents;

  String get countLabel =>
      '${documents.length} ${documents.length > 1 ? 'documents' : 'document'}';
}

/// A conversation in a message list.
class Conversation {
  const Conversation({
    required this.initials,
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.avatarBackground,
    required this.avatarForeground,
    this.locked = false,
    this.classLabel,
    this.childLabel,
  });

  final String initials;
  final String name;

  /// "Enseignante principale · Yassine"
  final String role;
  final String lastMessage;
  final String time;
  final int unread;
  final Color avatarBackground;
  final Color avatarForeground;

  /// Read-only conversation (the school announcements thread).
  final bool locked;

  /// Teacher view only: "4e B".
  final String? classLabel;

  /// Teacher view only: "maman de Yassine".
  final String? childLabel;

  bool get hasUnread => unread > 0;
}

/// A chat message.
class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.mine,
    required this.time,
    this.readReceipt = false,
    this.attachment,
  });

  final String text;

  /// Sent by the current user — a navy bubble aligned to the end.
  final bool mine;
  final String time;

  /// Appends "· Lu" and a green check.
  final bool readReceipt;
  final ChatAttachment? attachment;
}

class ChatAttachment {
  const ChatAttachment({
    required this.subject,
    required this.title,
    required this.meta,
  });

  final Subject subject;
  final String title;

  /// "PDF · 650 Ko"
  final String meta;
}

/// A teacher's timetable slot.
class TeacherSlot {
  const TeacherSlot({
    required this.time,
    required this.subject,
    required this.className,
    required this.room,
    this.state = TeacherSlotState.upcoming,
  });

  final MinuteOfDay time;
  final Subject subject;
  final String className;
  final String room;
  final TeacherSlotState state;
}

enum TeacherSlotState { done, now, upcoming }

/// A session a teacher can flag as absent or moved.
class TeacherSession {
  const TeacherSession({
    required this.time,
    required this.subject,
    required this.className,
    required this.familyCount,
  });

  final MinuteOfDay time;
  final Subject subject;

  /// "4e B · 28 élèves"
  final String className;

  /// How many *new* families this session reaches.
  ///
  /// The second 4e B session contributes `0` on purpose: its 28 families are
  /// already counted by the first one, so ticking every session totals 55 —
  /// both classes, not 83. See `docs/SPEC.md` §5.1 A2.
  final int familyCount;
}

/// A dummy account for mock sign-in, from `assets/mock_data/users.json`.
class UserAccount {
  const UserAccount({
    required this.id,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.password,
  });

  final String id;

  /// `"parent" | "eleve" | "enseignant"` — matches `AppRole.name`.
  final String role;
  final String firstName;
  final String lastName;

  /// 8 digits, no `+216` prefix.
  final String phone;
  final String password;

  String get fullName => '$firstName $lastName';
}
