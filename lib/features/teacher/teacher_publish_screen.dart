import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/app_switch.dart';
import '../../core/widgets/fields.dart';
import '../../core/widgets/subject_tile.dart';
import '../../core/widgets/zitoun.dart';
import '../../l10n/app_localizations.dart';
import '../parent/notifications_screen.dart' show SegmentButton;

/// Board 15 · Publier une leçon.
class TeacherPublishScreen extends ConsumerStatefulWidget {
  const TeacherPublishScreen({super.key});

  @override
  ConsumerState<TeacherPublishScreen> createState() =>
      _TeacherPublishScreenState();
}

class _TeacherPublishScreenState extends ConsumerState<TeacherPublishScreen> {
  String _classId = '4B';
  Subject _subject = Subject.ma;
  bool _notifyParents = true;
  bool _visibleToStudents = true;
  bool _done = false;

  final _title = TextEditingController(text: 'La multiplication posée');
  final _message = TextEditingController(
    text:
        'Exercices 1 à 4 à faire pour jeudi. La fiche d\'aide est en page 2.',
  );

  @override
  void dispose() {
    _title.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(teacherRepositoryProvider);
    final cls = repo.classes.firstWhere((c) => c.id == _classId);

    final who = _notifyParents && _visibleToStudents
        ? l10n.audienceBoth
        : _notifyParents
        ? l10n.audienceParents
        : _visibleToStudents
        ? l10n.audienceStudents
        : l10n.audienceNobody;

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
                          l10n.publishLesson,
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
                        // ----------------------------------------- class
                        Text(l10n.classLabel, style: AppTextStyles.buttonSmall),
                        const SizedBox(height: AppSpacing.x8),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.x4),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadii.field),
                          ),
                          child: Row(
                            children: [
                              for (final c in repo.classes) ...[
                                if (c != repo.classes.first)
                                  const SizedBox(width: AppSpacing.x6),
                                Expanded(
                                  child: SegmentButton(
                                    label: c.label,
                                    selected: c.id == _classId,
                                    onTap: () =>
                                        setState(() => _classId = c.id),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x18),

                        // --------------------------------------- subject
                        Text(l10n.subjectLabel, style: AppTextStyles.buttonSmall),
                        const SizedBox(height: AppSpacing.x8),
                        Row(
                          children: [
                            for (final s in [Subject.ar, Subject.ma]) ...[
                              if (s != Subject.ar)
                                const SizedBox(width: AppSpacing.x10),
                              Expanded(
                                child: _SubjectPick(
                                  subject: s,
                                  selected: s == _subject,
                                  onTap: () => setState(() => _subject = s),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x18),

                        AppField(
                          label: l10n.lessonTitleLabel,
                          child: AppTextField(
                            controller: _title,
                            height: 54,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x18),

                        AppField(
                          label: l10n.wordForFamilies,
                          optionalSuffix: l10n.optional,
                          child: AppTextArea(controller: _message, rows: 3),
                        ),
                        const SizedBox(height: AppSpacing.x18),

                        // -------------------------------------- documents
                        Text(l10n.documents, style: AppTextStyles.buttonSmall),
                        const SizedBox(height: AppSpacing.x8),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.x10),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadii.field),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 52,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.infoTint,
                                  borderRadius:
                                      BorderRadius.circular(AppRadii.thumb),
                                ),
                                child: const AppIcon(
                                  AppIcons.file,
                                  size: 22,
                                  color: AppColors.info,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'multiplication-posee.pdf',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    Text(
                                      'PDF · 650 Ko · prêt',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.inkSubtle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconSquareButton(
                                icon: AppIcons.x,
                                semanticLabel: l10n.removeFile,
                                size: 44,
                                radius: AppRadii.r14,
                                background: AppColors.chipFill,
                                foreground: AppColors.inkSubtle,
                                iconSize: 18,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x10),
                        OutlineButton(
                          label: l10n.addFileOrPhoto,
                          icon: AppIcons.plus,
                          height: 56,
                          borderColor: AppColors.dashedBorder,
                          foregroundColor: AppColors.info,
                          onPressed: () {},
                        ),
                        const SizedBox(height: AppSpacing.x18),

                        // -------------------------------------- audience
                        Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: AppSpacing.x14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadii.field),
                          ),
                          child: Column(
                            children: [
                              _ToggleRow(
                                label: l10n.notifyParents,
                                value: _notifyParents,
                                showDivider: false,
                                onChanged: (v) =>
                                    setState(() => _notifyParents = v),
                              ),
                              _ToggleRow(
                                label: l10n.visibleInKidMode,
                                value: _visibleToStudents,
                                showDivider: true,
                                onChanged: (v) =>
                                    setState(() => _visibleToStudents = v),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.publishSummary(cls.familyCount, who),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.meta,
                      ),
                      const SizedBox(height: AppSpacing.x10),
                      PrimaryButton(
                        label: l10n.publishTheLesson,
                        onPressed: () => setState(() => _done = true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_done)
            _SuccessSheet(
              text: l10n.lessonPublishedBody(
                cls.familyCount,
                _classId == 'both' ? l10n.bothClasses : cls.label,
              ),
            ),
        ],
      ),
    );
  }
}

class _SubjectPick extends StatelessWidget {
  const _SubjectPick({
    required this.subject,
    required this.selected,
    required this.onTap,
  });

  final Subject subject;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = AppSubjects.of(subject);
    return Semantics(
      button: true,
      selected: selected,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            height: 64,
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 12, 0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r20),
              border: Border.all(
                color: selected ? AppColors.navy : AppColors.white,
                width: 2.5,
              ),
            ),
            child: Row(
              children: [
                SubjectTile(subject: subject, size: 40, excludeSemantics: true),
                const SizedBox(width: AppSpacing.x10),
                Expanded(
                  child: Text(
                    style.name,
                    style: AppTextStyles.nunito(
                      size: 15,
                      weight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.showDivider,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final bool showDivider;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                top: BorderSide(color: AppColors.divider, width: 1.5),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.nunito(size: 15, weight: FontWeight.w700),
            ),
          ),
          AppSwitch(value: value, onChanged: onChanged, semanticLabel: label),
        ],
      ),
    );
  }
}

/// Shared between the publish and absence screens.
class _SuccessSheet extends StatelessWidget {
  const _SuccessSheet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Semantics(
      label: l10n.lessonPublished,
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
                const Zitoun(
                  size: 120,
                  mood: ZitounMood.bravo,
                  excludeSemantics: true,
                ),
                const SizedBox(height: AppSpacing.x10),
                Text(l10n.lessonPublished, style: AppTextStyles.h3),
                const SizedBox(height: AppSpacing.x10),
                Text(
                  text,
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
