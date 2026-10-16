import 'dart:async';

import 'package:fujin/app/providers.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_food_service.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/memory/memory_rules.dart';
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
  Memory _memory = const Memory();

  @override
  AddSearchState build() {
    ref.onDispose(() => _typing?.cancel());
    final service = ref.read(addFoodServiceProvider);
    _memory = service.memory();
    final recents = service.recents();
    final query = scan?.query.trim() ?? '';
    final remembered = rememberedFoods(_memory, query);
    if (query.isEmpty) {
      return AddSearchIdle(
        query: query,
        verifiedOnly: false,
        recents: recents,
        remembered: remembered,
      );
    }
    _typing = Timer(Duration.zero, () => unawaited(search(query)));
    return AddSearchRunning(
      query: query,
      verifiedOnly: false,
      recents: recents,
      remembered: remembered,
    );
  }

  void refreshRecents() {
    final service = ref.read(addFoodServiceProvider);
    _memory = service.memory();
    state = state.copyWith(
      recents: service.recents(),
      remembered: rememberedFoods(_memory, state.query),
    );
  }

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
      if (ref.mounted && identical(state, running)) {
        state = AddSearchResults(
          query: query,
          verifiedOnly: running.verifiedOnly,
          recents: running.recents,
          remembered: running.remembered,
          foods: foods,
        );
      }
    } on Object catch (error) {
      if (ref.mounted && identical(state, running)) {
        state = _failed(running, error);
      }
    }
  }

  Future<void> verifiedOnly({required bool only}) async {
    final query = state.query;
    state = _idle(query, verifiedOnly: only);
    if (query.isNotEmpty) await search(query);
  }

  Future<MfpFood?> lookUp() => _fetch(
    (service, query) => service.byBarcode(query),
    (before, result) => switch (result) {
      MfpBarcodeFound(:final food) => (before, food),
      MfpBarcodeUnknown() || MfpBarcodeUnresolved() => (
        _missing(before, result),
        null,
      ),
    },
  );

  Future<AddDraft?> reopen(
    RecentFood recent, {
    required String mfpMealName,
    required DateTime date,
  }) => _open(
    (service) => service.reopen(recent, mfpMealName: mfpMealName, date: date),
    unopened: 'Recent food ${recent.mfpFoodId} cannot be reopened',
  );

  Future<AddDraft?> openRemembered(
    RememberedFood remembered, {
    required String mfpMealName,
    required DateTime date,
  }) => _open(
    (service) => service.openRemembered(
      remembered,
      mfpMealName: mfpMealName,
      date: date,
    ),
    unopened: 'Remembered food ${remembered.mfpFoodId} cannot be opened',
  );

  Future<AddDraft?> _open(
    Future<AddDraft?> Function(AddFoodService service) open, {
    required String unopened,
  }) => _fetch(
    (service, _) => open(service),
    (before, draft) => switch (draft) {
      final draft? => (before, draft),
      null => (_failed(before, StateError(unopened)), null),
    },
  );

  Future<T?> _fetch<R, T>(
    Future<R> Function(AddFoodService service, String query) fetch,
    (AddSearchState, T?) Function(AddSearchState before, R result) settle,
  ) async {
    _typing?.cancel();
    final before = switch (state) {
      final AddSearchResults results => results,
      _ => _idle(state.query),
    };
    final running = _running(before.query);
    state = running;
    try {
      final result = await fetch(
        ref.read(addFoodServiceProvider),
        before.query,
      );
      if (!ref.mounted || !identical(state, running)) return null;
      final (settled, value) = settle(before, result);
      state = settled;
      return value;
    } on Object catch (error) {
      if (ref.mounted && identical(state, running)) {
        state = _failed(running, error);
      }
      return null;
    }
  }

  static AddBarcodeMissing _missing(
    AddSearchState before,
    MfpBarcodeResult result,
  ) => AddBarcodeMissing(
    query: before.query,
    verifiedOnly: before.verifiedOnly,
    recents: before.recents,
    remembered: before.remembered,
    result: result,
  );

  AddSearchIdle _idle(String query, {bool? verifiedOnly}) => AddSearchIdle(
    query: query,
    verifiedOnly: verifiedOnly ?? state.verifiedOnly,
    recents: state.recents,
    remembered: rememberedFoods(_memory, query),
  );

  AddSearchRunning _running(String query) => AddSearchRunning(
    query: query,
    verifiedOnly: state.verifiedOnly,
    recents: state.recents,
    remembered: rememberedFoods(_memory, query),
  );

  static AddSearchFailed _failed(AddSearchState running, Object error) =>
      AddSearchFailed(
        query: running.query,
        verifiedOnly: running.verifiedOnly,
        recents: running.recents,
        remembered: running.remembered,
        problem: ReadProblem.of(error),
        statusCode: switch (error) {
          MfpApiException(:final statusCode) ||
          MfpUnexpectedResponseException(:final statusCode) => statusCode,
          _ => null,
        },
      );
}
