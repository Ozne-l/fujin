import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

final memoryProvider = NotifierProvider<MemoryNotifier, Memory>(
  MemoryNotifier.new,
);

final FutureProviderFamily<EkkloFood, String> ekkloFoodProvider = FutureProvider
    .autoDispose
    .family<EkkloFood, String>(
      (ref, ekkloFoodId) =>
          ref.watch(memoryServiceProvider).ekkloFood(ekkloFoodId),
    );

final FutureProvider<List<String>> ekkloMealNamesProvider =
    FutureProvider.autoDispose<List<String>>(
      (ref) => ref.watch(memoryServiceProvider).ekkloMealNames(),
    );

final class MemoryNotifier extends Notifier<Memory> {
  @override
  Memory build() => ref.watch(memoryServiceProvider).load();

  void reload() => state = ref.read(memoryServiceProvider).load();

  void forget(RememberedFood food) {
    ref.read(memoryServiceProvider).forget(food);
    reload();
  }

  void saveUnit(RememberedUnit unit) {
    ref.read(memoryServiceProvider).saveUnit(unit);
    reload();
  }

  void saveMeal(MealMapping meal) {
    ref.read(memoryServiceProvider).saveMeal(meal);
    reload();
  }

  void associate(RememberedFood food, EkkloFood ekkloFood) {
    ref.read(memoryServiceProvider).associate(food, ekkloFood);
    reload();
  }
}
