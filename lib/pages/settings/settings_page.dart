import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/domain/accounts/account.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/automatic_mode_notifier.dart';
import 'package:fujin/pages/common/confirm_sheet.dart';
import 'package:fujin/pages/common/delete_icon.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/goals_notifier.dart';
import 'package:fujin/pages/common/goals_text.dart';
import 'package:fujin/pages/common/text_inset.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:fujin/pages/settings/backup_failure.dart';
import 'package:fujin/pages/settings/backup_notifier.dart';
import 'package:fujin/pages/settings/backup_state.dart';
import 'package:fujin/pages/settings/sessions_notifier.dart';
import 'package:fujin/pages/settings/widgets/account_row.dart';
import 'package:fujin/pages/settings/widgets/settings_row.dart';
import 'package:fujin/pages/settings/widgets/settings_section.dart';
import 'package:fujin/pages/settings/widgets/settings_switch_row.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const _lockIcon = 'assets/icons/lock.svg';
  static const _copyIcon = 'assets/icons/copy.svg';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memory = ref.watch(memoryProvider);
    final goals = ref.watch(goalsProvider);
    final automaticMode = ref.watch(automaticModeProvider);
    final version = ref.watch(appVersionProvider);
    final backup = ref.watch(backupProvider);
    final backups = ref.read(backupProvider.notifier);
    final sessions = ref.read(sessionsProvider.notifier);
    final counts = context.intl.memoryCounts(
      memory.matches.length + memory.ownCopies.length,
      memory.meals.length,
    );
    final idle = switch (backup) {
      BackupRunning() || BackupOpened() => false,
      BackupIdle() ||
      BackupExported() ||
      BackupImported() ||
      BackupFailed() => true,
    };

    ref.listen(backupProvider, (previous, next) {
      switch (next) {
        case BackupOpened(:final backup):
          unawaited(
            _confirmImport(
              context,
              backup,
              () => backups.restore(backup),
            ).then((_) => backups.cancel()),
          );
        case BackupExported():
          _tell(context, context.intl.backupExported);
        case BackupImported():
          _tell(context, context.intl.backupImported);
        case BackupFailed(failure: BackupFailure.unreadable):
          _tell(context, context.intl.backupUnreadable);
        case BackupFailed(failure: BackupFailure.notWritten):
          _tell(context, context.intl.backupNotWritten);
        case BackupIdle() || BackupRunning():
          break;
      }
    });

    Future<void> leave(Future<void> Function() signOut) async {
      await signOut();
      if (!context.mounted) return;
      context.go(FujinRoute.journal.path);
    }

    void confirm({
      required String icon,
      required String title,
      required String message,
      required String confirmLabel,
      required VoidCallback onConfirm,
    }) => unawaited(
      showConfirmSheet(
        context,
        icon: icon,
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
      ),
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            FujinSize.screenMargin,
            FujinSpace.s3,
            FujinSize.screenMargin,
            FujinSpace.s8 + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            TextInset(
              bottom: FujinSpace.s1,
              child: Text(
                context.intl.tabSettings,
                style: FujinText.hina30.copyWith(
                  color: FujinColorRole.textPrimary,
                ),
              ),
            ),
            SettingsSection(
              label: context.intl.settingsAccounts,
              rows: [
                AccountRow(
                  dot: FujinColorRole.sourceMfp,
                  name: context.intl.sourceMyFitnessPal,
                  onSignOut: () => confirm(
                    icon: _lockIcon,
                    title: context.intl.signOutMfpTitle,
                    message: context.intl.signOutMfpDetail,
                    confirmLabel: context.intl.signOut,
                    onConfirm: () =>
                        unawaited(leave(() => sessions.signOut(Account.mfp))),
                  ),
                ),
                AccountRow(
                  dot: FujinColorRole.sourceEkklo,
                  name: context.intl.sourceEkklo,
                  onSignOut: () => confirm(
                    icon: _lockIcon,
                    title: context.intl.signOutEkkloTitle,
                    message: context.intl.signOutEkkloDetail,
                    confirmLabel: context.intl.signOut,
                    onConfirm: () => unawaited(
                      leave(() => sessions.signOut(Account.ekklo)),
                    ),
                  ),
                ),
              ],
            ),
            SettingsSection(
              label: context.intl.settingsGoals,
              rows: [
                SettingsRow(
                  title: context.intl.goalsEveryDay,
                  detail: GoalsText.summary(context.intl, goals),
                  onTap: () =>
                      unawaited(context.push<void>(FujinRoute.goals.path)),
                ),
              ],
            ),
            SettingsSection(
              label: context.intl.settingsSending,
              rows: [
                SettingsSwitchRow(
                  title: context.intl.automaticMode,
                  detail: context.intl.automaticModeDetail,
                  value: automaticMode,
                  onChanged: (on) => unawaited(
                    ref.read(automaticModeProvider.notifier).turn(on: on),
                  ),
                ),
              ],
            ),
            SettingsSection(
              label: context.intl.settingsBackup,
              rows: [
                SettingsRow(
                  title: context.intl.backupExport,
                  detail: context.intl.backupExportDetail,
                  onTap: switch (idle) {
                    true => () => unawaited(backups.export()),
                    false => null,
                  },
                ),
                SettingsRow(
                  title: context.intl.backupImport,
                  detail: context.intl.backupImportDetail,
                  onTap: switch (idle) {
                    true => () => unawaited(backups.open()),
                    false => null,
                  },
                ),
              ],
            ),
            SettingsSection(
              label: context.intl.settingsData,
              rows: [
                SettingsRow(
                  title: context.intl.clearSessions,
                  detail: context.intl.clearSessionsDetail,
                  titleColor: FujinColorRole.textAlert,
                  onTap: () => confirm(
                    icon: _lockIcon,
                    title: context.intl.clearSessionsTitle,
                    message: context.intl.clearSessionsConfirm,
                    confirmLabel: context.intl.clearSessions,
                    onConfirm: () => unawaited(leave(sessions.clearSessions)),
                  ),
                ),
                SettingsRow(
                  title: context.intl.clearMemory,
                  detail: counts,
                  titleColor: FujinColorRole.textAlert,
                  onTap: () => confirm(
                    icon: DeleteIcon.asset,
                    title: context.intl.clearMemoryTitle,
                    message: context.intl.clearMemoryConfirm(counts),
                    confirmLabel: context.intl.clearMemory,
                    onConfirm: () {
                      ref.read(memoryProvider.notifier).clear();
                      ref.invalidate(journalProvider);
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: FujinSpace.s3),
              child: Text(
                context.intl.appVersion(version),
                textAlign: TextAlign.center,
                style: FujinText.inter12Regular.copyWith(
                  color: FujinColorRole.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _confirmImport(
    BuildContext context,
    Backup backup,
    VoidCallback onConfirm,
  ) {
    return showConfirmSheet(
      context,
      icon: _copyIcon,
      title: context.intl.importTitle,
      message: context.intl.importDetail(
        backup.exportedAt.toLocal(),
        backup.foodCount,
        backup.meals.length,
        backup.links.length,
      ),
      confirmLabel: context.intl.importConfirm,
      onConfirm: onConfirm,
    );
  }

  static void _tell(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showFujinSnackBar(
        SnackBar(content: Text(message)),
      );
}
