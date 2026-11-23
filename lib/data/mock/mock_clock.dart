import '../models/models.dart';
import '../repositories/repositories.dart';

/// The instant every mockup is drawn at: **Monday 23 November, 10:20**.
///
/// `620` minutes since midnight. The school day runs 08:00–16:00
/// (`480`–`960`), which is the span the dashboard timeline maps onto.
class MockClock implements Clock {
  const MockClock();

  /// 10:20.
  static const MinuteOfDay fixedNow = MinuteOfDay(620);

  /// 08:00 — the left edge of the day ribbon.
  static const MinuteOfDay dayStart = MinuteOfDay(480);

  /// 16:00 — the right edge of the day ribbon.
  static const MinuteOfDay dayEnd = MinuteOfDay(960);

  /// 480 minutes.
  static int get daySpan => dayEnd.minutes - dayStart.minutes;

  @override
  MinuteOfDay get now => fixedNow;

  @override
  String get todayLabel => 'Lundi 23 novembre';

  @override
  int get todayIndex => 0;
}
