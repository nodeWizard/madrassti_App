import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// The frame every mockup board shares: the `#EEF5FF` background, a safe area,
/// and a scrollable body.
///
/// The mockups are fixed 390 × 844 boards whose `<main>` scrolls; this is the
/// same arrangement, with the bottom navigation supplied by the shell.
class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.children,
    this.padding = AppSpacing.screen,
    this.gap = AppSpacing.x18,
    this.background = AppColors.background,
    this.header,
    this.footer,
    this.scrollable = true,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.controller,
  });

  /// Body sections, separated by [gap].
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double gap;
  final Color background;

  /// A fixed element above the scrollable body (chat header, form header).
  final Widget? header;

  /// A fixed element below the scrollable body (sticky action bar).
  final Widget? footer;
  final bool scrollable;
  final CrossAxisAlignment crossAxisAlignment;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final column = Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );

    final body = Padding(padding: padding, child: column);

    return Container(
      color: background,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ?header,
            Expanded(
              child: scrollable
                  ? SingleChildScrollView(
                      controller: controller,
                      child: body,
                    )
                  : body,
            ),
            ?footer,
          ],
        ),
      ),
    );
  }
}

/// A section heading in the Fredoka display face.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing, this.style});

  final String text;
  final Widget? trailing;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final title = Text(text, style: style ?? Theme.of(context).textTheme.titleMedium);
    if (trailing == null) return title;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [title, trailing!],
    );
  }
}
