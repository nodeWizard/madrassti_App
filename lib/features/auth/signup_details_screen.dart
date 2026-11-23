import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/fields.dart';
import '../../l10n/app_localizations.dart';
import '../onboarding/role_screen.dart';

/// Sign-up, step 2 — account details.
///
/// Step 1 is the existing role screen, reused as-is. Each field validates
/// inline, in the coral alert style of the mockups.
class SignupDetailsScreen extends ConsumerStatefulWidget {
  const SignupDetailsScreen({super.key});

  @override
  ConsumerState<SignupDetailsScreen> createState() =>
      _SignupDetailsScreenState();
}

class _SignupDetailsScreenState extends ConsumerState<SignupDetailsScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;

  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmError;
  String? _termsError;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppL10n.of(context);
    final digits = _phone.text.replaceAll(RegExp(r'\D'), '');

    setState(() {
      _firstNameError =
          _firstName.text.trim().length >= 2 ? null : l10n.errorFirstName;
      _lastNameError =
          _lastName.text.trim().length >= 2 ? null : l10n.errorLastName;
      _phoneError = digits.length == 8 ? null : l10n.errorPhone;
      _passwordError =
          _password.text.length >= 6 ? null : l10n.errorPasswordShort;
      _confirmError = _confirm.text == _password.text && _confirm.text.isNotEmpty
          ? null
          : l10n.errorPasswordMismatch;
      _termsError = _acceptedTerms ? null : l10n.errorTerms;
    });

    final valid = [
      _firstNameError,
      _lastNameError,
      _phoneError,
      _passwordError,
      _confirmError,
      _termsError,
    ].every((e) => e == null);
    if (!valid) return;

    context.go(homeRouteFor(ref.read(selectedRoleProvider)));
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
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconSquareButton(
                  icon: AppIcons.back,
                  semanticLabel: l10n.back,
                  boxShadow: AppShadows.card,
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(height: AppSpacing.x18),

              const SignupStepIndicator(current: 2),
              const SizedBox(height: AppSpacing.x18),

              Text(l10n.signupDetailsTitle, style: AppTextStyles.h1Onboarding),
              const SizedBox(height: AppSpacing.x6),
              Text(
                l10n.signupDetailsSubtitle,
                style: AppTextStyles.nunito(
                  size: 15,
                  weight: FontWeight.w400,
                  height: 1.5,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.x18),

              AppField(
                label: l10n.firstNameLabel,
                error: _firstNameError,
                child: AppTextField(
                  controller: _firstName,
                  fontSize: 17,
                  textCapitalization: TextCapitalization.words,
                  hasError: _firstNameError != null,
                  semanticLabel: l10n.firstNameLabel,
                  onChanged: (_) {
                    if (_firstNameError != null) {
                      setState(() => _firstNameError = null);
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.x16),

              AppField(
                label: l10n.lastNameLabel,
                error: _lastNameError,
                child: AppTextField(
                  controller: _lastName,
                  fontSize: 17,
                  textCapitalization: TextCapitalization.words,
                  hasError: _lastNameError != null,
                  semanticLabel: l10n.lastNameLabel,
                  onChanged: (_) {
                    if (_lastNameError != null) {
                      setState(() => _lastNameError = null);
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.x16),

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
                  obscureText: _obscurePassword,
                  fontSize: 17,
                  hasError: _passwordError != null,
                  semanticLabel: l10n.passwordLabel,
                  suffix: IconSquareButton(
                    icon: _obscurePassword ? AppIcons.eye : AppIcons.eyeOff,
                    semanticLabel: _obscurePassword
                        ? l10n.showPassword
                        : l10n.hidePassword,
                    background: const Color(0x00000000),
                    foreground: AppColors.inkSubtle,
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  onChanged: (_) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.x16),

              AppField(
                label: l10n.passwordConfirmLabel,
                error: _confirmError,
                child: AppTextField(
                  controller: _confirm,
                  obscureText: _obscureConfirm,
                  fontSize: 17,
                  hasError: _confirmError != null,
                  semanticLabel: l10n.passwordConfirmLabel,
                  suffix: IconSquareButton(
                    icon: _obscureConfirm ? AppIcons.eye : AppIcons.eyeOff,
                    semanticLabel: _obscureConfirm
                        ? l10n.showPassword
                        : l10n.hidePassword,
                    background: const Color(0x00000000),
                    foreground: AppColors.inkSubtle,
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  onChanged: (_) {
                    if (_confirmError != null) {
                      setState(() => _confirmError = null);
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.x18),

              // ---- terms checkbox
              Semantics(
                checked: _acceptedTerms,
                label: '${l10n.acceptTerms}${l10n.termsOfUse}',
                child: ExcludeSemantics(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() {
                      _acceptedTerms = !_acceptedTerms;
                      if (_acceptedTerms) _termsError = null;
                    }),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppCheckbox(
                            value: _acceptedTerms,
                            onChanged: (v) => setState(() {
                              _acceptedTerms = v;
                              if (v) _termsError = null;
                            }),
                          ),
                          const SizedBox(width: AppSpacing.x12),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: l10n.acceptTerms,
                                style: AppTextStyles.nunito(size: 14),
                                children: [
                                  TextSpan(
                                    text: l10n.termsOfUse,
                                    style: AppTextStyles.nunito(
                                      size: 14,
                                      weight: FontWeight.w800,
                                      color: AppColors.info,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_termsError != null) ...[
                const SizedBox(height: AppSpacing.x6),
                FieldError(message: _termsError!),
              ],

              const SizedBox(height: AppSpacing.x24),
              PrimaryButton(label: l10n.createMyAccount, onPressed: _submit),
              const SizedBox(height: AppSpacing.x8),
            ],
          ),
        ),
      ),
    );
  }
}
