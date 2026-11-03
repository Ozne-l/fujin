import 'package:flutter/material.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/journal/widgets/connector_pill.dart';
import 'package:fujin/pages/journal/widgets/entry_row.dart';
import 'package:fujin/pages/journal/widgets/row_write.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoredRow extends ConsumerWidget {
  const StoredRow(this.logged, {required this.mfpPending, super.key});

  final LoggedEntry logged;
  final bool mfpPending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mfpFailed = RowWrite.watch(ref, logged.entry.id).mfpFailed;
    return EntryRow(
      entry: logged,
      detail: EntryText.macros(context.intl, logged.entry.nutrients),
      pills: [
        if (mfpPending)
          ConnectorPill(connector: Connector.mfp, failed: mfpFailed),
      ],
    );
  }
}
