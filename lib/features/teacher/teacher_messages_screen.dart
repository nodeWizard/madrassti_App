import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/app_switch.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/medallion.dart';
import '../../core/widgets/screen.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/models/models.dart';
import '../../l10n/app_localizations.dart';

enum _MsgFilter { all, unread, class4A, class4B }

/// Board 17 · Messages enseignant.
///
/// An availability toggle, plus a 4-way filter on top of the usual
/// conversation list.
class TeacherMessagesScreen extends ConsumerStatefulWidget {
  const TeacherMessagesScreen({super.key});

  @override
  ConsumerState<TeacherMessagesScreen> createState() =>
      _TeacherMessagesScreenState();
}

class _TeacherMessagesScreenState extends ConsumerState<TeacherMessagesScreen> {
  bool _available = true;
  _MsgFilter _filter = _MsgFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(teacherRepositoryProvider);

    final filters = <(_MsgFilter, String)>[
      (_MsgFilter.all, l10n.filterAll),
      (_MsgFilter.unread, l10n.filterUnread),
      (_MsgFilter.class4A, '4e A'),
      (_MsgFilter.class4B, '4e B'),
    ];

    final shown = repo.conversations.where((c) {
      switch (_filter) {
        case _MsgFilter.all:
          return true;
        case _MsgFilter.unread:
          return c.hasUnread;
        case _MsgFilter.class4A:
          return c.classLabel == '4e A';
        case _MsgFilter.class4B:
          return c.classLabel == '4e B';
      }
    }).toList();

    return AppScreen(
      gap: AppSpacing.x16,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.messages, style: AppTextStyles.h1)),
            const SizedBox(width: AppSpacing.x12),
            PrimaryButton(
              label: l10n.writeToClass,
              icon: AppIcons.users,
              height: 48,
              radius: AppRadii.field,
              expand: false,
              textStyle: AppTextStyles.buttonSmall,
              onPressed: () => context.push(Routes.chat),
            ),
          ],
        ),

        // ---------------------------------------------- availability
        Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x14,
            vertical: AppSpacing.x12,
          ),
          decoration: BoxDecoration(
            color: _available ? AppColors.successTint : AppColors.sportTint,
            borderRadius: BorderRadius.circular(AppRadii.r20),
          ),
          child: Row(
            children: [
              Medallion(
                icon: _available ? AppIcons.clock : AppIcons.moon,
                background: AppColors.white,
                foreground: _available
                    ? AppColors.success
                    : AppColors.inkSubtle,
              ),
              const SizedBox(width: AppSpacing.x12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _available ? l10n.availableHours : l10n.onBreak,
                      style: AppTextStyles.nunito(
                        size: 15,
                        weight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      _available ? l10n.availableHoursBody : l10n.onBreakBody,
                      style: AppTextStyles.nunito(
                        size: 12,
                        weight: FontWeight.w700,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              AppSwitch(
                value: _available,
                offColor: AppColors.onNavySubtle,
                semanticLabel: l10n.availableForMessages,
                onChanged: (v) => setState(() => _available = v),
              ),
            ],
          ),
        ),

        // ------------------------------------------------------ filters
        Row(
          children: [
            for (final f in filters) ...[
              if (f != filters.first) const SizedBox(width: AppSpacing.x8),
              _FilterChip(
                label: f.$2,
                selected: _filter == f.$1,
                onTap: () => setState(() => _filter = f.$1),
              ),
            ],
          ],
        ),

        // --------------------------------------------------------- list
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
              for (var i = 0; i < shown.length; i++)
                _TeacherConversationRow(
                  conversation: shown[i],
                  showDivider: i > 0,
                  onTap: () => context.push(Routes.chat),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
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
            height: 40,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r20),
              border: Border.all(
                color: selected ? AppColors.navy : AppColors.cardBorder,
                width: 1.5,
              ),
            ),
            child: Text(
              label,
              style: AppTextStyles.nunito(
                size: 14,
                weight: FontWeight.w800,
                color: selected ? AppColors.white : AppColors.navy,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TeacherConversationRow extends StatelessWidget {
  const _TeacherConversationRow({
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
      label:
          '${c.name}, ${c.childLabel}, ${c.classLabel}. ${c.lastMessage}'
          '${c.hasUnread ? ', ${c.unread} non lus' : ''}',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x8,
              vertical: AppSpacing.x12,
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
                InitialAvatar(
                  initials: c.initials,
                  background: c.avatarBackground,
                  foreground: c.avatarForeground,
                  size: 48,
                  radius: AppRadii.field,
                  fontSize: 18,
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
                                size: 15,
                                weight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x8),
                          Text(
                            c.time,
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
                      Row(
                        children: [
                          if (c.classLabel case final cl?) ...[
                            Container(
                              height: 20,
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 7,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                cl,
                                style: AppTextStyles.nunito(
                                  size: 11,
                                  weight: FontWeight.w800,
                                  color: AppColors.info,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x6),
                          ],
                          if (c.childLabel case final child?)
                            Expanded(
                              child: Text(
                                child,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.metaSmall,
                              ),
                            ),
                        ],
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
