import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/domain/accounts/account.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/text_inset.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:fujin/pages/settings/backup_failure.dart';
import 'package:fujin/pages/settings/backup_notifier.dart';
import 'package:fujin/pages/settings/backup_state.dart';
import 'package:fujin/pages/settings/goals_notifier.dart';
import 'package:fujin/pages/settings/goals_text.dart';
import 'package:fujin/pages/settings/sessions_notifier.dart';
import 'package:fujin/pages/settings/sheets/confirm_sheet.dart';
import 'package:fujin/pages/settings/widgets/account_row.dart';
import 'package:fujin/pages/settings/widgets/settings_row.dart';
import 'package:fujin/pages/settings/widgets/settings_section.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const _lockIcon = 'assets/icons/lock.svg';
  static const _deleteIcon = 'assets/icons/delete.svg';
  static const _copyIcon = 'assets/icons/copy.svg';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final memory = ref.watch(memoryProvider);
    final goals = ref.watch(goalsProvider);
    final version = ref.watch(appVersionProvider);
    final backup = ref.watch(backupProvider);
    final backups = ref.read(backupProvider.notifier);
    final sessions = ref.read(sessionsProvider.notifier);
    final counts = l10n.memoryCounts(
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
          _tell(context, l10n.backupExported);
        case BackupImported():
          _tell(context, l10n.backupImported);
        case BackupFailed(failure: BackupFailure.unreadable):
          _tell(context, l10n.backupUnreadable);
        case BackupFailed(failure: BackupFailure.notWritten):
          _tell(context, l10n.backupNotWritten);
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
                l10n.tabSettings,
                style: FujinText.hina30.copyWith(
                  color: FujinColorRole.textPrimary,
                ),
              ),
            ),
            SettingsSection(
              label: l10n.settingsAccounts,
              rows: [
                AccountRow(
                  dot: FujinColorRole.sourceMfp,
                  name: l10n.sourceMyFitnessPal,
                  onSignOut: () => confirm(
                    icon: _lockIcon,
                    title: l10n.signOutMfpTitle,
                    message: l10n.signOutMfpDetail,
                    confirmLabel: l10n.signOut,
                    onConfirm: () =>
                        unawaited(leave(() => sessions.signOut(Account.mfp))),
                  ),
                ),
                AccountRow(
                  dot: FujinColorRole.sourceEkklo,
                  name: l10n.sourceEkklo,
                  onSignOut: () => confirm(
                    icon: _lockIcon,
                    title: l10n.signOutEkkloTitle,
                    message: l10n.signOutEkkloDetail,
                    confirmLabel: l10n.signOut,
                    onConfirm: () => unawaited(
                      leave(() => sessions.signOut(Account.ekklo)),
                    ),
                  ),
                ),
              ],
            ),
            SettingsSection(
              label: l10n.settingsGoals,
              rows: [
                SettingsRow(
                  title: l10n.goalsEveryDay,
                  detail: GoalsText.summary(l10n, goals),
                  onTap: () =>
                      unawaited(context.push<void>(FujinRoute.goals.path)),
                ),
              ],
            ),
            SettingsSection(
              label: l10n.settingsBackup,
              rows: [
                SettingsRow(
                  title: l10n.backupExport,
                  detail: l10n.backupExportDetail,
                  onTap: switch (idle) {
                    true => () => unawaited(backups.export()),
                    false => null,
                  },
                ),
                SettingsRow(
                  title: l10n.backupImport,
                  detail: l10n.backupImportDetail,
                  onTap: switch (idle) {
                    true => () => unawaited(backups.open()),
                    false => null,
                  },
                ),
              ],
            ),
            SettingsSection(
              label: l10n.settingsData,
              rows: [
                SettingsRow(
                  title: l10n.clearSessions,
                  detail: l10n.clearSessionsDetail,
                  titleColor: FujinColorRole.textAlert,
                  onTap: () => confirm(
                    icon: _lockIcon,
                    title: l10n.clearSessionsTitle,
                    message: l10n.clearSessionsConfirm,
                    confirmLabel: l10n.clearSessions,
                    onConfirm: () => unawaited(leave(sessions.clearSessions)),
                  ),
                ),
                SettingsRow(
                  title: l10n.clearMemory,
                  detail: counts,
                  titleColor: FujinColorRole.textAlert,
                  onTap: () => confirm(
                    icon: _deleteIcon,
                    title: l10n.clearMemoryTitle,
                    message: l10n.clearMemoryConfirm(counts),
                    confirmLabel: l10n.clearMemory,
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
                l10n.appVersion(version),
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
    final l10n = AppLocalizations.of(context);
    return showConfirmSheet(
      context,
      icon: _copyIcon,
      title: l10n.importTitle,
      message: l10n.importDetail(
        backup.exportedAt.toLocal(),
        backup.foodCount,
        backup.meals.length,
        backup.links.length,
      ),
      confirmLabel: l10n.importConfirm,
      onConfirm: onConfirm,
    );
  }

  static void _tell(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
}
