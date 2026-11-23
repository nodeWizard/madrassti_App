import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/fields.dart';
import '../../core/widgets/role_bottom_nav.dart';
import '../../core/widgets/zitoun.dart';
import '../../data/models/models.dart';
import '../../l10n/app_localizations.dart';
import '../onboarding/role_screen.dart';

/// Login — a new screen, built from the mockups' own design language.
///
/// Zitoun waves above the title, the phone field carries a fixed `+216`
/// prefix, and the primary button is the yellow one with its 3px darker
/// bottom shadow.
///
/// Mock auth: the phone and password are checked against the dummy accounts
/// in `assets/mock_data/users.json` (via [AuthRepository]) — no backend, but
/// a real check rather than accepting anything. The matched account's role
/// decides which home screen opens.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  String? _phoneError;
  String? _passwordError;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppL10n.of(context);
    final digits = _phone.text.replaceAll(RegExp(r'\D'), '');
    setState(() {
      _phoneError = digits.length == 8 ? null : l10n.errorPhone;
      _passwordError =
          _password.text.isEmpty ? l10n.errorPasswordEmpty : null;
    });
    if (_phoneError != null || _passwordError != null) return;

    final account = ref
        .read(authRepositoryProvider)
        .signIn(phone: digits, password: _password.text);
    if (account == null) {
      setState(() => _passwordError = l10n.errorInvalidCredentials);
      return;
    }

    ref.read(currentUserProvider.notifier).set(account);
    final role = AppRole.values.byName(account.role);
    ref.read(selectedRoleProvider.notifier).set(role);
    context.go(homeRouteFor(role));
  }

  void _fillDemoAccount(UserAccount account) {
    setState(() {
      _phone.text = account.phone;
      _password.text = account.password;
      _phoneError = null;
      _passwordError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenOnboarding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.x8),
              Center(
                child: Container(
                  width: 196,
                  height: 196,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.infoTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Zitoun(
                    size: 160,
                    mood: ZitounMood.salut,
                    excludeSemantics: true,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x24),

              Text(
                l10n.loginTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1Onboarding,
              ),
              const SizedBox(height: AppSpacing.x24),

              AppField(
                label: l10n.phoneLabel,
                error: _phoneError,
                child: AppTextField(
                  controller: _phone,
                  hintText: l10n.phoneHint,
                  keyboardType: TextInputType.phone,
                  hasError: _phoneError != null,
                  semanticLabel: l10n.phoneLabel,
                  prefix: const PhonePrefix(),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                  onChanged: (_) {
                    if (_phoneError != null) setState(() => _phoneError = null);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.x16),

              AppField(
                label: l10n.passwordLabel,
                error: _passwordError,
                child: AppTextField(
                  controller: _password,
                  hintText: l10n.passwordHint,
                  obscureText: _obscure,
                  fontSize: 17,
                  hasError: _passwordError != null,
                  semanticLabel: l10n.passwordLabel,
                  suffix: IconSquareButton(
                    icon: _obscure ? AppIcons.eye : AppIcons.eyeOff,
                    semanticLabel:
                        _obscure ? l10n.showPassword : l10n.hidePassword,
                    background: const Color(0x00000000),
                    foreground: AppColors.inkSubtle,
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  onChanged: (_) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.x8),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: AppTextLink(
                  label: l10n.forgotPassword,
                  fontSize: 15,
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: AppSpacing.x16),

              PrimaryButton(label: l10n.signIn, onPressed: _submit),
              const SizedBox(height: AppSpacing.x20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.noAccountYet,
                    style: AppTextStyles.nunito(
                      size: 15,
                      weight: FontWeight.w600,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                  AppTextLink(
                    label: l10n.createAccount,
                    fontSize: 15,
                    minHeight: 48,
                    onPressed: () => context.push(Routes.signupRole),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.x24),
              _DemoAccounts(onPick: _fillDemoAccount),
            ],
          ),
        ),
      ),
    );
  }
}

/// A tap-to-fill list of the dummy accounts in `assets/mock_data/users.json`,
/// so the login screen is actually usable without reading the JSON by hand.
class _DemoAccounts extends ConsumerWidget {
  const _DemoAccounts({required this.onPick});

  final ValueChanged<UserAccount> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final users = ref.watch(authRepositoryProvider).users;

    String roleLabel(String role) => switch (AppRole.values.byName(role)) {
      AppRole.parent => l10n.roleParent,
      AppRole.eleve => l10n.roleStudent,
      AppRole.enseignant => l10n.roleTeacher,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.x14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadii.field),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.demoAccountsTitle,
            style: AppTextStyles.nunito(size: 13, weight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.x6),
          for (final u in users)
            Semantics(
              button: true,
              label: l10n.demoAccountLine(
                roleLabel(u.role),
                u.phone,
                u.password,
              ),
              child: ExcludeSemantics(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onPick(u),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: AppSpacing.x4,
                    ),
                    child: Text(
                      l10n.demoAccountLine(
                        roleLabel(u.role),
                        u.phone,
                        u.password,
                      ),
                      style: AppTextStyles.nunito(
                        size: 13,
                        weight: FontWeight.w700,
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
