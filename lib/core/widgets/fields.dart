import 'package:flutter/material.dart'
    show Checkbox, MaterialTapTargetSize, VisualDensity;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';
import 'app_icon_paths.dart';

/// A labelled field group: label, control, then an optional helper or error.
class AppField extends StatelessWidget {
  const AppField({
    super.key,
    this.label,
    required this.child,
    this.helper,
    this.error,
    this.optionalSuffix,
  });

  final String? label;
  final Widget child;

  /// Grey helper text below the control.
  final Widget? helper;

  /// A validation message, shown in the coral alert style.
  final String? error;

  /// Rendered after the label in a lighter weight, e.g. "(facultatif)".
  final String? optionalSuffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text.rich(
            TextSpan(
              text: label,
              style: AppTextStyles.nunito(size: 14, weight: FontWeight.w800),
              children: optionalSuffix == null
                  ? null
                  : [
                      TextSpan(
                        text: ' $optionalSuffix',
                        style: AppTextStyles.nunito(
                          size: 14,
                          color: AppColors.inkSubtle,
                        ),
                      ),
                    ],
            ),
          ),
          const SizedBox(height: AppSpacing.x8),
        ],
        child,
        if (error != null) ...[
          const SizedBox(height: AppSpacing.x6),
          FieldError(message: error!),
        ] else if (helper != null) ...[
          const SizedBox(height: AppSpacing.x8),
          helper!,
        ],
      ],
    );
  }
}

/// An inline validation message, in the coral alert language of the mockups.
class FieldError extends StatelessWidget {
  const FieldError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x12,
          vertical: AppSpacing.x8,
        ),
        decoration: BoxDecoration(
          color: AppColors.coralTint,
          borderRadius: BorderRadius.circular(AppRadii.r14),
          border: Border.all(color: AppColors.coralBorder, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.only(top: 1),
              child: AppIcon(
                AppIcons.alert,
                size: 16,
                color: AppColors.danger,
              ),
            ),
            const SizedBox(width: AppSpacing.x8),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.nunito(
                  size: 13,
                  weight: FontWeight.w700,
                  height: 1.4,
                  color: AppColors.danger,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grey helper text with a leading info glyph.
class FieldHint extends StatelessWidget {
  const FieldHint({super.key, required this.text, this.icon = AppIcons.info});

  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 1),
          child: AppIcon(icon, size: 16, color: AppColors.info),
        ),
        const SizedBox(width: AppSpacing.x6),
        Expanded(child: Text(text, style: AppTextStyles.helper)),
      ],
    );
  }
}

/// The standard text field: `h 56`, `r 16`, a `1.5px` border on white.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.height = 56,
    this.fontSize = 17,
    this.fontWeight = FontWeight.w800,
    this.letterSpacing,
    this.keyboardType,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.hasError = false,
    this.prefix,
    this.suffix,
    this.semanticLabel,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController? controller;
  final String? hintText;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final double? letterSpacing;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  /// Switches the border to the danger colour.
  final bool hasError;

  /// Leading widget inside the field, e.g. the `+216` prefix.
  final Widget? prefix;

  /// Trailing widget inside the field, e.g. the password eye toggle.
  final Widget? suffix;

  /// Needed when the field has no visible label.
  final String? semanticLabel;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final field = EditableTextField(
      controller: controller,
      hintText: hintText,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      semanticLabel: semanticLabel,
      textAlign: textAlign,
    );

    return Container(
      // A minimum rather than a fixed height, so a large system text scale
      // grows the field instead of clipping it.
      constraints: BoxConstraints(minHeight: height),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadii.field),
        border: Border.all(
          color: hasError ? AppColors.danger : AppColors.fieldBorder,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          ?prefix,
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: prefix == null ? AppSpacing.x16 : 0,
                end: suffix == null ? AppSpacing.x16 : 0,
              ),
              child: field,
            ),
          ),
          ?suffix,
        ],
      ),
    );
  }
}

