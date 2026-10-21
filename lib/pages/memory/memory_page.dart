import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/app/theme/instant_motion.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/memory/memory_rules.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/appearance_corner.dart';
import 'package:fujin/pages/common/appearance_header.dart';
import 'package:fujin/pages/common/fujin_segments.dart';
import 'package:fujin/pages/common/header_layout.dart';
import 'package:fujin/pages/common/scroll_edge_blur.dart';
import 'package:fujin/pages/common/seigaiha_band.dart';
import 'package:fujin/pages/common/text_inset.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:fujin/pages/memory/memory_segment.dart';
import 'package:fujin/pages/memory/widgets/meal_mappings_card.dart';
import 'package:fujin/pages/memory/widgets/memory_empty_view.dart';
import 'package:fujin/pages/memory/widgets/memory_search_field.dart';
import 'package:fujin/pages/memory/widgets/remembered_food_list.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryPage extends HookConsumerWidget {
  const MemoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memory = ref.watch(memoryProvider);
    final pages = usePageController();
    final search = useTextEditingController();
    useListenable(search);
    final remembered = memory.matches.length + memory.ownCopies.length;
    final bottom = MediaQuery.paddingOf(context).bottom;

    Widget page(MemorySegment segment, double top) => ScrollEdgeBlur(
      top: top,
      child: CustomScrollView(
        key: PageStorageKey(segment),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: top)),
          ...switch ((segment, remembered)) {
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
    );

    return Scaffold(
      body: AppearanceCorner(
        child: HeaderLayout(
          header: HeaderLayout.shield(
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FujinSize.screenMargin,
                    ),
                    child: AppearanceHeader(
                      firstLine: FujinText.hina30,
                      child: TextInset(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: FujinSpace.s3,
                          children: [
                            Text(
                              context.intl.tabMemory,
                              style: FujinText.hina30.copyWith(
                                color: context.colors.textPrimary,
                              ),
                            ),
                            Text(
                              context.intl.memorySubtitle,
                              style: FujinText.inter15Regular.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      FujinSize.screenMargin,
                      FujinSpace.s3 - FujinSegments.outset,
                      FujinSize.screenMargin,
                      FujinSpace.s3 - FujinSegments.outset,
                    ),
                    child: ListenableBuilder(
                      listenable: pages,
                      builder: (context, _) => FujinSegments(
                        position: _page(pages),
                        motion: const InstantMotion(),
                        labels: [
                          for (final segment in MemorySegment.values)
                            switch (segment) {
                              MemorySegment.foods => context.intl.memoryFoods(
                                remembered,
                              ),
                              MemorySegment.meals => context.intl.memoryMeals(
                                memory.meals.length,
                              ),
                            },
                        ],
                        onSelect: (index, _) => unawaited(
                          FujinMotion.turnPage(context, pages, index),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: (context, extent) => PageView(
            controller: pages,
            children: [
              for (final segment in MemorySegment.values)
                switch (_searches(segment, remembered)) {
                  true => Stack(
                    fit: StackFit.expand,
                    children: [
                      page(segment, extent + _searchArea),
                      PositionedDirectional(
                        top: extent + FujinSpace.s3,
                        start: FujinSize.screenMargin,
                        end: FujinSize.screenMargin,
                        child: MemorySearchField(controller: search),
                      ),
                    ],
                  ),
                  false => page(segment, extent + FujinSpace.s3),
                },
            ],
          ),
        ),
      ),
    );
  }

  static const double _searchArea =
      FujinSpace.s3 + FujinSize.searchField + FujinSpace.s4;

  static bool _searches(MemorySegment segment, int remembered) =>
      switch ((segment, remembered)) {
        (MemorySegment.foods, 0) || (MemorySegment.meals, _) => false,
        (MemorySegment.foods, _) => true,
      };

  static double _page(PageController pages) => switch (pages.hasClients) {
    true when pages.position.hasContentDimensions =>
      pages.page ?? pages.initialPage.toDouble(),
    _ => pages.initialPage.toDouble(),
  };

  static List<Widget> _foods(
    BuildContext context,
    Memory memory,
    TextEditingController search,
    ValueChanged<RememberedFood> onOpen,
  ) {
    final foods = rememberedFoods(memory, search.text);
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
        child: switch (foods) {
          [] => TextInset(
            child: Text(
              context.intl.memorySearchEmpty,
              style: FujinText.inter13Regular.copyWith(
                color: context.colors.textSecondary,
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
              context.intl.memoryMealsNote,
              style: FujinText.inter13Regular.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
