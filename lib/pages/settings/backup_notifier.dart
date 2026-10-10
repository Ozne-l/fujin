import 'package:fujin/app/providers.dart';
import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/domain/backup/backup_service.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:fujin/pages/settings/backup_failure.dart';
import 'package:fujin/pages/settings/backup_state.dart';
import 'package:fujin/pages/settings/goals_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<BackupNotifier, BackupState> backupProvider =
    NotifierProvider.autoDispose<BackupNotifier, BackupState>(
      BackupNotifier.new,
    );

final class BackupNotifier extends Notifier<BackupState> {
  @override
  BackupState build() => const BackupIdle();

  Future<void> export() async {
    state = const BackupRunning();
    final next = await _export(ref.read(backupServiceProvider));
    if (ref.mounted) state = next;
  }

  Future<void> open() async {
    state = const BackupRunning();
    final next = await _open(ref.read(backupServiceProvider));
    if (ref.mounted) state = next;
  }

  void restore(Backup backup) {
    try {
      ref.read(backupServiceProvider).restore(backup);
    } on Exception {
      state = const BackupFailed(BackupFailure.unreadable);
      return;
    }
    ref
      ..invalidate(memoryProvider)
      ..invalidate(goalsProvider)
      ..invalidate(journalProvider);
    state = const BackupImported();
  }

  void cancel() {
    if (state case BackupOpened()) state = const BackupIdle();
  }

  static Future<BackupState> _export(BackupService backups) async {
    try {
      return switch (await backups.export()) {
        true => const BackupExported(),
        false => const BackupIdle(),
      };
    } on Exception {
      return const BackupFailed(BackupFailure.notWritten);
    }
  }

  static Future<BackupState> _open(BackupService backups) async {
    try {
      return switch (await backups.pick()) {
        final bytes? => switch (backups.read(bytes)) {
          final backup? => BackupOpened(backup),
          null => const BackupFailed(BackupFailure.unreadable),
        },
        null => const BackupIdle(),
      };
    } on Exception {
      return const BackupFailed(BackupFailure.unreadable);
    }
  }
}
