import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/memory/memory_rules.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/seigaiha_band.dart';
import 'package:fujin/pages/common/text_inset.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:fujin/pages/memory/memory_segment.dart';
import 'package:fujin/pages/memory/widgets/meal_mappings_card.dart';
import 'package:fujin/pages/memory/widgets/memory_empty_view.dart';
import 'package:fujin/pages/memory/widgets/memory_search_field.dart';
import 'package:fujin/pages/memory/widgets/memory_segments.dart';
import 'package:fujin/pages/memory/widgets/remembered_food_list.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryPage extends HookConsumerWidget {
  const MemoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final memory = ref.watch(memoryProvider);
    final segment = useState(MemorySegment.foods);
    final search = useTextEditingController();
    useListenable(search);
    final remembered = memory.matches.length + memory.ownCopies.length;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                const SizedBox(height: FujinSpace.s3),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FujinSize.textInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: FujinSpace.s3,
                    children: [
                      Text(
                        l10n.tabMemory,
                        style: FujinText.hina30.copyWith(
                          color: FujinColorRole.textPrimary,
                        ),
                      ),
                      Text(
                        l10n.memorySubtitle,
                        style: FujinText.inter15Regular.copyWith(
                          color: FujinColorRole.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FujinSize.screenMargin,
                    FujinSpace.s3,
                    FujinSize.screenMargin,
                    FujinSpace.s4,
                  ),
                  child: MemorySegments(
                    selected: segment.value,
                    labelOf: (value) => switch (value) {
                      MemorySegment.foods => l10n.memoryFoods(remembered),
                      MemorySegment.meals => l10n.memoryMeals(
                        memory.meals.length,
                      ),
                    },
                    onSelect: (value) => segment.value = value,
                  ),
                ),
              ],
            ),
            ...switch ((segment.value, remembered)) {
              (MemorySegment.foods, 0) => [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: FujinSpace.s8 + FujinSpace.s4,
                          bottom: FujinSpace.s8,
                        ),
                        child: MemoryEmptyView(),
                      ),
                      const Spacer(),
                      const SeigaihaBand(),
                      SizedBox(height: FujinSpace.s8 + bottom),
                    ],
                  ),
                ),
              ],
              (MemorySegment.foods, _) => [
                SliverList.list(
                  children: _foods(
                    context,
                    memory,
                    search,
                    (food) => unawaited(
                      context.push<void>(FujinRoute.memoryFood.forFood(food)),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: FujinSpace.s8 + bottom),
                ),
              ],
              (MemorySegment.meals, _) => [
                SliverToBoxAdapter(
                  child: _MealsSection(
                    memory: memory,
                    onChange: ref.read(memoryProvider.notifier).saveMeal,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: FujinSpace.s8 + bottom),
                ),
              ],
            },
          ],
        ),
      ),
    );
  }

  static List<Widget> _foods(
    BuildContext context,
    Memory memory,
    TextEditingController search,
    ValueChanged<RememberedFood> onOpen,
  ) {
    final foods = rememberedFoods(memory, search.text);
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(
          FujinSize.screenMargin,
          0,
          FujinSize.screenMargin,
          FujinSpace.s4,
        ),
        child: MemorySearchField(controller: search),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
        child: switch (foods) {
          [] => TextInset(
            child: Text(
              AppLocalizations.of(context).memorySearchEmpty,
              style: FujinText.inter13Regular.copyWith(
                color: FujinColorRole.textSecondary,
              ),
            ),
          ),
          _ => RememberedFoodList(
            foods: foods,
            unitsOf: memory.unitsOf,
            onOpen: onOpen,
          ),
        },
      ),
    ];
  }
}

class _MealsSection extends ConsumerWidget {
  const _MealsSection({required this.memory, required this.onChange});

  final Memory memory;
  final ValueChanged<MealMapping> onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = switch (ref.watch(ekkloMealNamesProvider)) {
      AsyncData(:final value) => value,
      AsyncValue() => const <String>[],
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s4,
        children: [
          MealMappingsCard(
            meals: memory.meals,
            choices: mealChoices(memory, history),
            onChange: onChange,
          ),
          TextInset(
            child: Text(
              AppLocalizations.of(context).memoryMealsNote,
              style: FujinText.inter13Regular.copyWith(
                color: FujinColorRole.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