/// The bare text input, without the field chrome.
class EditableTextField extends StatelessWidget {
  const EditableTextField({
    super.key,
    this.controller,
    this.hintText,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.letterSpacing,
    this.keyboardType,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.semanticLabel,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController? controller;
  final String? hintText;
  final double fontSize;
  final FontWeight fontWeight;
  final double? letterSpacing;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? semanticLabel;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.nunito(
      size: fontSize,
      weight: fontWeight,
      letterSpacing: letterSpacing,
    );

    Widget input = _HintedEditable(
      controller: controller,
      hintText: hintText,
      style: style,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textAlign: textAlign,
    );

    if (semanticLabel case final label?) {
      input = Semantics(label: label, textField: true, child: input);
    }
    return input;
  }
}

/// An [EditableText] with a placeholder, since [EditableText] has none.
class _HintedEditable extends StatefulWidget {
  const _HintedEditable({
    this.controller,
    this.hintText,
    required this.style,
    this.keyboardType,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController? controller;
  final String? hintText;
  final TextStyle style;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextAlign textAlign;

  @override
  State<_HintedEditable> createState() => _HintedEditableState();
}

class _HintedEditableState extends State<_HintedEditable> {
  late TextEditingController _controller;
  late FocusNode _focus;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _ownsController = widget.controller == null;
    _focus = FocusNode();
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(_HintedEditable old) {
    super.didUpdateWidget(old);
    if (widget.controller != old.controller && widget.controller != null) {
      _controller.removeListener(_onTextChanged);
      if (_ownsController) _controller.dispose();
      _controller = widget.controller!;
      _ownsController = false;
      _controller.addListener(_onTextChanged);
    }
  }

  void _onTextChanged() {
    // Only the placeholder's visibility depends on the text here.
    if (widget.hintText != null) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editable = EditableText(
      controller: _controller,
      focusNode: _focus,
      style: widget.style,
      cursorColor: AppColors.navy,
      backgroundCursorColor: AppColors.cardShadow,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.obscureText,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textAlign: widget.textAlign,
      selectionColor: AppColors.infoTint,
      maxLines: 1,
    );

    if (widget.hintText == null || _controller.text.isNotEmpty) {
      return editable;
    }

    return Stack(
      children: [
        IgnorePointer(
          child: Text(
            widget.hintText!,
            style: widget.style.copyWith(color: AppColors.inkSubtle),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: widget.textAlign,
          ),
        ),
        editable,
      ],
    );
  }
}

/// The fixed `+216` dialling prefix of the login and sign-up phone fields.
class PhonePrefix extends StatelessWidget {
  const PhonePrefix({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(6, 6, AppSpacing.x10, 6),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppRadii.r12),
        ),
        child: Text(
          '+216',
          style: AppTextStyles.nunito(size: 17, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

/// A multi-line text area: `r 16`, a `1.5px` border, `16px/1.5` text.
class AppTextArea extends StatefulWidget {
  const AppTextArea({
    super.key,
    this.controller,
    this.initialText,
    this.rows = 3,
    this.onChanged,
    this.semanticLabel,
  });

  final TextEditingController? controller;
  final String? initialText;
  final int rows;
  final ValueChanged<String>? onChanged;
  final String? semanticLabel;

  @override
  State<AppTextArea> createState() => _AppTextAreaState();
}

class _AppTextAreaState extends State<AppTextArea> {
  late TextEditingController _controller;
  late FocusNode _focus;
  bool _owns = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialText);
    _owns = widget.controller == null;
    _focus = FocusNode();
  }

  @override
  void dispose() {
    if (_owns) _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.nunito(size: 16, height: 1.5);
    Widget field = EditableText(
      controller: _controller,
      focusNode: _focus,
      style: style,
      cursorColor: AppColors.navy,
      backgroundCursorColor: AppColors.cardShadow,
      maxLines: widget.rows,
      minLines: widget.rows,
      keyboardType: TextInputType.multiline,
      onChanged: widget.onChanged,
      selectionColor: AppColors.infoTint,
    );
    if (widget.semanticLabel case final label?) {
      field = Semantics(label: label, textField: true, child: field);
    }

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadii.field),
        border: Border.all(color: AppColors.fieldBorder, width: 1.5),
      ),
      child: field,
    );
  }
}

/// A square checkbox in the navy accent of the mockups.
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Checkbox(
        value: value,
        onChanged: (v) => onChanged(v ?? false),
        activeColor: AppColors.navy,
        checkColor: AppColors.white,
        side: const BorderSide(color: AppColors.fieldBorder, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        semanticLabel: semanticLabel,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
