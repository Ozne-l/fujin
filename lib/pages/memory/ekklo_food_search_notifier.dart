import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/app/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

final AsyncNotifierProviderFamily<
  EkkloFoodSearchNotifier,
  List<EkkloFood>,
  String
>
ekkloFoodSearchProvider = AsyncNotifierProvider.autoDispose
    .family<EkkloFoodSearchNotifier, List<EkkloFood>, String>(
      EkkloFoodSearchNotifier.new,
    );

final class EkkloFoodSearchNotifier extends AsyncNotifier<List<EkkloFood>> {
  EkkloFoodSearchNotifier(this.initialTerms);

  final String initialTerms;
  String _terms = '';

  @override
  Future<List<EkkloFood>> build() {
    _terms = initialTerms;
    return _search(initialTerms);
  }

  Future<void> search(String text) async {
    final terms = text.trim();
    if (terms.isEmpty) return;
    _terms = terms;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => _search(terms));
    if (ref.mounted && _terms == terms) state = result;
  }

  Future<List<EkkloFood>> _search(String terms) async => switch (terms) {
    '' => const [],
    _ => await ref.read(memoryServiceProvider).search(terms),
  };
}
