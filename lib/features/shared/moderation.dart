import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/medallion.dart';
import '../../l10n/app_localizations.dart';

/// Mocked AI moderation.
///
/// No real model runs: the sample toxic message from the mockups is matched
/// and its canned rewrite returned. Everything else passes through
/// (`docs/SPEC.md` §5.1 A1).
abstract final class Moderation {
  /// The draft the mockup's moderation board opens with.
  static const sampleToxicMessage =
      'C’est n’importe quoi, vous êtes incompétente ! '
      'Mon fils n’a toujours pas ses devoirs.';

  /// The rewrite the mockup proposes.
  static const suggestion =
      'Bonjour Madame, je m’inquiète : Yassine n’a pas encore reçu ses '
      'devoirs. Pourriez-vous me dire quand ils seront disponibles ? Merci.';

  /// The words the sheet highlights in the original.
  static const flaggedWords = ['n’importe quoi', 'incompétente'];

  /// Normalises punctuation so a straight apostrophe still matches.
  static String _normalise(String s) =>
      s.toLowerCase().replaceAll("'", '’').trim();

  /// Whether [text] should be held back for review.
  static bool flags(String text) {
    final t = _normalise(text);
    return flaggedWords.every((w) => t.contains(_normalise(w)));
  }
}

/// The moderation bottom sheet — board 18.
///
/// Returns [ModerationChoice] when dismissed.
enum ModerationChoice {
  /// "Envoyer cette version" — send the suggested rewrite.
  useSuggestion,

  /// "Je reformule moi-même" — put the original back in the input.
  rewrite,
}

Future<ModerationChoice?> showModerationSheet(
  BuildContext context, {
  required String original,
}) {
  return showModalBottomSheet<ModerationChoice>(
    context: context,
    isScrollControlled: true,
    barrierColor: AppColors.scrim,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: AppRadii.modSheetTop,
    ),
    builder: (context) => ModerationSheet(original: original),
  );
}

/// The sheet body. Exposed so it can be golden-tested on its own.
class ModerationSheet extends StatelessWidget {
  const ModerationSheet({super.key, required this.original});

  final String original;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return Semantics(
      label: l10n.moderationTitle,
      container: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(18, 12, 18, 24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadii.modSheetTop,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- grab handle
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.cardShadow,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x14),

            // ---- title
            Row(
              children: [
                const Medallion(
                  icon: AppIcons.sparkle,
                  background: AppColors.warnTint,
                  foreground: AppColors.warn,
                  size: 52,
                  radius: AppRadii.button,
                  iconSize: 26,
                ),
                const SizedBox(width: AppSpacing.x12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.moderationTitle, style: AppTextStyles.h5),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        l10n.moderationSubtitle,
                        style: AppTextStyles.meta,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x14),

            // ---- the original, with the hurtful words highlighted
            Text(
              l10n.yourMessageUpper,
              style: AppTextStyles.kicker12(),
            ),
            const SizedBox(height: AppSpacing.x6),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x14,
                vertical: AppSpacing.x12,
              ),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(AppRadii.field),
              ),
              child: Text.rich(
                _highlight(original),
                style: AppTextStyles.nunito(
                  size: 15,
                  weight: FontWeight.w400,
                  height: 1.55,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x6),
            Text(l10n.moderationExplain, style: AppTextStyles.helper),
            const SizedBox(height: AppSpacing.x14),

            // ---- the suggestion
            Text(
              l10n.suggestionUpper,
              style: AppTextStyles.kicker12(color: AppColors.success),
            ),
            const SizedBox(height: AppSpacing.x6),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x14,
                vertical: AppSpacing.x12,
              ),
              decoration: BoxDecoration(
                color: AppColors.successTintAlt,
                borderRadius: BorderRadius.circular(AppRadii.field),
                border: Border.all(
                  color: AppColors.successBorder,
                  width: 1.5,
                ),
              ),
              child: Text(
                Moderation.suggestion,
                style: AppTextStyles.nunito(
                  size: 15,
                  weight: FontWeight.w400,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x14),

            PrimaryButton(
              label: l10n.sendThisVersion,
              textStyle: AppTextStyles.nunito(
                size: 16,
                weight: FontWeight.w800,
              ),
              onPressed: () =>
                  Navigator.of(context).pop(ModerationChoice.useSuggestion),
            ),
            const SizedBox(height: AppSpacing.x14),
            OutlineButton(
              label: l10n.rewriteMyself,
              height: 52,
              radius: AppRadii.button,
              fontSize: 16,
              onPressed: () =>
                  Navigator.of(context).pop(ModerationChoice.rewrite),
            ),
          ],
        ),
      ),
    );
  }

  /// Wraps each flagged word in the coral `<mark>` style of the mockup.
  TextSpan _highlight(String text) {
    final spans = <TextSpan>[];
    var rest = text;

    while (rest.isNotEmpty) {
      // Find the earliest flagged word still ahead of us.
      var bestIndex = -1;
      var bestWord = '';
      for (final w in Moderation.flaggedWords) {
        final i = rest.toLowerCase().indexOf(w.toLowerCase());
        if (i >= 0 && (bestIndex < 0 || i < bestIndex)) {
          bestIndex = i;
          bestWord = w;
        }
      }
      if (bestIndex < 0) {
        spans.add(TextSpan(text: rest));
        break;
      }
      if (bestIndex > 0) {
        spans.add(TextSpan(text: rest.substring(0, bestIndex)));
      }
      spans.add(
        TextSpan(
          text: rest.substring(bestIndex, bestIndex + bestWord.length),
          style: AppTextStyles.nunito(
            size: 15,
            weight: FontWeight.w800,
            height: 1.55,
            color: AppColors.danger,
          ).copyWith(backgroundColor: AppColors.arabicTint),
        ),
      );
      rest = rest.substring(bestIndex + bestWord.length);
    }

    return TextSpan(children: spans);
  }
}
