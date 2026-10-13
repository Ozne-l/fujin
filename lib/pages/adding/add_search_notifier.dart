import 'dart:async';

import 'package:fujin/app/providers.dart';
import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_food_service.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/pages/adding/add_search_state.dart';
import 'package:fujin/pages/scanner/scanner_exit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final NotifierProviderFamily<AddSearchNotifier, AddSearchState, ScannerSearch?>
addSearchProvider = NotifierProvider.autoDispose
    .family<AddSearchNotifier, AddSearchState, ScannerSearch?>(
      AddSearchNotifier.new,
    );

final class AddSearchNotifier extends Notifier<AddSearchState> {
  AddSearchNotifier(this.scan);

  static const typingPause = Duration(milliseconds: 400);

  final ScannerSearch? scan;
  Timer? _typing;

  @override
  AddSearchState build() {
    ref.onDispose(() => _typing?.cancel());
    final recents = ref.read(addFoodServiceProvider).recents();
    final query = scan?.query.trim() ?? '';
    if (query.isEmpty) {
      return AddSearchIdle(query: query, verifiedOnly: false, recents: recents);
    }
    _typing = Timer(Duration.zero, () => unawaited(search(query)));
    return AddSearchRunning(
      query: query,
      verifiedOnly: false,
      recents: recents,
    );
  }

  void refreshRecents() => state = state.copyWith(
    recents: ref.read(addFoodServiceProvider).recents(),
  );

  void type(String text) {
    _typing?.cancel();
    final query = text.trim();
    switch ((query, checkBarcode(query))) {
      case ('', _) || (_, MfpValidBarcode()):
        state = _idle(query);
      case _:
        state = _running(query);
        _typing = Timer(typingPause, () => unawaited(search(query)));
    }
  }

  Future<void> search(String text) async {
    _typing?.cancel();
    final query = text.trim();
    if (query.isEmpty) {
      state = _idle(query);
      return;
    }
    final running = _running(query);
    state = running;
    try {
      final foods = await ref
          .read(addFoodServiceProvider)
          .search(query, verifiedOnly: running.verifiedOnly);
      if (ref.mounted && state == running) {
        state = AddSearchResults(
          query: query,
          verifiedOnly: running.verifiedOnly,
          recents: running.recents,
          foods: foods,
        );
      }
    } on Object catch (error) {
      if (ref.mounted && state == running) state = _failed(running, error);
    }
  }

  Future<void> verifiedOnly({required bool only}) async {
    final query = state.query;
    state = _idle(query, verifiedOnly: only);
    if (query.isNotEmpty) await search(query);
  }

  Future<MfpFood?> lookUp() => _fetch(
    (service, query) => service.byBarcode(query),
    (idle, result) => switch (result) {
      MfpBarcodeFound(:final food) => (idle, food),
      MfpBarcodeUnknown() || MfpBarcodeUnresolved() => (
        _missing(idle, result),
        null,
      ),
    },
  );

  Future<AddDraft?> reopen(
    RecentFood recent, {
    required String mfpMealName,
    required DateTime date,
  }) => _fetch(
    (service, _) =>
        service.reopen(recent, mfpMealName: mfpMealName, date: date),
    (idle, draft) => switch (draft) {
      final draft? => (idle, draft),
      null => (
        _failed(
          idle,
          StateError('Recent food ${recent.mfpFoodId} cannot be reopened'),
        ),
        null,
      ),
    },
  );

  Future<T?> _fetch<R, T>(
    Future<R> Function(AddFoodService service, String query) fetch,
    (AddSearchState, T?) Function(AddSearchIdle idle, R result) settle,
  ) async {
    _typing?.cancel();
    final idle = _idle(state.query);
    final running = _running(idle.query);
    state = running;
    try {
      final result = await fetch(ref.read(addFoodServiceProvider), idle.query);
      if (!ref.mounted || state != running) return null;
      final (settled, value) = settle(idle, result);
      state = settled;
      return value;
    } on Object catch (error) {
      if (ref.mounted && state == running) state = _failed(running, error);
      return null;
    }
  }

  static AddBarcodeMissing _missing(
    AddSearchIdle idle,
    MfpBarcodeResult result,
  ) => AddBarcodeMissing(
    query: idle.query,
    verifiedOnly: idle.verifiedOnly,
    recents: idle.recents,
    result: result,
  );

  AddSearchIdle _idle(String query, {bool? verifiedOnly}) => AddSearchIdle(
    query: query,
    verifiedOnly: verifiedOnly ?? state.verifiedOnly,
    recents: state.recents,
  );

  AddSearchRunning _running(String query) => AddSearchRunning(
    query: query,
    verifiedOnly: state.verifiedOnly,
    recents: state.recents,
  );

  static AddSearchFailed _failed(AddSearchState running, Object error) =>
      AddSearchFailed(
        query: running.query,
        verifiedOnly: running.verifiedOnly,
        recents: running.recents,
        problem: ReadProblem.of(error),
        statusCode: switch (error) {
          MfpApiException(:final statusCode) ||
          MfpUnexpectedResponseException(:final statusCode) => statusCode,
          _ => null,
        },
      );
}
