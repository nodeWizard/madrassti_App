import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/medallion.dart';
import '../../core/widgets/screen.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/models/models.dart';
import '../../l10n/app_localizations.dart';

/// Board 8a · Messages.
class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final conversations = ref.watch(parentRepositoryProvider).conversations;

    return AppScreen(
      gap: AppSpacing.x16,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.messages, style: AppTextStyles.h1)),
            const SizedBox(width: AppSpacing.x12),
            PrimaryButton(
              label: l10n.write,
              icon: AppIcons.pencil,
              height: 48,
              radius: AppRadii.field,
              expand: false,
              onPressed: () => context.push(Routes.chat),
            ),
          ],
        ),

        // ------------------------------------------------- hours banner
        Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x14,
            vertical: AppSpacing.x12,
          ),
          decoration: BoxDecoration(
            color: AppColors.infoTint,
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          child: Row(
            children: [
              const AppIcon(
                AppIcons.clock,
                size: 22,
                color: AppColors.info,
              ),
              const SizedBox(width: AppSpacing.x12),
              Expanded(
                child: Text(
                  l10n.replyHours,
                  style: AppTextStyles.nunito(
                    size: 14,
                    weight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ---------------------------------------------- conversation list
        Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x6,
            vertical: AppSpacing.x4,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.r24),
          ),
          child: Column(
            children: [
              for (var i = 0; i < conversations.length; i++)
                _ConversationRow(
                  conversation: conversations[i],
                  showDivider: i > 0,
                  // The read-only school thread opens the announcements list.
                  onTap: () => conversations[i].locked
                      ? context.push(Routes.notifications)
                      : context.push(Routes.chat),
                ),
            ],
          ),
        ),

        // ------------------------------------------------ privacy notice
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppIcon(
              AppIcons.shield,
              size: 18,
              color: AppColors.success,
            ),
            const SizedBox(width: AppSpacing.x8),
            Expanded(
              child: Text(
                l10n.moderationNotice,
                style: AppTextStyles.nunito(
                  size: 13,
                  height: 1.45,
                  color: AppColors.inkSubtle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ConversationRow extends StatelessWidget {
  const _ConversationRow({
    required this.conversation,
    required this.showDivider,
    required this.onTap,
  });

  final Conversation conversation;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    return Semantics(
      button: true,
      label: '${c.name}, ${c.role}. ${c.lastMessage}'
          '${c.hasUnread ? ', ${c.unread} non lus' : ''}',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x8,
              vertical: AppSpacing.x14,
            ),
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
                  width: 52,
                  height: 52,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InitialAvatar(
                        initials: c.initials,
                        background: c.avatarBackground,
                        foreground: c.avatarForeground,
                        size: 52,
                        radius: AppRadii.button,
                        fontSize: 19,
                      ),
                      if (c.locked)
                        PositionedDirectional(
                          bottom: -4,
                          end: -4,
                          child: Container(
                            width: 22,
                            height: 22,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const AppIcon(
                              AppIcons.lock,
                              size: 13,
                              strokeWidth: 2.5,
                              color: AppColors.inkSubtle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.name,
                              style: AppTextStyles.nunito(
                                size: 16,
                                weight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x8),
                          Text(
                            c.time,
                            maxLines: 1,
                            style: AppTextStyles.nunito(
                              size: 12,
                              weight: FontWeight.w700,
                              color: c.hasUnread
                                  ? AppColors.danger
                                  : AppColors.inkSubtle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        c.role,
                        style: AppTextStyles.nunito(
                          size: 12,
                          weight: FontWeight.w800,
                          color: AppColors.inkSubtle,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.nunito(
                                size: 14,
                                weight: c.hasUnread
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: AppColors.inkMuted,
                              ),
                            ),
                          ),
                          if (c.hasUnread) ...[
                            const SizedBox(width: AppSpacing.x8),
                            UnreadBadge(count: c.unread),
                          ],
                        ],
                      ),
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
