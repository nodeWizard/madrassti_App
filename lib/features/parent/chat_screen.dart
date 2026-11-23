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
import '../../core/widgets/zitoun.dart';
import '../../data/models/models.dart';
import '../../l10n/app_localizations.dart';
import '../shared/moderation.dart';

/// Board 8b · Conversation, and the entry point to board 18 · Modération IA.
///
/// Sending works. If the draft matches the mockups' sample toxic message, the
/// moderation sheet opens instead of sending (`docs/SPEC.md` §5.1 A1).
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _draft = TextEditingController();
  final _scroll = ScrollController();
  final _sent = <ChatMessage>[];

  /// Set after "Je reformule moi-même": highlights the input and shows a hint.
  bool _rewriting = false;

  /// Set after the suggestion is sent: shows Zitoun's thank-you pill.
  bool _moderationAccepted = false;

  @override
  void dispose() {
    _draft.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _push(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _sent.add(ChatMessage(text: trimmed, mine: true, time: ''));
      _draft.clear();
      _rewriting = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    if (Moderation.flags(trimmed)) {
      final choice = await showModerationSheet(context, original: trimmed);
      if (!mounted) return;
      switch (choice) {
        case ModerationChoice.useSuggestion:
          setState(() => _moderationAccepted = true);
          _push(Moderation.suggestion);
        case ModerationChoice.rewrite:
          // The original comes back in the input, ready to be reworded.
          setState(() {
            _draft.text = trimmed;
            _rewriting = true;
          });
        case null:
          break;
      }
      return;
    }

    _push(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(parentRepositoryProvider);
    final thread = repo.chatThread;

    return Scaffold(
      backgroundColor: AppColors.background,
      // The send bar sits above the keyboard.
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ------------------------------------------------------ header
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x16,
                vertical: AppSpacing.x14,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: AppRadii.headerBottom,
                boxShadow: AppShadows.header,
              ),
              child: Row(
                children: [
                  IconSquareButton(
                    icon: AppIcons.back,
                    semanticLabel: l10n.backToMessages,
                    background: AppColors.background,
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go(Routes.messages),
                  ),
                  const SizedBox(width: AppSpacing.x12),
                  const InitialAvatar(
                    initials: 'BS',
                    background: AppColors.infoTint,
                    foreground: AppColors.info,
                    size: 44,
                    radius: AppRadii.r15,
                    fontSize: 17,
                  ),
                  const SizedBox(width: AppSpacing.x12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mme Ben Salah',
                          style: AppTextStyles.nunito(
                            size: 16,
                            weight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Enseignante · 4e B · à propos de Yassine',
                          style: AppTextStyles.metaSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // -------------------------------------------------------- thread
            Expanded(
              child: SingleChildScrollView(
                controller: _scroll,
                padding: const EdgeInsets.all(AppSpacing.x16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        height: 26,
                        alignment: Alignment.center,
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: AppSpacing.x12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.infoTint,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Text(
                          l10n.todayChip,
                          style: AppTextStyles.nunito(
                            size: 12,
                            weight: FontWeight.w800,
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ),
                    for (final m in thread) ...[
                      const SizedBox(height: AppSpacing.x10),
                      _Bubble(message: m),
                    ],
                    for (final m in _sent) ...[
                      const SizedBox(height: AppSpacing.x10),
                      _Bubble(message: m, justSent: true),
                    ],
                    if (_moderationAccepted) ...[
                      const SizedBox(height: AppSpacing.x6),
                      Center(
                        child: Container(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            8,
                            8,
                            14,
                            8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successTint,
                            borderRadius:
                                BorderRadius.circular(AppRadii.button),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Zitoun(
                                size: 40,
                                mood: ZitounMood.bravo,
                                excludeSemantics: true,
                              ),
                              const SizedBox(width: AppSpacing.x8),
                              Text(
                                l10n.moderationThanks,
                                style: AppTextStyles.nunito(
                                  size: 14,
                                  weight: FontWeight.w800,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ----------------------------------------------------- send bar
            Container(
              padding: AppSpacing.sendBar,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: AppRadii.navTop,
                boxShadow: AppShadows.sendBar,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_rewriting) ...[
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 4,
                        bottom: AppSpacing.x8,
                      ),
                      child: Row(
                        children: [
                          const AppIcon(
                            AppIcons.pencil,
                            size: 16,
                            color: AppColors.warn,
                          ),
                          const SizedBox(width: AppSpacing.x6),
                          Flexible(
                            child: Text(
                              l10n.rewriteThenSend,
                              style: AppTextStyles.nunito(
                                size: 13,
                                weight: FontWeight.w800,
                                color: AppColors.warn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Quick replies send straight away.
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: repo.quickReplies.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(width: AppSpacing.x8),
                        itemBuilder: (context, i) => OutlineButton(
                          label: repo.quickReplies[i],
                          height: 40,
                          radius: AppRadii.r20,
                          expand: false,
                          borderColor: AppColors.cardBorder,
                          onPressed: () => _send(repo.quickReplies[i]),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x10),
                  ],
                  Row(
                    children: [
                      IconSquareButton(
                        icon: AppIcons.clip,
                        semanticLabel: l10n.attachFile,
                        background: AppColors.background,
                        onPressed: () {},
                      ),
                      const SizedBox(width: AppSpacing.x8),
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 48),
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: AppSpacing.x14,
                          ),
                          alignment: AlignmentDirectional.centerStart,
                          decoration: BoxDecoration(
                            color: AppColors.fieldFill,
                            borderRadius:
                                BorderRadius.circular(AppRadii.field),
                            border: Border.all(
                              color: _rewriting
                                  ? AppColors.yellow
                                  : AppColors.cardBorder,
                              width: _rewriting ? 2 : 1.5,
                            ),
                          ),
                          child: EditableTextField(
                            controller: _draft,
                            hintText: l10n.writeMessage,
                            semanticLabel: l10n.yourMessage,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            onSubmitted: _send,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x8),
                      IconSquareButton(
                        icon: AppIcons.send,
                        semanticLabel: l10n.send,
                        background: AppColors.yellow,
                        boxShadow: AppShadows.yellowButton,
                        onPressed: () => _send(_draft.text),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, this.justSent = false});

  final ChatMessage message;
  final bool justSent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final mine = message.mine;

    return Align(
      alignment:
          mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Column(
          crossAxisAlignment:
              mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x14,
                vertical: AppSpacing.x12,
              ),
              decoration: BoxDecoration(
                color: mine ? AppColors.navy : AppColors.white,
                borderRadius: mine ? AppRadii.bubbleOut : AppRadii.bubbleIn,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: AppTextStyles.nunito(
                      size: 15,
                      weight: FontWeight.w400,
                      height: 1.45,
                      color: mine ? AppColors.white : AppColors.ink,
                    ),
                  ),
                  if (message.attachment case final a?) ...[
                    const SizedBox(height: AppSpacing.x10),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.go(Routes.lessons),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.x8),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius:
                              BorderRadius.circular(AppRadii.r14),
                        ),
                        child: Row(
                          children: [
                            SubjectTile(
                              subject: a.subject,
                              size: 40,
                              excludeSemantics: true,
                            ),
                            const SizedBox(width: AppSpacing.x10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.title,
                                    style: AppTextStyles.rowTitle,
                                  ),
                                  Text(a.meta, style: AppTextStyles.metaSmall),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x8),
                            const AppIcon(
                              AppIcons.download,
                              size: 20,
                              color: AppColors.info,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: mine ? 0 : 6,
                end: mine ? 6 : 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    justSent
                        ? l10n.justNowSent
                        : message.readReceipt
                        ? '${message.time} · ${l10n.readReceipt}'
                        : message.time,
                    style: AppTextStyles.nunito(
                      size: 11,
                      weight: FontWeight.w700,
                      color: AppColors.inkSubtle,
                    ),
                  ),
                  if (message.readReceipt) ...[
                    const SizedBox(width: AppSpacing.x4),
                    const AppIcon(
                      AppIcons.check,
                      size: 13,
                      strokeWidth: 3,
                      color: AppColors.success,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
