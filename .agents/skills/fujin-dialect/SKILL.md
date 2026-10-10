---
name: fujin-dialect
description: Fūjin's Dart and Flutter house style. Load before writing or reviewing any Dart in this repo, or when asked about "code style", "conventions", "dialect", "how we write Dart here", "lint", "formatting", comments, null handling, switch versus if, models and dart_mappable, theme tokens or app copy and translations.
---

# Fūjin dialect

Write Dart the way the rest of `lib/` already reads: no comments, no `!`, no stray literals, `switch` everywhere a value has cases, generated mappers for every model, tokens and ARB strings for everything a user sees. The analyzer and formatter settle the rest.

Each rule: what to do, why, where the repo already does it.

## Rules

1. **Write no comments; let names and types say it.**
   Why: a comment is text the analyzer never checks, so it drifts from the code it describes.
   Example: no hand-written file under `lib/` carries a comment, even the densest one (`lib/domain/comparison/compare_day.dart`). The only `//` lines are generator headers, as in `lib/app/theme/fujin_tokens.g.dart`.

2. **Never use the `!` null assertion; pattern-match the nullable value instead.**
   Why: `!` moves a type error to runtime; a pattern makes the null branch visible and exhaustive.
   Example: `lib/pages/common/status_pill.dart` (`StatusPill.build`) and `lib/data/sessions/secure_ekklo_token_store.dart` (`SecureEkkloTokenStore.read`):
   ```dart
   if (icon case final icon?)
     Icon(icon, size: style.fontSize, color: tone.foreground),
   ```
   ```dart
   Future<EkkloTokens?> read() async =>
       switch (await _storage.read(key: _key.storageKey)) {
         null => null,
         final json => EkkloTokensMapper.fromJson(json),
       };
   ```

3. **Give every identifier-like string or number a name: an enum carrying the value, or a `static const`.**
   Why: one spelling, one place to change it, and the compiler finds every use.
   Examples: table names in `FujinTable` (`lib/data/database/fujin_table.dart`), secure storage keys in `SessionKey` (`lib/data/sessions/session_key.dart`), route paths in `FujinRoute` (`lib/app/fujin_route.dart`), conflict keys `MemoryRepository._mfpFoodId` (`lib/data/memory/memory_repository.dart`), `ExpectedItem.quantityTolerance` (`lib/domain/comparison/expected_item.dart`), `JournalPage._nothingNewDuration` (`lib/pages/journal/journal_page.dart`), `SelectedDay._daysPerWeek` (`lib/pages/journal/selected_day.dart`).
   ```dart
   enum FujinTable {
     memoryFood('memory_food'),
     memoryOwnCopy('memory_own_copy'),
     memoryUnit('memory_unit'),
     memoryMeal('memory_meal'),
     sentLink('sent_link');

     const FujinTable(this.sqlName);

     final String sqlName;
   }
   ```
   SQL statements themselves are written out in full inside their repository (`SentLinkRepository.forDate` in `lib/data/links/sent_link_repository.dart`); the values passed around in Dart are the ones that get names.

4. **Branch with `switch` expressions or statements, not if/else chains; keep them exhaustive, without `default`, on sealed types, enums and records.**
   Why: when a case is added (a new `EntryStatus`, a new lifecycle state), the compiler lists every place that must handle it (Dart language docs, dart.dev, "Patterns" and "Branches").
   Examples:
   - sealed type: `StatusCounts.of` over `EntryStatus` (`lib/domain/journal/status_counts.dart`), `MemoryRepository.saveFood` over `RememberedFood` (`lib/data/memory/memory_repository.dart`);
   - record: the link triage in `compareDay` switches on `(placements[link.ekkloItemId], entryIds.contains(link.mfpEntryId))` (`lib/domain/comparison/compare_day.dart`), `JournalNotifier.refresh` switches on `(before, next?.diary)` with a guard (`lib/pages/journal/journal_notifier.dart`);
   - enum, every value listed: the `AppLifecycleState` switch in `JournalPage.build` (`lib/pages/journal/journal_page.dart`).
   ```dart
   (counts, compared) => switch (compared.status) {
     InEkklo() => counts.copyWith(inEkklo: counts.inEkklo + 1),
     ToSend() => counts.copyWith(toSend: counts.toSend + 1),
     ToUpdate() => counts.copyWith(toUpdate: counts.toUpdate + 1),
   },
   ```
   A single `if (x case Pattern)` or an early `return` guard is fine (`if (!context.mounted) return;` in `JournalPage.build`).

5. **Return `null` for "nothing there"; no sentinel values, no option wrappers, no throwing for an expected miss.**
   Why: Dart's sound null safety already forces every caller to handle the miss.
   Examples: `ExpectedItem.forEntry` returns `null` when Memory cannot predict the Ekklo item (`lib/domain/comparison/expected_item.dart`); `Memory.food`, `Memory.gramsPerUnit`, `Memory.ekkloMealName` (`lib/data/memory/memory.dart`).

6. **Keep one public type per file, named after the file; a sealed family shares one file.**
   Why: the file tree is the type index. Dart requires the subtypes of a `sealed` class to live in its library.
   Examples: `lib/pages/journal/refresh_outcome.dart` holds only `RefreshOutcome`; `lib/domain/comparison/entry_status.dart` holds `EntryStatus` with `InEkklo`, `ToSend`, `ToUpdate`; `lib/data/memory/remembered_food.dart` holds `RememberedFood` with `MatchedFood`, `OwnCopy`. A provider sits in the file of the type it builds (`journalProvider` in `lib/pages/journal/journal_notifier.dart`). Helpers used by one file stay private there (`_Placement`, `_Orphan` in `lib/domain/comparison/compare_day.dart`).

