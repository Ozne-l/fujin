import 'package:flutter/material.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/journal/background_write_notifier.dart';
import 'package:fujin/pages/journal/widgets/connector_pill.dart';
import 'package:fujin/pages/journal/widgets/entry_row.dart';
import 'package:fujin/pages/journal/writer_state_ids.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoredRow extends ConsumerWidget {
  const StoredRow(this.logged, {super.key});

  final LoggedEntry logged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(appEnvironmentProvider);
    final failed = ref.watch(
      backgroundWriteProvider.select(
        (state) => state.mfpFailedIds(environment).contains(logged.entry.id),
      ),
    );
    return EntryRow(
      entry: logged,
      detail: EntryText.macros(context.intl, logged.entry.nutrients),
      pills: [
        if (MfpWrite.of(logged) case MfpAdd() || MfpEdit())
          ConnectorPill(connector: Connector.mfp, failed: failed),
      ],
    );
  }
}
