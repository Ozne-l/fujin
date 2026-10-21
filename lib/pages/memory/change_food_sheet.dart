import 'dart:async';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/sheet_frame.dart';
import 'package:fujin/pages/memory/ekklo_food_search_notifier.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:fujin/pages/memory/memory_text.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:fujin/pages/sending/sheets/candidate_card.dart';
import 'package:fujin/pages/sending/sheets/sheet_message.dart';
import 'package:fujin/pages/sending/sheets/sheet_searching.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showChangeFoodSheet(
  BuildContext context, {
  required RememberedFood food,
}) => SheetFrame.show(context, builder: (_) => _ChangeFoodSheet(food: food));

class _ChangeFoodSheet extends HookConsumerWidget {
  const _ChangeFoodSheet({required this.food});

  final RememberedFood food;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terms = descriptionTerms(food.mfpDescription);
    final search = ref.watch(ekkloFoodSearchProvider(terms));
    final picked = useState(food.ekkloFoodId);
    final results = switch (search) {
      AsyncData(:final value) => value,
      AsyncValue() => const <EkkloFood>[],
    };
    final selected = results
        .where((candidate) => candidate.id == picked.value)
        .firstOrNull;
    final navigator = Navigator.of(context);

    return SheetFrame(
      title: food.mfpDescription,
      subtitle: context.intl.memoryChangeSubtitle,
      initialQuery: terms,
      onSearch: (text) => unawaited(
        ref.read(ekkloFoodSearchProvider(terms).notifier).search(text),
      ),
      sectionLabel: context.intl.ekkloCandidates,
      body: switch (search) {
        AsyncError(:final error) => [
          SheetMessage(
            text: switch (SendFailure.of(
              error,
              ref.read(appEnvironmentProvider),
            )) {
              SendFailure.network => context.intl.searchFailedNetwork,
              SendFailure.ekkloSession ||
              SendFailure.mfpSession ||
              SendFailure.refused ||
              SendFailure.blockedInDev ||
              SendFailure.other => context.intl.searchFailedOther,
            },
            color: context.colors.textAlert,
          ),
        ],
        AsyncData(value: []) => [
          SheetMessage(
            text: context.intl.noEkkloResult,
            color: context.colors.textSecondary,
          ),
        ],
        AsyncData(:final value) => [
          for (final candidate in value)
            CandidateCard(
              selected: candidate == selected,
              onTap: () => picked.value = candidate.id,
              child: _Candidate(food: candidate),
            ),
        ],
        AsyncValue() => [const SheetSearching()],
      },
      primaryLabel: context.intl.associateAndRemember,
      onPrimary: switch (selected) {
        final candidate? => () {
          ref.read(memoryProvider.notifier).associate(food, candidate);
          navigator.pop();
        },
        null => null,
      },
    );
  }
}

class _Candidate extends StatelessWidget {
  const _Candidate({required this.food});

  final EkkloFood food;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FujinSpace.s1,
      children: [
        Text(
          food.name,
          style: FujinText.inter15Medium.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        if (food.brands case final brands?)
          Text(
            brands,
            style: FujinText.inter12Regular.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        Text(
          context.intl.memoryEnergyPer(
            context.intl.kilocalories(food.calories),
            MemoryText.portion(context.intl, food),
          ),
          style: FujinText.inter12Medium.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
      ],
    );
  }
}
