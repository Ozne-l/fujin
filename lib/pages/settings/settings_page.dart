import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/domain/accounts/account.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/appearance_corner.dart';
import 'package:fujin/pages/common/appearance_header.dart';
import 'package:fujin/pages/common/appearance_notifier.dart';
import 'package:fujin/pages/common/automatic_mode_notifier.dart';
import 'package:fujin/pages/common/confirm_sheet.dart';
import 'package:fujin/pages/common/delete_icon.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/goals_notifier.dart';
import 'package:fujin/pages/common/goals_text.dart';
import 'package:fujin/pages/common/scroll_edge_blur.dart';
import 'package:fujin/pages/common/scroll_extent_listener.dart';
import 'package:fujin/pages/common/text_inset.dart';
import 'package:fujin/pages/common/theme_reveal.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:fujin/pages/settings/backup_failure.dart';
import 'package:fujin/pages/settings/backup_notifier.dart';
import 'package:fujin/pages/settings/backup_state.dart';
import 'package:fujin/pages/settings/sessions_notifier.dart';
import 'package:fujin/pages/settings/widgets/account_row.dart';
import 'package:fujin/pages/settings/widgets/appearance_row.dart';
import 'package:fujin/pages/settings/widgets/settings_row.dart';
import 'package:fujin/pages/settings/widgets/settings_section.dart';
import 'package:fujin/pages/settings/widgets/settings_switch_row.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  static const _lockIcon = 'assets/icons/lock.svg';
  static const _copyIcon = 'assets/icons/copy.svg';
  static const TextStyle _largeTitle = FujinText.hina30;
  static const TextStyle _barTitle = FujinText.hina22;
  static const double _edge = 0;
  static const double _rest = 0;
  static const double _hidden = 0;
  static const double _shown = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memory = ref.watch(memoryProvider);
    final goals = ref.watch(goalsProvider);
    final colors = context.colors;
    final automaticMode = ref.watch(automaticModeProvider);
    final appearance = ref.watch(appearanceProvider);
    final version = ref.watch(appVersionProvider);
    final backup = ref.watch(backupProvider);
    final backups = ref.read(backupProvider.notifier);
    final scrolled = useValueNotifier(_rest);
    final statusBar = MediaQuery.paddingOf(context).top;
    final gone =
        AppearanceHeader.centredTop(context, _largeTitle) +
        AppearanceHeader.lineHeight(context, _largeTitle);
    Widget title(TextStyle style) => Text(
      context.intl.tabSettings,
      style: style.copyWith(color: colors.textPrimary),
    );
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
      body: AppearanceCorner(
        child: ScrollExtentListener(
          scrolled: scrolled,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ScrollEdgeBlur(
                top: statusBar,
                cover: AppearanceCorner.bar,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    FujinSize.screenMargin,
                    statusBar,
                    FujinSize.screenMargin,
                    FujinSpace.s8 + MediaQuery.paddingOf(context).bottom,
                  ),
                  children: [
                    AppearanceHeader(
                      firstLine: _largeTitle,
                      child: TextInset(
                        bottom: FujinSpace.s1,
                        child: title(_largeTitle),
                      ),
                    ),
                    SettingsSection(
                      label: context.intl.settingsAccounts,
                      rows: [
                        AccountRow(
                          dot: colors.sourceMfp,
                          name: context.intl.sourceMyFitnessPal,
                          onSignOut: () => confirm(
                            icon: _lockIcon,
                            title: context.intl.signOutMfpTitle,
                            message: context.intl.signOutMfpDetail,
                            confirmLabel: context.intl.signOut,
                            onConfirm: () => unawaited(
                              leave(() => sessions.signOut(Account.mfp)),
                            ),
                          ),
                        ),
                        AccountRow(
                          dot: colors.sourceEkklo,
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
                          onTap: () => unawaited(
                            context.push<void>(FujinRoute.goals.path),
                          ),
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
                            ref
                                .read(automaticModeProvider.notifier)
                                .turn(on: on),
                          ),
                        ),
                      ],
                    ),
                    SettingsSection(
                      label: context.intl.settingsAppearance,
                      rows: [
                        AppearanceRow(
                          appearance: appearance,
                          onChoose: (choice, origin) =>
                              ThemeReveal.choose(origin, ref, choice),
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
                          titleColor: colors.textAlert,
                          onTap: () => confirm(
                            icon: _lockIcon,
                            title: context.intl.clearSessionsTitle,
                            message: context.intl.clearSessionsConfirm,
                            confirmLabel: context.intl.clearSessions,
                            onConfirm: () =>
                                unawaited(leave(sessions.clearSessions)),
                          ),
                        ),
                        SettingsRow(
                          title: context.intl.clearMemory,
                          detail: counts,
                          titleColor: colors.textAlert,
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
                          color: colors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: statusBar,
                left: _edge,
                right: _edge,
                height: AppearanceCorner.bar,
                child: ExcludeSemantics(
                  child: ValueListenableBuilder(
                    valueListenable: scrolled,
                    builder: (context, scrolled, bar) =>
                        switch (scrolled / gone) {
                          <= _hidden => const SizedBox.shrink(),
                          final shown => Opacity(
                            opacity: shown.clamp(_hidden, _shown),
                            child: bar,
                          ),
                        },
                    child: Center(child: title(_barTitle)),
                  ),
                ),
              ),
            ],
          ),
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
