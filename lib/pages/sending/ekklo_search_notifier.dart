import 'dart:async';

import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:fujin/pages/sending/ekklo_search_state.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

final NotifierProviderFamily<
  EkkloSearchNotifier,
  EkkloSearchState,
  PlannedEntry
>
ekkloSearchProvider = NotifierProvider.autoDispose
    .family<EkkloSearchNotifier, EkkloSearchState, PlannedEntry>(
      EkkloSearchNotifier.new,
    );

final class EkkloSearchNotifier extends Notifier<EkkloSearchState> {
  EkkloSearchNotifier(this.planned);

  final PlannedEntry planned;

  @override
  EkkloSearchState build() {
    final query = searchTerms(planned.entry.food);
    final service = ref.watch(sendServiceProvider);
    return switch (planned.candidates) {
      [] when query.isNotEmpty => _started(service, query),
      [] => EkkloSearchState(query: query, results: const []),
      final candidates => EkkloSearchState(query: query, results: candidates),
    };
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    state = EkkloSearchState(query: trimmed);
    await _run(ref.read(sendServiceProvider), trimmed);
  }

  EkkloSearchState _started(SendService service, String query) {
    unawaited(Future(() => _run(service, query)));
    return EkkloSearchState(query: query);
  }

  Future<void> _run(SendService service, String query) async {
    try {
      final results = await service.search(planned, query);
      if (ref.mounted && state.query == query) {
        state = EkkloSearchState(query: query, results: results);
      }
    } on Object catch (error) {
      if (ref.mounted && state.query == query) {
        state = EkkloSearchState(
          query: query,
          failure: SendFailure.of(error, ref.read(appEnvironmentProvider)),
        );
      }
    }
  }
}
