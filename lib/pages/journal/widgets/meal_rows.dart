import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/app/theme/instant_motion.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_write.dart';
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
import 'package:fujin/pages/journal/widgets/swipe_row.dart';
import 'package:fujin/pages/journal/writer_state_ids.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motor/motor.dart';

class MealRows extends HookWidget {
  const MealRows({
    required this.entries,
    required this.leaving,
    required this.groupTag,
    required this.removable,
    required this.removedEntryId,
    required this.onOpen,
    required this.onRemove,
    super.key,
  });

  final List<ComparedEntry> entries;
  final List<LoggedEntry> leaving;
  final Object groupTag;
  final bool removable;
  final String? removedEntryId;
  final ValueChanged<ComparedEntry> onOpen;
  final ValueChanged<ComparedEntry> onRemove;

  @override
  Widget build(BuildContext context) {
    final lines = _Line.merged(entries, leaving);
    final ids = [for (final line in lines) line.entryId];
    final heights = useRef(<String, double>{});
    final previous = usePrevious(ids);
    final cascade = useRef<_Cascade?>(null);
    final generation = useRef(0);
    if (_Cascade.of(
          removedEntryId,
          before: previous,
          after: ids,
          heights: heights.value,
        )
        case final started? when started.entryId != cascade.value?.entryId) {
      cascade.value = started;
      generation.value++;
    }
    final running = cascade.value;
    final start = generation.value - 1;

    Widget slot(_Line line) {
      final row = Padding(
        padding: const EdgeInsets.symmetric(vertical: FujinSpace.s3),
        child: switch (line) {
          _Live(:final compared) => _EntryRow(compared),
          _Leaving(:final logged) => _LeavingRow(logged),
        },
      );
      return _Measured(
        onHeight: (height) {
          if (line.entryId case final id?) heights.value[id] = height;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(),
            switch (line) {
              _Live(
                compared: ComparedEntry(entryId: final id?) && final compared,
              ) =>
                SwipeRow(
                  key: ValueKey(id),
                  groupTag: groupTag,
                  enabled: removable,
                  label: context.intl.rowDelete,
                  onRemove: () => onRemove(compared),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onOpen(compared),
                    child: row,
                  ),
                ),
              _Live() || _Leaving() => row,
            },
          ],
        ),
      );
    }

    return SingleMotionBuilder(
      motion: switch (running) {
        null => const InstantMotion(),
        final running => FujinMotion.of(
          context,
          LinearMotion(running.duration),
        ),
      },
      value: generation.value.toDouble(),
      builder: (context, value, _) {
        final progress = value - start;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, line) in lines.indexed)
              Transform.translate(
                key: ValueKey<Object>(line.key),
                offset: Offset(0, running?.shift(index, progress) ?? 0),
                child: slot(line),
              ),
            SizedBox(height: running?.spacer(progress) ?? 0),
          ],
        );
      },
    );
  }
}

final class _Cascade {
  const _Cascade({
    required this.entryId,
    required this.index,
    required this.slot,
    required this.rising,
  });

  final String entryId;
  final int index;
  final double slot;
  final int rising;

  static _Cascade? of(
    String? entryId, {
    required List<String?>? before,
    required List<String?> after,
    required Map<String, double> heights,
  }) {
    if ((entryId, before, heights[entryId]) case (
      final id?,
      final before?,
      final height?,
    ) when !after.contains(id)) {
      final index = before.indexOf(id);
      if (index < 0 || after.isEmpty) return null;
      return _Cascade(
        entryId: id,
        index: index,
        slot: height,
        rising: after.length - index,
      );
    }
    return null;
  }

  int get _last => switch (rising) {
    0 => 0,
    _ => rising - 1,
  };

  Duration get duration =>
      FujinMotion.rowRemovalStagger * (_last + 1) +
      FujinMotion.rowRemoval.duration;

  double _progress(int step, double progress) {
    final total = duration.inMicroseconds;
    final start = (FujinMotion.rowRemovalStagger * (step + 1)).inMicroseconds;
    final end = start + FujinMotion.rowRemoval.duration.inMicroseconds;
    return FujinMotion.rowRemoval.curve.transform(
      Interval(start / total, end / total).transform(progress.clamp(0, 1)),
    );
  }

  double shift(int index, double progress) => switch (index - this.index) {
    final step when step >= 0 => slot * (1 - _progress(step, progress)),
    _ => 0,
  };

  double spacer(double progress) => slot * (1 - _progress(_last, progress));
}

class _Measured extends SingleChildRenderObjectWidget {
  const _Measured({required this.onHeight, required super.child});

  final ValueChanged<double> onHeight;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasured(onHeight);

  @override
  void updateRenderObject(BuildContext context, _RenderMeasured renderObject) {
    renderObject.onHeight = onHeight;
  }
}

class _RenderMeasured extends RenderProxyBox {
  _RenderMeasured(this.onHeight);

  ValueChanged<double> onHeight;

  @override
  void performLayout() {
    super.performLayout();
    onHeight(size.height);
  }
}

sealed class _Line {
  const _Line();

  static List<_Line> merged(
    List<ComparedEntry> entries,
    List<LoggedEntry> leaving,
  ) {
    final lines = <_Line>[];
    var next = 0;
    for (final compared in entries) {
      if (compared.entryId case final id?) {
        while (next < leaving.length &&
            leaving[next].entry.id.compareTo(id) < 0) {
          lines.add(_Leaving(leaving[next++]));
        }
      }
      lines.add(_Live(compared));
    }
    return [
      ...lines,
      for (final logged in leaving.skip(next)) _Leaving(logged),
    ];
  }

  String? get entryId;

  Object get key;
}

final class _Live extends _Line {
  const _Live(this.compared);

  final ComparedEntry compared;

  @override
  String? get entryId => compared.entryId;

  @override
  Object get key => compared.entryId ?? compared.logged;
}

final class _Leaving extends _Line {
  const _Leaving(this.logged);

  final LoggedEntry logged;

  @override
  String get entryId => logged.entry.id;

  @override
  Object get key => logged.entry.id;
}

class _EntryRow extends ConsumerWidget {
  const _EntryRow(this.compared);

  final ComparedEntry compared;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = compared.logged;
    final id = entry.entry.id;
    final (:mfpFailed, :failed, :sending) = ref.watch(
      backgroundWriteProvider.select(
        (state) => (
          mfpFailed: state.mfpFailedIds.contains(id),
          failed: state.failedIds.contains(id),
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

class _LeavingRow extends ConsumerWidget {
  const _LeavingRow(this.logged);

  final LoggedEntry logged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = logged.entry.id;
    final (:mfpFailed, :failed, :removing) = ref.watch(
      backgroundWriteProvider.select(
        (state) => (
          mfpFailed: state.mfpFailedIds.contains(id),
          failed: state.failedIds.contains(id),
          removing: state.ekkloRemovalIds.contains(id),
        ),
      ),
    );
    return EntryRow(
      entry: logged,
      detail: context.intl.entryDeletedInFujin,
      removed: true,
      pills: [
        if (MfpWrite.of(logged) case MfpDeletion())
          ConnectorPill(connector: Connector.mfp, failed: mfpFailed),
        if (removing) ConnectorPill(connector: Connector.ekklo, failed: failed),
      ],
    );
  }
}
