import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_icon_paths.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/medallion.dart';
import '../../core/widgets/screen.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/subject_tile.dart';
import '../../data/models/models.dart';
import '../../l10n/app_localizations.dart';

/// Board 14 · Accueil enseignant.
class TeacherHomeScreen extends ConsumerWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final repo = ref.watch(teacherRepositoryProvider);

    return AppScreen(
      gap: AppSpacing.x16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(repo.headerLabel, style: AppTextStyles.meta),
            const SizedBox(height: AppSpacing.x2),
            Text(
              l10n.teacherGreeting(repo.teacherName),
              style: AppTextStyles.h2,
            ),
          ],
        ),

        // -------------------------------------------------------- actions
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PrimaryButton(
                label: l10n.publishLesson,
                icon: AppIcons.upload,
                height: 60,
                radius: AppRadii.button,
                textStyle: AppTextStyles.nunito(
                  size: 15,
                  weight: FontWeight.w800,
                ),
                onPressed: () => context.go(Routes.teacherPublish),
              ),
            ),
            const SizedBox(width: AppSpacing.x10),
            Expanded(
              child: NavyButton(
                label: l10n.reportChange,
                icon: AppIcons.swap,
                height: 60,
                radius: AppRadii.button,
                onPressed: () => context.go(Routes.teacherAbsence),
              ),
            ),
          ],
        ),

        // -------------------------------------------------------- agenda
        Container(
          padding: const EdgeInsets.all(AppSpacing.x16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.r24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.myDayTeacher, style: AppTextStyles.sectionTitle),
                  Text(
                    l10n.sessionsCount(repo.todaySlots.length),
                    style: AppTextStyles.nunito(
                      size: 13,
                      weight: FontWeight.w800,
                      color: AppColors.inkSubtle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x6),
              for (final s in repo.todaySlots) _SlotRow(slot: s),
            ],
          ),
        ),

        // ---------------------------------------------------- statistics
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _StatCard(
                icon: AppIcons.message,
                tint: AppColors.infoTint,
                ink: AppColors.info,
                value: '${repo.unreadMessageCount}',
                label: l10n.unreadMessages,
                onTap: () => context.go(Routes.teacherMessages),
              ),
            ),
            const SizedBox(width: AppSpacing.x10),
            Expanded(
              child: _StatCard(
                icon: AppIcons.book,
                tint: AppColors.successTint,
                ink: AppColors.success,
                value: '${repo.lessonsPublishedThisWeek}',
                label: l10n.lessonsPublishedThisWeek,
                onTap: () => context.go(Routes.teacherPublish),
              ),
            ),
          ],
        ),

        // ------------------------------------------------- latest messages
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.latestMessages, style: AppTextStyles.sectionTitle),
                AppTextLink(
                  label: l10n.seeAll,
                  minHeight: 44,
                  onPressed: () => context.go(Routes.teacherMessages),
                ),
              ],
            ),
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
                  for (var i = 0; i < repo.conversations.take(2).length; i++)
                    _MessagePreviewRow(
                      conversation: repo.conversations[i],
                      showDivider: i > 0,
                      onTap: () => context.push(Routes.chat),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SlotRow extends StatelessWidget {
  const _SlotRow({required this.slot});

  final TeacherSlot slot;

  @override
  Widget build(BuildContext context) {
    // `Container.margin` must be non-negative, so the -8px bleed to the
    // card's own edges (matching the mockup's `margin: 0 -8px`) goes on a
    // `Padding` instead, which allows negative insets.
    return Opacity(
      opacity: slot.state == TeacherSlotState.done ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: -8),
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x8,
            vertical: AppSpacing.x8,
          ),
          decoration: BoxDecoration(
            color: slot.state == TeacherSlotState.now
                ? AppColors.warnRow
                : const Color(0x00000000),
            borderRadius: BorderRadius.circular(AppRadii.field),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 46,
                child: Text(
                  slot.time.hhmm,
                  style: AppTextStyles.nunito(
                    size: 14,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
              SubjectTile(
                subject: slot.subject,
                size: 36,
                excludeSemantics: true,
              ),
              const SizedBox(width: AppSpacing.x12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppSubjects.of(slot.subject).name,
                      style: AppTextStyles.nunito(
                        size: 15,
                        weight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${slot.className} · ${slot.room}',
                      style: AppTextStyles.metaSmall,
                    ),
                  ],
                ),
              ),
              if (slot.state == TeacherSlotState.now) StatusChip.inProgress(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.tint,
    required this.ink,
    required this.value,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final Color tint;
  final Color ink;
  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$value $label',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.x14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.r22),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Medallion(icon: icon, background: tint, foreground: ink),
                const SizedBox(height: AppSpacing.x8),
                Text(value, style: AppTextStyles.fredoka(size: 26, height: 1)),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  label,
                  style: AppTextStyles.nunito(
                    size: 13,
                    weight: FontWeight.w800,
                    color: AppColors.inkMuted,
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

class _MessagePreviewRow extends StatelessWidget {
  const _MessagePreviewRow({
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: AppSpacing.x10,
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
              size: 42,
              radius: AppRadii.r14,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(width: AppSpacing.x12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${c.name} · ${c.childLabel}',
                    style: AppTextStyles.nunito(
                      size: 14,
                      weight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    c.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.nunito(
                      size: 13,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x8),
            Text(
              c.time,
              style: AppTextStyles.nunito(
                size: 12,
                weight: FontWeight.w800,
                color: AppColors.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