7. **Inject collaborators through private initializing formals.**
   Why: the dependency stays private without a second field declaration or an initializer list.
   Example: `JournalService` (`lib/domain/journal/journal_service.dart`):
   ```dart
   const JournalService({
     required this._mfp,
     required this._ekklo,
     required this._links,
     required this._memory,
     required this._clock,
   });
   ```
   Positional form in repositories: `const SentLinkRepository(this._database);` (`lib/data/links/sent_link_repository.dart`).

8. **Declare classes `final class`; static holders `abstract final class`; unions `sealed class`.**
   Why: nothing outside the library can extend or implement them, so a change never breaks a subtype you did not know about (Dart class modifiers, dart.dev).
   Examples: `FujinDatabase` (`lib/data/database/fujin_database.dart`), `JournalNotifier` (`lib/pages/journal/journal_notifier.dart`), `Config` (`lib/app/config.dart`), `FujinTheme` (`lib/app/theme/fujin_theme.dart`), `EntryStatus`. Widgets are the exception and stay plain `class` (`JournalPage`, `StatusPill`).

9. **Make every model a `dart_mappable` class; sealed unions carry a discriminator key and one value per subtype.**
   Why: one generated encoding serves SQLite rows, equality, `copyWith` and test assertions. `build.yaml` sets `caseStyle: snakeCase` (so `mfpEntryId` maps to `mfp_entry_id`, the column name) and `ignoreNull: true`.
   Examples: `SentLink` (`lib/data/links/sent_link.dart`); `RememberedFood` uses `discriminatorKey: 'kind'` with `'ekklo'` and `'own_copy'`, the same values as the `CHECK` constraint in `lib/data/database/schema.dart`; `EntryStatus` uses `discriminatorKey: 'status'`; enums use `@MappableEnum()` (`UpdateKind` in `lib/domain/comparison/update_kind.dart`).
   ```dart
   @MappableClass(discriminatorKey: 'kind')
   sealed class RememberedFood with RememberedFoodMappable {
   ```
   Regenerate with `dart run build_runner build`; never edit a `*.mapper.dart`.

10. **Take every colour, size, spacing, radius, stroke and text style in a widget from the generated tokens.**
    Why: the design file `design/tokens/fujin.tokens.json` is the single source; literals drift from the mockups.
    Examples: `StatusPill` uses `FujinSize.pill`, `FujinSpace.s3`, `FujinRadius.pill`, `FujinText.inter12Medium` (`lib/pages/common/status_pill.dart`); `PillTone` pairs `FujinColorRole` colours (`lib/pages/common/pill_tone.dart`). Theme-wide defaults live in `FujinTheme.light()` (`lib/app/theme/fujin_theme.dart`). Regenerate `lib/app/theme/fujin_tokens.g.dart` with `dart run tool/generate_tokens.dart`, never by hand. Status pictograms (Figma component "Weather glyph": Calm, Breeze, Gust, Storm) are `FujinWeatherGlyph` with a `FujinWeather` (`lib/pages/common/fujin_weather_glyph.dart`, `lib/pages/common/fujin_weather.dart`), drawn from the moodboard SVGs in `assets/icons/weather/` with `flutter_svg`; never stand in a Material icon for them. Ornaments come from Figma exports too: `SeigaihaBand` repeats the `assets/images/seigaiha.png` tile (1x to 4x), `GoldVolute` draws `assets/icons/volute.svg` (`lib/pages/common/`). Motion follows the same idea: presets in `FujinMotion` (`lib/app/theme/fujin_motion.dart`), driven by `motor` (`SingleMotionBuilder` in `lib/pages/common/progress_bar.dart`), no hand-written `AnimationController`.

11. **Show copy only through `AppLocalizations`; add each string to `lib/l10n/app_fr.arb` (Figma wording, placeholder definitions) and its translation to `lib/l10n/app_en.arb`, with ICU plurals for counts.**
    Why: copy lives in one place per language, and plurals ("1 aliment", "2 aliments") are handled by gen-l10n, not string building ([ADR 0015](../../../docs/adr/0015-french-and-english-copy.md)). Write the English yourself from the French; the owner does not review translations.
    Examples: `AppLocalizations.of(context).mealsOfTheDay` in `JournalPage` (`lib/pages/journal/journal_page.dart`); `sendFoods` in `lib/l10n/app_fr.arb` renders "Envoyer {count} … vers Ekklo". `l10n.yaml` sets `nullable-getter: false`, so `AppLocalizations.of` needs no null check. Output goes to `lib/l10n/generated/` (Flutter docs, docs.flutter.dev, "Internationalizing Flutter apps").

12. **Leave `dart analyze --fatal-infos` and `dart format --set-exit-if-changed` clean.**
    Why: the lints and the formatter decide style questions so reviews do not.
    Example: `analysis_options.yaml` includes `package:very_good_analysis/analysis_options.yaml`, turns off `public_member_api_docs` (rule 1), and excludes `**/*.mapper.dart` and `lib/l10n/generated/**`.
