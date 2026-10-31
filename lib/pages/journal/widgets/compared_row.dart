import 'package:flutter/material.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/comparison/mfp_status.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/journal/background_write_notifier.dart';
import 'package:fujin/pages/journal/widgets/connector_pill.dart';
import 'package:fujin/pages/journal/widgets/entry_row.dart';
import 'package:fujin/pages/journal/writer_state_ids.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComparedRow extends ConsumerWidget {
  const ComparedRow(this.compared, {super.key});

  final ComparedEntry compared;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = compared.logged;
    final id = entry.entry.id;
    final environment = ref.watch(appEnvironmentProvider);
    final (:mfpFailed, :failed, :sending) = ref.watch(
      backgroundWriteProvider.select(
        (state) => (
          mfpFailed: state.mfpFailedIds(environment).contains(id),
          failed: state.failedIds(environment).contains(id),
          sending: state.ekkloSendIds.contains(id),
        ),
      ),
    );
    final detail = switch (compared.status) {
      ToUpdate(link: EkkloLink(:final item?)) => EntryText.linkedServing(
        context.intl,
        item,
      ),
      InEkklo() || ToSend() || ToUpdate() => EntryText.macros(
        context.intl,
        entry.entry.nutrients,
      ),
    };
    final status = switch ((compared.status, sending)) {
      (ToSend() || ToUpdate(), true) => ConnectorPill(
        connector: Connector.ekklo,
        failed: failed,
      ),
      (InEkklo(), _) => StatusPill(
        label: context.intl.statusInEkklo,
        tone: PillTone.validated,
      ),
      (ToSend(), false) => StatusPill(
        label: context.intl.statusToSend,
        tone: PillTone.attention,
      ),
      (ToUpdate(), false) => StatusPill(
        label: context.intl.statusToUpdate,
        tone: PillTone.info,
        icon: Icons.refresh,
      ),
    };
    return EntryRow(
      entry: entry,
      detail: detail,
      pills: [
        if (compared.mfp case final mfp?)
          ConnectorPill(
            connector: Connector.mfp,
            failed: mfp is MfpFailed || mfpFailed,
          ),
        status,
      ],
    );
  }
}
