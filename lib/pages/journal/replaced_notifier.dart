import 'package:fujin/domain/comparison/replacement.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<ReplacedNotifier, List<Replacement>> replacedProvider =
    NotifierProvider<ReplacedNotifier, List<Replacement>>(
      ReplacedNotifier.new,
    );

final class ReplacedNotifier extends Notifier<List<Replacement>> {
  @override
  List<Replacement> build() => const [];

  void settled(List<Replacement> replaced) {
    if (replaced.isNotEmpty) state = replaced;
  }
}
