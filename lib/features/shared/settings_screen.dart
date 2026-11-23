import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/app_switch.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/medallion.dart';
import '../../core/widgets/screen.dart';
import '../../l10n/app_localizations.dart';

/// Board 19 · Profil et réglages.
///
/// Shared between the parent and teacher "Profil" tabs. The "mes enfants"
/// list, child-add shortcut and kid-mode link follow the mockup, which is
/// written from the parent's point of view.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _french = true;
  int _textSize = 1;
  bool _notifyLessons = true;
  bool _notifySchool = true;
  bool _notifyQuiet = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(parentRepositoryProvider);

    const sizes = [14.0, 18.0, 23.0];
    final sizeLabels = [
      l10n.textSizeSmall,
      l10n.textSizeNormal,
      l10n.textSizeLarge,
    ];

    return AppScreen(
      gap: AppSpacing.x16,
      children: [
        Text(l10n.settingsTitle, style: AppTextStyles.h1),

        // ------------------------------------------------------ profile
        Container(
          padding: const EdgeInsets.all(AppSpacing.x16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.r24),
          ),
          child: Row(
            children: [
              InitialAvatar(
                initials: repo.parentName.characters.first,
                background: AppColors.navy,
                foreground: AppColors.white,
                size: 60,
                radius: AppRadii.r20,
                fontSize: 26,
              ),
              const SizedBox(width: AppSpacing.x14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(repo.parentName, style: AppTextStyles.h6),
                    const SizedBox(height: AppSpacing.x2),
                    Text(l10n.parentWithPhone, style: AppTextStyles.meta),
                  ],
                ),
              ),
              IconSquareButton(
                icon: AppIcons.pencil,
                semanticLabel: l10n.editProfile,
                background: AppColors.background,
                iconSize: 20,
                onPressed: () {},
              ),
            ],
          ),
        ),

        // ------------------------------------------------------ children
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.myChildren, style: AppTextStyles.sectionHeader()),
            const SizedBox(height: AppSpacing.x8),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x12,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadii.r22),
              ),
              child: Column(
                children: [
                  for (final c in repo.children)
                    _ChildLink(
                      initial: c.initial,
                      background: c.avatarBackground,
                      foreground: c.avatarForeground,
                      name: c.name,
                      subtitle: '${c.grade} · ${c.mainTeacher}',
                      onTap: () {
                        ref.read(selectedChildProvider.notifier).set(c.id);
                        context.push(Routes.childProfile);
                      },
                    ),
                  _AddChildLink(onTap: () => context.push(Routes.role)),
                ],
              ),
            ),
          ],
        ),

        // ------------------------------------------------- language & size
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.languageAndDisplay,
              style: AppTextStyles.sectionHeader(),
            ),
            const SizedBox(height: AppSpacing.x8),
            Container(
              padding: const EdgeInsets.all(AppSpacing.x14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadii.r22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    label: l10n.languageGroup,
                    container: true,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.x4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppRadii.field),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _LangButton(
                              label: l10n.languageFrench,
                              selected: _french,
                              style: AppTextStyles.nunito(
                                size: 15,
                                weight: FontWeight.w800,
                                color: _french
                                    ? AppColors.white
                                    : AppColors.navy,
                              ),
                              onTap: () => setState(() => _french = true),
                            ),
                          ),
                          Expanded(
                            child: _LangButton(
                              label: l10n.languageArabic,
                              selected: !_french,
                              style: AppTextStyles.baloo(
                                size: 15,
                                color: !_french
                                    ? AppColors.white
                                    : AppColors.navy,
                              ),
                              onTap: () => setState(() => _french = false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x14),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.textSize,
                          style: AppTextStyles.nunito(
                            size: 15,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Semantics(
                        label: l10n.textSize,
                        container: true,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < 3; i++) ...[
                              if (i > 0) const SizedBox(width: AppSpacing.x6),
                              _SizeButton(
                                fontSize: sizes[i],
                                selected: i == _textSize,
                                semanticLabel: sizeLabels[i],
                                onTap: () =>
                                    setState(() => _textSize = i),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // ----------------------------------------------------- notifications
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.notificationsUpper, style: AppTextStyles.sectionHeader()),
            const SizedBox(height: AppSpacing.x8),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x14,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadii.r22),
              ),
              child: Column(
                children: [
                  _NotifRow(
                    label: l10n.notifAbsences,
                    sub: l10n.notifAbsencesBody,
                    showDivider: false,
                    locked: true,
                  ),
                  _NotifRow(
                    label: l10n.notifNewLessons,
                    sub: l10n.notifNewLessonsBody,
                    showDivider: true,
                    value: _notifyLessons,
                    onChanged: (v) => setState(() => _notifyLessons = v),
                  ),
                  _NotifRow(
                    label: l10n.notifSchool,
                    sub: l10n.notifSchoolBody,
                    showDivider: true,
                    value: _notifySchool,
                    onChanged: (v) => setState(() => _notifySchool = v),
                  ),
                  _NotifRow(
                    label: l10n.notifQuietHours,
                    sub: l10n.notifQuietHoursBody,
                    showDivider: true,
                    value: _notifyQuiet,
                    onChanged: (v) => setState(() => _notifyQuiet = v),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ----------------------------------------------- kid mode & security
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.kidModeAndSecurity,
              style: AppTextStyles.sectionHeader(),
            ),
            const SizedBox(height: AppSpacing.x8),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x14,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadii.r22),
              ),
              child: Column(
                children: [
                  _LinkRow(
                    icon: AppIcons.sparkle,
                    iconColor: AppColors.success,
                    label: l10n.openKidMode,
                    showDivider: false,
                    showChevron: true,
                    onTap: () => context.go(Routes.studentHome),
                  ),
                  _LinkRow(
                    icon: AppIcons.lock,
                    label: l10n.parentCodeToExit,
                    trailing: '••••',
                    showDivider: true,
                  ),
                  _LinkRow(
                    icon: AppIcons.shield,
                    label: l10n.privacyAndData,
                    showDivider: true,
                    showChevron: true,
                  ),
                ],
              ),
            ),
          ],
        ),

        OutlineButton(
          label: l10n.signOut,
          icon: AppIcons.logout,
          borderColor: AppColors.coralBorderSoft,
          foregroundColor: AppColors.danger,
          onPressed: () => context.go(Routes.splash),
        ),
        Text(
          l10n.appVersion,
          textAlign: TextAlign.center,
          style: AppTextStyles.metaSmall,
        ),
      ],
    );
  }
}

