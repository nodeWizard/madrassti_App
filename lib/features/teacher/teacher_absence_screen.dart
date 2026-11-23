import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/fields.dart';
import '../../core/widgets/medallion.dart';
import '../../core/widgets/subject_tile.dart';
import '../../data/models/models.dart';
import '../../l10n/app_localizations.dart';
import '../parent/notifications_screen.dart' show SegmentButton;

enum _ReportType { absence, schedule, announcement }

enum _AbsenceOption { colleague, studyRoom, cancelled }

/// Board 16 · Absence ou changement.
///
/// Three report types, a live preview of what parents receive, and a success
/// sheet. The day picker defaults to Tuesday, as in the mockup.
class TeacherAbsenceScreen extends ConsumerStatefulWidget {
  const TeacherAbsenceScreen({super.key});

  @override
  ConsumerState<TeacherAbsenceScreen> createState() =>
      _TeacherAbsenceScreenState();
}

class _TeacherAbsenceScreenState extends ConsumerState<TeacherAbsenceScreen> {
  _ReportType _type = _ReportType.absence;
  int _day = 1; // Tuesday
  _AbsenceOption _option = _AbsenceOption.colleague;
  bool _sent = false;
  final Set<int> _uncheckedSessions = {};

  static const _days = [
    ('Lun', 23, 'lundi 23'),
    ('Mar', 24, 'mardi 24'),
    ('Mer', 25, 'mercredi 25'),
    ('Jeu', 26, 'jeudi 26'),
    ('Ven', 27, 'vendredi 27'),
    ('Sam', 28, 'samedi 28'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(teacherRepositoryProvider);
    final dayLabel = _days[_day].$3;

    final chosen = [
      for (var i = 0; i < repo.sessions.length; i++)
        if (!_uncheckedSessions.contains(i)) repo.sessions[i],
    ];
    final familyCount = _type == _ReportType.announcement
        ? 55
        : (chosen.isEmpty
              ? 28
              : chosen.fold<int>(0, (a, s) => a + s.familyCount));

    final preview = switch (_type) {
      _ReportType.absence => (
        bg: AppColors.coralTint,
        border: AppColors.coralBorder,
        iconBg: AppColors.coral,
        icon: AppIcons.user,
        ink: AppColors.danger,
        kicker: l10n.previewAbsenceKicker(dayLabel.toUpperCase()),
        title: l10n.previewAbsenceTitle(repo.teacherName),
        body: switch (_option) {
          _AbsenceOption.colleague => l10n.absenceBodyColleague,
          _AbsenceOption.studyRoom => l10n.absenceBodyStudy,
          _AbsenceOption.cancelled => l10n.absenceBodyCancelled,
        },
      ),
      _ReportType.schedule => (
        bg: AppColors.warnTintAlt,
        border: AppColors.warnBorder,
        iconBg: AppColors.yellow,
        icon: AppIcons.swap,
        ink: AppColors.warn,
        kicker: l10n.previewScheduleKicker,
        title: l10n.previewScheduleTitle(dayLabel),
        body: l10n.previewScheduleBody,
      ),
      _ReportType.announcement => (
        bg: AppColors.background,
        border: AppColors.infoBorder,
        iconBg: AppColors.infoTintAlt,
        icon: AppIcons.mega,
        ink: AppColors.info,
        kicker: l10n.previewAnnouncementKicker,
        title: l10n.previewAnnouncementTitle,
        body: l10n.previewAnnouncementBody,
      ),
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 8),
                  child: Row(
                    children: [
                      IconSquareButton(
                        icon: AppIcons.back,
                        semanticLabel: l10n.back,
                        boxShadow: AppShadows.card,
                        onPressed: () => context.canPop()
                            ? context.pop()
                            : context.go(Routes.teacherHome),
                      ),
                      const SizedBox(width: AppSpacing.x12),
                      Expanded(
                        child: Text(
                          l10n.notifyFamilies,
                          style: AppTextStyles.h3,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      12,
                      16,
                      24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ------------------------------------------ type
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.x4),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadii.field),
                          ),
                          child: Row(
                            children: [
                              for (final t in _ReportType.values) ...[
                                if (t != _ReportType.values.first)
                                  const SizedBox(width: AppSpacing.x4),
                                Expanded(
                                  child: SegmentButton(
                                    label: switch (t) {
                                      _ReportType.absence => l10n.typeAbsence,
                                      _ReportType.schedule =>
                                        l10n.typeSchedule,
                                      _ReportType.announcement =>
                                        l10n.typeAnnouncement,
                                    },
                                    selected: t == _type,
                                    height: 48,
                                    onTap: () => setState(() => _type = t),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x18),

                        // ------------------------------------------- day
                        Text(l10n.whichDay, style: AppTextStyles.buttonSmall),
                        const SizedBox(height: AppSpacing.x8),
                        GridView.count(
                          crossAxisCount: 6,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: AppSpacing.x6,
                          mainAxisSpacing: AppSpacing.x6,
                          childAspectRatio: 56 / 60,
                          children: [
                            for (var i = 0; i < _days.length; i++)
                              _DayPick(
                                short: _days[i].$1,
                                num: _days[i].$2,
                                selected: i == _day,
                                onTap: () => setState(() => _day = i),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x18),

                        if (_type == _ReportType.announcement) ...[
                          AppField(
                            label: l10n.yourAnnouncement,
                            child: const AppTextArea(
                              rows: 4,
                              initialText:
                                  'Sortie au jardin public mardi matin : '
                                  'prévoir une casquette et une bouteille '
                                  'd\'eau.',
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x18),
                        ],

                        if (_type != _ReportType.announcement) ...[
                          Text(
                            _type == _ReportType.schedule
                                ? l10n.whichSessionMoved
                                : l10n.sessionsConcerned,
                            style: AppTextStyles.buttonSmall,
                          ),
                          const SizedBox(height: AppSpacing.x8),
                          Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: AppSpacing.x12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.circular(AppRadii.r20),
                            ),
                            child: Column(
                              children: [
                                for (var i = 0; i < repo.sessions.length; i++)
                                  _SessionRow(
                                    session: repo.sessions[i],
                                    checked: !_uncheckedSessions.contains(i),
                                    showDivider: i > 0,
                                    onChanged: (v) => setState(() {
                                      if (v) {
                                        _uncheckedSessions.remove(i);
                                      } else {
                                        _uncheckedSessions.add(i);
                                      }
                                    }),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x18),
                        ],

                        if (_type == _ReportType.absence) ...[
                          Text(
                            l10n.whatHappensToStudents,
                            style: AppTextStyles.buttonSmall,
                          ),
                          const SizedBox(height: AppSpacing.x8),
                          Column(
                            children: [
                              for (final o in _AbsenceOption.values) ...[
                                if (o != _AbsenceOption.values.first)
                                  const SizedBox(height: AppSpacing.x6),
                                _OptionButton(
                                  label: switch (o) {
                                    _AbsenceOption.colleague =>
                                      l10n.optionColleague,
                                    _AbsenceOption.studyRoom =>
                                      l10n.optionStudyRoom,
                                    _AbsenceOption.cancelled =>
                                      l10n.optionCancelled,
                                  },
                                  selected: o == _option,
                                  onTap: () => setState(() => _option = o),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x18),
                        ],

                        if (_type == _ReportType.schedule) ...[
                          Row(
                            children: [
                              Expanded(
                                child: _PlainSelect(
                                  label: l10n.newDay,
                                  value: 'Jeudi 26',
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x10),
                              Expanded(
                                child: _PlainSelect(
                                  label: l10n.newTime,
                                  value: '14:00',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x18),
                        ],

                        // --------------------------------------- preview
                        Row(
                          children: [
                            const AppIcon(
                              AppIcons.info,
                              size: 16,
                              color: AppColors.ink,
                            ),
                            const SizedBox(width: AppSpacing.x6),
                            Text(
                              l10n.whatParentsSee,
                              style: AppTextStyles.buttonSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x8),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.x14),
                          decoration: BoxDecoration(
                            color: preview.bg,
                            borderRadius:
                                BorderRadius.circular(AppRadii.r22),
                            border: Border.all(
                              color: preview.border,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Medallion(
                                icon: preview.icon,
                                background: preview.iconBg,
                                foreground: AppColors.navy,
                                size: 40,
                                iconSize: 20,
                              ),
                              const SizedBox(width: AppSpacing.x12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      preview.kicker,
                                      style: AppTextStyles.kicker(
                                        color: preview.ink,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.x3),
                                    Text(
                                      preview.title,
                                      style: AppTextStyles.fredoka(
                                        size: 16,
                                        height: 1.25,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.x3),
                                    Text(
                                      preview.body,
                                      style: AppTextStyles.nunito(
                                        size: 13,
                                        weight: FontWeight.w400,
                                        height: 1.45,
                                        color: AppColors.inkMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: AppSpacing.stickyBar,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: AppRadii.navTop,
                    boxShadow: AppShadows.bottomBar,
                  ),
                  child: PrimaryButton(
                    label: l10n.notifyNFamilies(familyCount),
                    onPressed: () => setState(() => _sent = true),
                  ),
                ),
              ],
            ),
          ),
          if (_sent) const _SentSheet(),
        ],
      ),
    );
  }
}

class _DayPick extends StatelessWidget {
  const _DayPick({
    required this.short,
    required this.num,
    required this.selected,
    required this.onTap,
  });

  final String short;
  final int num;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.field),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  short,
                  style: AppTextStyles.nunito(
                    size: 12,
                    weight: FontWeight.w800,
                    color: selected ? AppColors.white : AppColors.navy,
                  ),
                ),
                Text(
                  '$num',
                  style: AppTextStyles.fredoka(
                    size: 18,
                    color: selected ? AppColors.white : AppColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.session,
    required this.checked,
    required this.showDivider,
    required this.onChanged,
  });

  final TeacherSession session;
  final bool checked;
  final bool showDivider;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final style = AppSubjects.of(session.subject);
    return Semantics(
      checked: checked,
      label: '${session.time.hhmm} ${style.name} ${session.className}',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(!checked),
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            decoration: BoxDecoration(
              border: showDivider
                  ? const Border(
                      top: BorderSide(color: AppColors.divider, width: 1.5),
                    )
                  : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: checked,
                    onChanged: (v) => onChanged(v ?? false),
                    activeColor: AppColors.navy,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(width: AppSpacing.x12),
                SizedBox(
                  width: 46,
                  child: Text(
                    session.time.hhmm,
                    style: AppTextStyles.nunito(
                      size: 14,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
                SubjectTile(
                  subject: session.subject,
                  size: 32,
                  excludeSemantics: true,
                ),
                const SizedBox(width: AppSpacing.x12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style.name,
                        style: AppTextStyles.nunito(
                          size: 14,
                          weight: FontWeight.w800,
                        ),
                      ),
                      Text(session.className, style: AppTextStyles.metaSmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      button: true,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.field),
              border: Border.all(
                color: selected ? AppColors.navy : AppColors.white,
                width: 2.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? AppColors.navy : AppColors.fieldBorder,
                      width: selected ? 6 : 2,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x10),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.nunito(
                      size: 15,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlainSelect extends StatelessWidget {
  const _PlainSelect({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.buttonSmall),
        const SizedBox(height: AppSpacing.x6),
        Container(
          height: 52,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.field),
            border: Border.all(color: AppColors.fieldBorder, width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.nunito(
                    size: 16,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              const AppIcon(
                AppIcons.chevron,
                size: 18,
                color: AppColors.inkSubtle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SentSheet extends StatelessWidget {
  const _SentSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Semantics(
      label: l10n.sent,
      container: true,
      child: Positioned.fill(
        child: Container(
          color: AppColors.scrimStrong,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: AppRadii.sheetTop,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.successTint,
                    shape: BoxShape.circle,
                  ),
                  child: const AppIcon(
                    AppIcons.check,
                    size: 36,
                    strokeWidth: 3,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: AppSpacing.x10),
                Text(l10n.familiesNotified, style: AppTextStyles.h3),
                const SizedBox(height: AppSpacing.x10),
                Text(
                  l10n.familiesNotifiedBody,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.nunito(
                    size: 15,
                    weight: FontWeight.w400,
                    height: 1.5,
                    color: AppColors.inkMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.x8),
                NavyButton(
                  label: l10n.backToHome,
                  onPressed: () => context.go(Routes.teacherHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
