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
import '../../core/widgets/role_bottom_nav.dart';
import '../../core/widgets/zitoun.dart';
import '../../l10n/app_localizations.dart';

/// How the role picker behaves.
enum RoleScreenMode {
  /// Reached from settings or the kid-mode lock: "Continuer" goes straight to
  /// the chosen role's home, as in the mockups.
  standalone,

  /// Step 1 of sign-up: "Continuer" goes to the account details step, and a
  /// step indicator is shown.
  signup,
}

/// Board 3 · Choix du rôle.
class RoleScreen extends ConsumerStatefulWidget {
  const RoleScreen({super.key, this.mode = RoleScreenMode.standalone});

  final RoleScreenMode mode;

  @override
  ConsumerState<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends ConsumerState<RoleScreen> {
  AppRole _role = AppRole.parent;
  final _code = TextEditingController();
  String? _codeError;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _continue() {
    final l10n = AppL10n.of(context);
    if (widget.mode == RoleScreenMode.signup && _code.text.trim().isEmpty) {
      setState(() => _codeError = l10n.errorCode);
      return;
    }
    setState(() => _codeError = null);
    ref.read(selectedRoleProvider.notifier).set(_role);

    if (widget.mode == RoleScreenMode.signup) {
      context.push(Routes.signupDetails);
    } else {
      context.go(homeRouteFor(_role));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final isSignup = widget.mode == RoleScreenMode.signup;

    final roles = <({
      AppRole role,
      String title,
      String desc,
      Color tint,
      Color ink,
      String? icon,
      bool isKid,
      String hint,
    })>[
      (
        role: AppRole.parent,
        title: l10n.roleParent,
        desc: l10n.roleParentDesc,
        tint: AppColors.warnTint,
        ink: AppColors.warn,
        icon: AppIcons.users,
        isKid: false,
        hint: l10n.roleParentHint,
      ),
      (
        role: AppRole.eleve,
        title: l10n.roleStudent,
        desc: l10n.roleStudentDesc,
        tint: AppColors.successTint,
        ink: AppColors.success,
        icon: null,
        isKid: true,
        hint: l10n.roleStudentHint,
      ),
      (
        role: AppRole.enseignant,
        title: l10n.roleTeacher,
        desc: l10n.roleTeacherDesc,
        tint: AppColors.infoTint,
        ink: AppColors.info,
        icon: AppIcons.school,
        isKid: false,
        hint: l10n.roleTeacherHint,
      ),
    ];

    final selected = roles.firstWhere((r) => r.role == _role);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenOnboarding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconSquareButton(
                  icon: AppIcons.back,
                  semanticLabel: l10n.back,
                  boxShadow: AppShadows.card,
                  onPressed: () => context.canPop()
                      ? context.pop()
                      : context.go(Routes.welcome),
                ),
              ),
              const SizedBox(height: AppSpacing.x18),

              if (isSignup) ...[
                _StepIndicator(current: 1, total: 2),
                const SizedBox(height: AppSpacing.x18),
              ],

              Text(l10n.roleTitle, style: AppTextStyles.h1Onboarding),
              const SizedBox(height: AppSpacing.x6),
              Text(
                l10n.roleSubtitle,
                style: AppTextStyles.nunito(
                  size: 15,
                  weight: FontWeight.w400,
                  height: 1.5,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.x18),

              Semantics(
                label: l10n.roleGroup,
                container: true,
                child: Column(
                  children: [
                    for (var i = 0; i < roles.length; i++) ...[
                      if (i > 0) const SizedBox(height: AppSpacing.x10),
                      _RoleButton(
                        data: roles[i],
                        selected: roles[i].role == _role,
                        onTap: () => setState(() => _role = roles[i].role),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x18),

              AppField(
                label: l10n.invitationCodeLabel,
                error: _codeError,
                helper: FieldHint(text: selected.hint),
                child: AppTextField(
                  controller: _code,
                  hintText: l10n.invitationCodeHint,
                  letterSpacing: 17 * 0.08,
                  textCapitalization: TextCapitalization.characters,
                  hasError: _codeError != null,
                  onChanged: (_) {
                    if (_codeError != null) setState(() => _codeError = null);
                  },
                ),
              ),

              const Spacer(),
              const SizedBox(height: AppSpacing.x18),
              PrimaryButton(label: l10n.continueLabel, onPressed: _continue),
            ],
          ),
        ),
      ),
    );
  }
}

/// The home route of each role, used after a mock sign-in.
String homeRouteFor(AppRole role) => switch (role) {
  AppRole.parent => Routes.dashboard,
  AppRole.eleve => Routes.studentHome,
  AppRole.enseignant => Routes.teacherHome,
};

class _RoleButton extends StatelessWidget {
  const _RoleButton({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final ({
    AppRole role,
    String title,
    String desc,
    Color tint,
    Color ink,
    String? icon,
    bool isKid,
    String hint,
  })
  data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      button: true,
      label: '${data.title}. ${data.desc}',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 84),
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 14, 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r24),
              border: Border.all(
                color: selected ? AppColors.navy : AppColors.white,
                width: 2.5,
              ),
              boxShadow: selected ? AppShadows.selected : AppShadows.card,
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: data.tint,
                    borderRadius: BorderRadius.circular(AppRadii.r20),
                  ),
                  child: data.isKid
                      ? const Zitoun(
                          size: 54,
                          mood: ZitounMood.salut,
                          excludeSemantics: true,
                        )
                      : AppIcon(data.icon!, size: 28, color: data.ink),
                ),
                const SizedBox(width: AppSpacing.x14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.title, style: AppTextStyles.fredoka(size: 19)),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        data.desc,
                        style: AppTextStyles.nunito(
                          size: 13,
                          height: 1.4,
                          color: AppColors.inkSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x14),
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.yellow : AppColors.white,
                    shape: BoxShape.circle,
                    border: selected
                        ? null
                        : Border.all(color: AppColors.fieldBorder, width: 2),
                  ),
                  child: selected
                      ? const AppIcon(
                          AppIcons.check,
                          size: 16,
                          strokeWidth: 3,
                          color: AppColors.navy,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The two-step progress indicator of the sign-up flow.
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Semantics(
      label: l10n.signupStepLabel(current, total),
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 1; i <= total; i++) ...[
                if (i > 1) const SizedBox(width: AppSpacing.x8),
                Container(
                  width: i == current ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i <= current
                        ? AppColors.navy
                        : AppColors.infoTintAlt,
                    borderRadius: BorderRadius.circular(AppRadii.xs),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x6),
          ExcludeSemantics(
            child: Text(
              l10n.signupStepLabel(current, total),
              style: AppTextStyles.meta,
            ),
          ),
        ],
      ),
    );
  }
}

/// Exported so the sign-up details screen can show the same indicator.
class SignupStepIndicator extends StatelessWidget {
  const SignupStepIndicator({
    super.key,
    required this.current,
    this.total = 2,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) =>
      _StepIndicator(current: current, total: total);
}