class _ChildLink extends StatelessWidget {
  const _ChildLink({
    required this.initial,
    required this.background,
    required this.foreground,
    required this.name,
    required this.subtitle,
    required this.onTap,
  });

  final String initial;
  final Color background;
  final Color foreground;
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$name, $subtitle',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 1.5),
              ),
            ),
            child: Row(
              children: [
                InitialAvatar(
                  initials: initial,
                  background: background,
                  foreground: foreground,
                  size: 40,
                  fontSize: 18,
                ),
                const SizedBox(width: AppSpacing.x12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.nunito(
                          size: 15,
                          weight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: AppTextStyles.nunito(
                          size: 13,
                          weight: FontWeight.w600,
                          color: AppColors.inkSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                const AppIcon(
                  AppIcons.chevron,
                  size: 20,
                  color: AppColors.inkSubtle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddChildLink extends StatelessWidget {
  const _AddChildLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Semantics(
      button: true,
      label: l10n.addChildWithCode,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 1.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.dashedBorder,
                      width: 2,
                    ),
                  ),
                  child: const AppIcon(
                    AppIcons.plus,
                    size: 18,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: AppSpacing.x12),
                Text(
                  l10n.addChildWithCode,
                  style: AppTextStyles.nunito(
                    size: 15,
                    weight: FontWeight.w800,
                    color: AppColors.info,
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

class _LangButton extends StatelessWidget {
  const _LangButton({
    required this.label,
    required this.selected,
    required this.style,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final TextStyle style;
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
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : const Color(0x00000000),
              borderRadius: BorderRadius.circular(AppRadii.r14 - 1),
            ),
            child: Text(label, style: style),
          ),
        ),
      ),
    );
  }
}

class _SizeButton extends StatelessWidget {
  const _SizeButton({
    required this.fontSize,
    required this.selected,
    required this.semanticLabel,
    required this.onTap,
  });

  final double fontSize;
  final bool selected;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      button: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r14),
              border: Border.all(
                color: selected ? AppColors.navy : AppColors.cardBorder,
                width: selected ? 2.5 : 1.5,
              ),
            ),
            child: Text(
              'A',
              textScaler: TextScaler.noScaling,
              style: AppTextStyles.fredoka(size: fontSize),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  const _NotifRow({
    required this.label,
    required this.sub,
    required this.showDivider,
    this.locked = false,
    this.value = false,
    this.onChanged,
  });

  final String label;
  final String sub;
  final bool showDivider;
  final bool locked;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                top: BorderSide(color: AppColors.divider, width: 1.5),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.nunito(
                    size: 15,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(sub, style: AppTextStyles.metaSmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x12),
          if (locked)
            const AppSwitchLocked()
          else
            AppSwitch(
              value: value,
              semanticLabel: label,
              onChanged: onChanged ?? (_) {},
            ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.showDivider,
    this.iconColor = AppColors.navy,
    this.trailing,
    this.showChevron = false,
    this.onTap,
  });

  final String icon;
  final String label;
  final bool showDivider;
  final Color iconColor;
  final String? trailing;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Container(
      constraints: const BoxConstraints(minHeight: 60),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                top: BorderSide(color: AppColors.divider, width: 1.5),
              )
            : null,
      ),
      child: Row(
        children: [
          AppIcon(icon, size: 22, color: iconColor),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.nunito(size: 15, weight: FontWeight.w700),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: AppTextStyles.nunito(
                size: 14,
                weight: FontWeight.w800,
                color: AppColors.inkSubtle,
              ),
            ),
          if (showChevron)
            const AppIcon(
              AppIcons.chevron,
              size: 20,
              color: AppColors.inkSubtle,
            ),
        ],
      ),
    );

    if (onTap == null) return row;
    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: row,
        ),
      ),
    );
  }
}
