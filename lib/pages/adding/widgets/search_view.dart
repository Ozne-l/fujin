import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/adding/add_search_notifier.dart';
import 'package:fujin/pages/adding/add_search_state.dart';
import 'package:fujin/pages/adding/add_text.dart';
import 'package:fujin/pages/adding/widgets/add_chip.dart';
import 'package:fujin/pages/adding/widgets/add_search_field.dart';
import 'package:fujin/pages/adding/widgets/add_section_label.dart';
import 'package:fujin/pages/adding/widgets/add_state_panel.dart';
import 'package:fujin/pages/adding/widgets/barcode_card.dart';
import 'package:fujin/pages/adding/widgets/food_list.dart';
import 'package:fujin/pages/adding/widgets/offline_card.dart';
import 'package:fujin/pages/adding/widgets/open_draft.dart';
import 'package:fujin/pages/adding/widgets/scanned_banner.dart';
import 'package:fujin/pages/adding/widgets/suggestion_row.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/flow_header.dart';
import 'package:fujin/pages/common/glass_layer.dart';
import 'package:fujin/pages/common/scan_button.dart';
import 'package:fujin/pages/common/scan_icon.dart';
import 'package:fujin/pages/common/title_text.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/scanner/scanner_exit.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class SearchView extends HookConsumerWidget {
  const SearchView({
    required this.date,
    required this.mfpMealName,
    required this.onOpen,
    required this.onScan,
    this.scan,
    super.key,
  });

  static const _wordSeparator = ' ';

  final DateTime date;
  final String mfpMealName;
  final OpenDraft onOpen;
  final VoidCallback onScan;
  final ScannerSearch? scan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(addSearchProvider(scan));
    final notifier = ref.read(addSearchProvider(scan).notifier);
    final recents = search.recents;
    final today = ref.watch(todayProvider);
    final query = useTextEditingController(text: search.query);
    useListenable(query);
    final barcode = switch ((search, checkBarcode(search.query))) {
      (
        AddSearchIdle() || AddSearchRunning() || AddSearchFailed(),
        final MfpValidBarcode valid,
      ) =>
        valid,
      _ => null,
    };

    void searchText(String text) {
      query.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
      unawaited(notifier.search(text));
    }

    void open(MfpFood food, {String? barcode}) {
      if (AddDraft.of(food, mfpMealName: mfpMealName, date: date)
          case final draft?) {
        onOpen(draft, barcode: barcode);
      }
    }

    Future<void> reopen(RecentFood recent) async {
      if (await notifier.reopen(recent, mfpMealName: mfpMealName, date: date)
          case final draft?) {
        onOpen(draft);
      }
    }

    Future<void> openRemembered(RememberedFood remembered) async {
      if (await notifier.openRemembered(
            remembered,
            mfpMealName: mfpMealName,
            date: date,
          )
          case final draft?) {
        onOpen(draft);
      }
    }

    Future<void> lookUp(String code) async {
      if (await notifier.lookUp() case final food?) open(food, barcode: code);
    }

    void retry() => switch (barcode) {
      final barcode? => unawaited(lookUp(barcode.barcode)),
      null => unawaited(notifier.search(search.query)),
    };

    Future<void> signIn() async {
      final signedIn = await context.push<bool>(FujinRoute.mfpSignIn.path);
      if (signedIn case true) await notifier.search(search.query);
    }

    List<Widget> recentList(String trailing) => [
      _box(AddSectionLabel(label: context.intl.addRecents, trailing: trailing)),
      switch (recents) {
        [] => _box(_note(context.intl.addRecentsEmpty)),
        _ => FoodList(
          rows: [
            for (final recent in recents)
              (
                title: recent.description,
                detail: AddText.recent(context.intl, recent, today: today),
                verified: false,
                energy: switch (recent.kilocalories) {
                  final energy? => context.intl.kilocalories(energy),
                  null => null,
                },
                onTap: () => unawaited(reopen(recent)),
              ),
          ],
        ),
      },
    ];

    List<Widget> rememberedList(List<RememberedFood> foods) => switch (foods) {
      [] => const [],
      _ => [
        _box(
          AddSectionLabel(
            label: context.intl.addRememberedFoods,
            trailing: switch (search.query) {
              '' => context.intl.addRememberedLinked,
              _ => context.intl.addRememberedFound(foods.length),
            },
            dot: FujinColorRole.sourceEkklo,
          ),
        ),
        FoodList(
          rows: [
            for (final food in foods)
              (
                title: food.mfpDescription,
                detail: AddText.remembered(context.intl, food),
                verified: false,
                energy: null,
                onTap: () => unawaited(openRemembered(food)),
              ),
          ],
        ),
        if (search.query.isEmpty) _box(_note(context.intl.addRememberedNote)),
      ],
    };

    final body = switch (search) {
      AddSearchIdle() || AddSearchRunning() when barcode != null => [
        _box(
          BarcodeCard(
            format: AddText.barcodeFormat(barcode.format),
            running: search is AddSearchRunning,
            onTap: () => unawaited(lookUp(barcode.barcode)),
          ),
        ),
        _box(
          Center(
            child: TextButton(
              onPressed: () => searchText(barcode.barcode),
              child: Text(context.intl.addSearchAsText(barcode.barcode)),
            ),
          ),
        ),
      ],
      AddSearchIdle(:final rememberedBesideRecents) => [
        ...recentList(context.intl.addRecentsAddedFromFujin),
        if (recents.isNotEmpty) _box(_note(context.intl.addRecentsNote)),
        ...rememberedList(rememberedBesideRecents),
      ],
      AddSearchRunning(:final query, :final remembered) => [
        if (query.isNotEmpty) ...rememberedList(remembered),
        _box(
          AddSectionLabel(
            label: context.intl.addMfpResults,
            trailing: context.intl.addSearching,
            dot: FujinColorRole.sourceMfp,
          ),
        ),
      ],
      AddSearchResults(foods: [], :final remembered) => [
        ...rememberedList(remembered),
        _box(
          AddStatePanel(
            icon: Icons.search,
            title: context.intl.addNoResultTitle,
            detail: context.intl.addNoResultDetail,
          ),
        ),
        ..._suggestions(
          context.intl,
          search,
          searchText,
          notifier,
        ).map(_box),
      ],
      AddSearchResults(
        :final foods,
        :final remembered,
        :final foodsBesideRemembered,
      ) =>
        [
          ...rememberedList(remembered),
          if (foodsBesideRemembered.isNotEmpty) ...[
            _box(
              AddSectionLabel(
                label: context.intl.addMfpResults,
                trailing: switch (foods.length) {
                  MfpFoods.defaultMaxResults => context.intl.addFirstResults(
                    foods.length,
                  ),
                  _ => context.intl.addResultCount(
                    foodsBesideRemembered.length,
                  ),
                },
                dot: FujinColorRole.sourceMfp,
              ),
            ),
            FoodList(
              rows: [
                for (final food in foodsBesideRemembered)
                  (
                    title: food.description,
                    detail: AddText.result(context.intl, food),
                    verified: food.verified ?? false,
                    energy: switch (AddText.kilocalories(food)) {
                      final energy? => context.intl.kilocalories(energy),
                      null => null,
                    },
                    onTap: () => open(food),
                  ),
              ],
            ),
          ],
        ],
      AddBarcodeMissing(
        result: MfpBarcodeUnresolved(:final description, :final brandName),
      ) =>
        [_box(_unresolved(context.intl, description, brandName, searchText))],
      AddBarcodeMissing(:final result) => [
        _box(
          AddStatePanel(
            icon: Icons.qr_code_2,
            title: context.intl.addBarcodeUnknownTitle,
            detail: context.intl.addBarcodeUnknownDetail(result.barcode),
          ),
        ),
      ],
      AddSearchFailed(
        problem: ReadProblem.offline,
        :final rememberedBesideRecents,
      ) =>
        [
          _box(OfflineCard(onRetry: retry)),
          ...recentList(context.intl.addRecentsOnPhone),
          ...rememberedList(rememberedBesideRecents),
        ],
      AddSearchFailed(
        problem: ReadProblem.mfpSessionExpired,
        :final remembered,
      ) =>
        [
          _box(
            AddStatePanel(
              icon: Icons.lock_outline,
              alert: true,
              title: context.intl.addMfpSessionTitle,
              detail: context.intl.addMfpSessionSearchDetail,
              actionIcon: Icons.login,
              action: (context.intl.mfpReconnect, () => unawaited(signIn())),
            ),
          ),
          ...rememberedList(remembered),
        ],
      AddSearchFailed(:final problem, :final statusCode, :final remembered) => [
        _box(
          AddStatePanel(
            icon: Icons.dns_outlined,
            alert: true,
            title: switch (problem) {
              ReadProblem.mfpUnavailable => context.intl.addServerTitle,
              ReadProblem.offline ||
              ReadProblem.mfpSessionExpired ||
              ReadProblem.ekkloSessionExpired ||
              ReadProblem.ekkloUnavailable ||
              ReadProblem.unknown => JournalText.problemHeadline(
                context.intl,
                problem,
              ),
            },
            detail: context.intl.addServerDetail,
            action: (context.intl.tryAgain, retry),
            note: switch (statusCode) {
              final code? => context.intl.addServerCode(code),
              null => null,
            },
          ),
        ),
        ...rememberedList(remembered),
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlowHeader(
          title: mfpMealName,
          subtitle: TitleText.capitalized(context.intl.journalDay(date)),
          onBack: () => context.pop(),
        ),
        AddSearchField(
          controller: query,
          onChanged: notifier.type,
          onSubmitted: (text) => unawaited(notifier.search(text)),
          onClear: () {
            query.clear();
            notifier.type('');
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            FujinSize.screenMargin,
            FujinSpace.s3,
            FujinSize.screenMargin,
            FujinSpace.s4,
          ),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: switch (barcode) {
              final barcode? => AddChip(
                label: context.intl.addBarcodeChip(
                  AddText.barcodeFormat(barcode.format),
                ),
                selected: true,
                icon: SvgPicture.asset(
                  ScanIcon.asset,
                  width: FujinSize.searchIcon,
                  height: FujinSize.searchIcon,
                  theme: const SvgTheme(currentColor: FujinColorRole.textLink),
                ),
              ),
              null => AddChip(
                label: context.intl.addVerifiedOnly,
                selected: search.verifiedOnly,
                icon: switch (search.verifiedOnly) {
                  true => const Icon(Icons.check),
                  false => null,
                },
                onTap: () => unawaited(
                  notifier.verifiedOnly(only: !search.verifiedOnly),
                ),
              ),
            },
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom:
                          FujinSpace.s3 +
                          FujinSize.tabBar +
                          FujinSpace.s6 +
                          MediaQuery.paddingOf(context).bottom,
                    ),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        for (final (index, child) in [
                          if (scan case ScannerSearch(unresolved: true))
                            _box(const ScannedBanner()),
                          ...body,
                        ].indexed) ...[
                          if (index > 0) _gap,
                          child,
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              PositionedDirectional(
                end: FujinSpace.s5,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(bottom: FujinSpace.s6),
                  child: GlassLayer(child: ScanButton(onTap: onScan)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static const _gap = SliverToBoxAdapter(
    child: SizedBox(height: FujinSpace.s3),
  );

  static Widget _box(Widget child) => SliverToBoxAdapter(child: child);

  static Widget _note(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: FujinSize.textInset),
    child: Text(
      text,
      style: FujinText.inter12Regular.copyWith(
        color: FujinColorRole.textSecondary,
      ),
    ),
  );

  static Widget _unresolved(
    AppLocalizations intl,
    String description,
    String? brandName,
    ValueChanged<String> searchText,
  ) {
    final text = [description, ?brandName].join(_wordSeparator);
    return AddStatePanel(
      icon: Icons.qr_code_2,
      title: intl.addBarcodeUnresolvedTitle,
      detail: intl.addBarcodeUnresolvedDetail(
        EntryText.branded(intl, brandName, description),
      ),
      actionIcon: Icons.search,
      action: (intl.addSearchQuoted(text), () => searchText(text)),
    );
  }

  static List<Widget> _suggestions(
    AppLocalizations intl,
    AddSearchState search,
    ValueChanged<String> searchText,
    AddSearchNotifier notifier,
  ) {
    final words = search.query.split(_wordSeparator);
    final shorter = words.take(words.length - 1).join(_wordSeparator);
    final rows = [
      if (shorter.isNotEmpty)
        SuggestionRow(
          icon: Icons.search,
          label: intl.addShorten(shorter),
          onTap: () => searchText(shorter),
        ),
      if (search.verifiedOnly)
        SuggestionRow(
          icon: Icons.check,
          label: intl.addIncludeUnverified,
          onTap: () => unawaited(notifier.verifiedOnly(only: false)),
        ),
    ];
    return [
      if (rows.isNotEmpty) AddSectionLabel(label: intl.addTryInstead),
      ...rows,
    ];
  }
}
