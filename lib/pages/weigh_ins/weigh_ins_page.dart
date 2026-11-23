import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/domain/weighing/weigh_in_debt.dart';
import 'package:fujin/domain/weighing/weigh_in_writer_state.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/edge_blur.dart';
import 'package:fujin/pages/common/header_layout.dart';
import 'package:fujin/pages/common/scroll_edge_blur.dart';
import 'package:fujin/pages/common/settings_section.dart';
import 'package:fujin/pages/common/swipe_row.dart';
import 'package:fujin/pages/common/text_inset.dart';
import 'package:fujin/pages/common/top_bar.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/weigh_ins/weigh_in_snack_bar.dart';
import 'package:fujin/pages/weigh_ins/weigh_in_stopped.dart';
import 'package:fujin/pages/weigh_ins/weigh_in_write_notifier.dart';
import 'package:fujin/pages/weigh_ins/weigh_ins_notifier.dart';
import 'package:fujin/pages/weigh_ins/widgets/remove_weigh_in_sheet.dart';
import 'package:fujin/pages/weigh_ins/widgets/weigh_in_row.dart';
import 'package:fujin/pages/weigh_ins/widgets/weigh_in_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WeighInsPage extends ConsumerWidget {
  const WeighInsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intl = context.intl;
    final colors = context.colors;
    final today = ref.watch(todayProvider);
    final environment = ref.watch(appEnvironmentProvider);
    final listed = ref.watch(weighInsProvider);
    final stopped = ref.watch(weighInWriteProvider).stoppedKeys(environment);
    ref.listen(weighInWriteProvider, (previous, next) {
      if ((previous, next) case (
        WeighInWriterRunning(),
        final WeighInWriterIdle idle,
      )) {
        WeighInSnackBar.written(
          context,
          idle,
          environment,
          today: today,
          onRetry: ref.read(weighInWriteProvider.notifier).run,
        );
      }
    });

    void remove(WeighIn weighIn) => unawaited(
      showRemoveWeighInSheet(
        context,
        weighIn: weighIn,
        onConfirm: () {
          ref.read(weighInsProvider.notifier).remove(weighIn);
          WeighInSnackBar.removed(context, weighIn, today: today);
        },
      ),
    );

    void edit(WeighIn weighIn) => unawaited(
      WeighInSheet.show(
        context,
        editing: weighIn,
        onDelete: () => remove(weighIn),
      ),
    );

    Widget row(WeighIn weighIn, List<Connector> owed) {
      final line = WeighInRow(
        weighIn: weighIn,
        today: today,
        owed: owed,
        failed: {
          for (final connector in owed)
            if (stopped.contains((connector, weighIn.id))) connector,
        },
      );
      return switch (weighIn.deletedAt) {
        _? => line,
        null => SwipeRow(
          key: ValueKey(weighIn.id),
          groupTag: WeighInsPage,
          enabled: true,
          label: intl.rowDelete,
          onRemove: () => remove(weighIn),
          child: InkWell(onTap: () => edit(weighIn), child: line),
        ),
      };
    }

    return Scaffold(
      extendBody: true,
      body: HeaderLayout(
        header: HeaderLayout.shield(
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [TopBar(title: intl.weighInsTitle)],
            ),
          ),
        ),
        body: (context, top, _) => ScrollEdgeBlur(
          top: top,
          child: SwipeRow.group(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                FujinSize.screenMargin,
                top,
                FujinSize.screenMargin,
                MediaQuery.paddingOf(context).bottom + FujinSpace.s4,
              ),
              children: switch (listed) {
                [] => [
                  TextInset(
                    top: FujinSpace.s6,
                    bottom: FujinSpace.s2,
                    child: Text(
                      intl.weighInsEmptyTitle,
                      style: FujinText.hina30.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  TextInset(
                    child: Text(
                      intl.weighInsEmptyDetail,
                      style: FujinText.inter15Regular.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
                _ => [
                  SettingsSection(
                    label: intl.weighInsSection,
                    rows: [
                      for (final logged in listed)
                        row(logged.weighIn, [
                          for (final debt in WeighInDebt.of(logged))
                            debt.connector,
                        ]),
                    ],
                  ),
                ],
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          const Positioned.fill(child: EdgeBlur.bottom()),
          HeaderLayout.shield(
            SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: FujinSpace.s2),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  FujinSize.screenMargin,
                  FujinSpace.s2,
                  FujinSize.screenMargin,
                  0,
                ),
                child: FilledButton(
                  style: FujinTheme.floatingButtonStyle(colors),
                  onPressed: () => unawaited(WeighInSheet.show(context)),
                  child: Text(intl.weighInNew),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
