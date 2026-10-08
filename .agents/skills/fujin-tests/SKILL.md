---
name: fujin-tests
description: How Fūjin is tested. Load when writing, fixing or reviewing a test, adding a fixture or fake, deciding what to test or what to fake, or when asked about "tests", "flutter test", "mock", "fake", "fixtures", "widget test", "checks", "TDD", "test double".
---

# Fūjin tests

Tests check what the owner would see or what ends up stored, through the real code: real SQLite, the real client packages parsing real-shaped JSON, the real app widget. Only what leaves the process is replaced: HTTP and the clock. Pure logic is tested by its return value.

The vocabulary comes from Vladimir Khorikov, *Unit Testing Principles, Practices, and Patterns*: output-based tests for pure functions; managed dependencies (the app's own database) used for real; unmanaged dependencies (MyFitnessPal and Ekklo, owned by others) replaced at the boundary. The loop comes from Kent Beck, *Test-Driven Development: By Example*: one failing test, the least code to pass, then refactor.

## Rules

1. **Assert with `package:checks`, and import from `flutter_test` only the runner functions you need.**
   Why: `checks` gives typed, chainable subjects and readable failures; the `show` list keeps `expect` matchers out.
   Example: `test/data/database_test.dart` imports `package:flutter_test/flutter_test.dart` with `show addTearDown, group, setUp, tearDown, test`. Chained subject in `test/domain/journal/journal_service_test.dart`:
   ```dart
   check(
         first.comparison.entries.single.status,
       )
       .isA<InEkklo>()
       .has((status) => status.link.ekkloItemId, 'item')
       .equals(
         'I-1',
       );
   ```

2. **Test pure functions directly, by their output.**
   Why: output-based tests (Khorikov) need no setup beyond inputs and survive any refactor of the internals.
   Examples: `compareDay` in `test/domain/comparison/compare_day_test.dart` (16 tests through a small `compare` helper, asserting statuses, `linksToAdopt` and `linksToDrop`); `ekkloKilocaloriesOf` in `test/domain/journal/ekklo_energy_test.dart`. New comparison rules start as a failing case in `compare_day_test.dart`.

3. **Replace only process edges: HTTP with `MockClient` in `FakeBackends`, and the clock with a fixed function.**
   Why: MyFitnessPal and Ekklo are unmanaged dependencies (Khorikov), so they are faked at the wire; everything inside, including the two client packages and their JSON parsing, runs for real.
   Example: `test/support/fake_backends.dart` routes on `(request.method, request.url.host, request.url.path)` and serves `entries`, `ekkloMeals` and `mealNames` encoded with the client packages' own `toMap()`. For the send flow it also answers Ekklo food search (`ekkloSearches`, keyed by query), food reads and own-copy creation (`ekkloFoods`), and applies `appendItems`, quantity updates and item removals to `ekkloMeals`; `failingMeals` refuses an append and `lostReplies` applies it then answers 503, which is how `test/domain/sending/send_service_test.dart` proves a retry never sends twice. `FakeBackends.mfp()` and `FakeBackends.ekklo()` return signed-in clients; `FakeBackends.mfpWith(store)` and `FakeBackends.ekkloWith(store)` return clients on a session store the test fills or reads afterwards (an empty store is a missing session). The Ekklo login route accepts `ekkloEmail` with `ekkloPassword` and answers anything else with a 401 carrying `ekkloRefusal`; other Ekklo routes answer 401 to any token but the fake access token and refuse every refresh, so a store holding `staleEkkloTokens` is an expired session. `/user/auth_token` refuses `refusedMfpSession` with a 401. `ekkloReachable = false` and `mfpReachable = false` make every request to that service fail as a network error (`test/pages/ekklo_sign_in_page_test.dart`, `test/pages/mfp_sign_in_notifier_test.dart`). Fields are mutable so a test can change the diary between two reads (`test/pages/journal_page_test.dart`). The clock is `() => now` from `test/support/fixtures.dart`, passed to `JournalService` or through `clockProvider.overrideWithValue`.

4. **Use a real database: `FujinDatabase.inMemory()` per test, closed in `tearDown`; a temp file when the test reopens it.**
   Why: the app's own SQLite is a managed dependency (Khorikov); faking it would hide SQL, constraint and transaction bugs (the `REPLACE` cascade in `fujin-storage` is one).
   Examples: `setUp` and `tearDown` in `test/data/database_test.dart` and `test/domain/journal/journal_service_test.dart`; the reopen test in `test/data/database_test.dart` uses `Directory.systemTemp.createTempSync('fujin_db_')` with `addTearDown(() => directory.deleteSync(recursive: true))`.

5. **Build test data with the helpers in `test/support/fixtures.dart`, overriding only the arguments the test is about.**
   Why: the reader sees the one difference that matters; shared names (`oats`, `rice`, `breakfast`, `petitDejeuner`) keep the scenarios consistent with `memory`.
   Example: `entry('E-1', food: rice, unit: cup, servingValue: 1, servings: 2)` in `test/domain/comparison/compare_day_test.dart`; the helpers `entry`, `item`, `meal`, `link`, the `memory` constant, `day` and `now` in `test/support/fixtures.dart`.

6. **Test a page by pumping `FujinApp` inside a `ProviderScope` that overrides the edge providers, with the French locale pinned, then assert on the French text a user would read.**
   Why: this runs routing, theme, gen-l10n, the notifier and the service together, with only the edges swapped (rule 3). The test binding reports an English device, so without the pin the English ARB would answer.
   Example: `pumpFujin` in `test/support/pump_fujin.dart` (used by `test/pages/journal_page_test.dart`, `test/pages/ekklo_sign_in_page_test.dart` and `test/pages/welcome_page_test.dart`) sets `tester.platformDispatcher.localesTestValue` to French, overrides `appEnvironmentProvider` (production), `databaseProvider`, `clockProvider`, `mfpClientProvider` and `ekkloClientProvider`, then checks `find.text('Envoyer 2 aliments vers Ekklo')`, `find.text('1/2 dans Ekklo')` and `find.text('Rien de nouveau')`. Pull to refresh is a `tester.fling` on the `CustomScrollView` (`_pullToRefresh`). `tester.enterText` does not rebuild the page, so `pump` before tapping a button whose enabled state depends on the text (`_signIn` in `test/pages/ekklo_sign_in_page_test.dart`). A web view cannot run under `flutter test`, so the MyFitnessPal sign-in is tested through its notifier in a `ProviderContainer` that overrides `mfpClientProvider` (`test/pages/mfp_sign_in_notifier_test.dart`), and the page itself on the emulator.

7. **Name each test as a sentence that states the behaviour, reading on from its `group`.**
   Why: the test list doubles as the specification of the comparison rules.
   Examples: group "an unlinked entry" with "adopts within 0.1 of the expected quantity and not beyond" and "claims each item once, in MyFitnessPal order" (`test/domain/comparison/compare_day_test.dart`); "says nothing is new only after a pull that changed nothing" (`test/pages/journal_page_test.dart`).

8. **Test a persistence rule through the service that applies it, and assert on what is stored.**
   Why: the rule the owner cares about ("never send twice") spans the comparison, the repository and the transaction; one test through `JournalService` covers all three.
   Example: "keeps the item of an interrupted send instead of sending it twice" and "moves a link to the new id of an entry re-saved in MyFitnessPal" read `links.forDate(day)` after `readDay` (`test/domain/journal/journal_service_test.dart`).

9. **Pin a fixed bug or a fragile choice with a test named after the behaviour it protects.**
   Why: the next refactor gets a failing test, not a silent regression.
   Example: "keeps the units of a food saved again" (`test/data/database_test.dart`) fails if `FujinDatabase.upsert` ever becomes `INSERT OR REPLACE`.

10. **Do not test wiring, generated code echoes or defaults.**
    Why: they have no logic of their own, and their failures already surface through the behaviour tests above.
    Examples of what has no test on purpose: the providers in `lib/app/providers.dart`, `toMap`/`fromMap` round trips of `*.mapper.dart` files, `FujinTheme.light()` and `lib/app/theme/fujin_tokens.g.dart`, constructor defaults such as `Memory()` or `StatusCounts()`.

11. **Run `flutter test` from the repo root before handing work back, together with `dart analyze --fatal-infos` and `dart format --set-exit-if-changed .`.**
    Why: tests are only useful if they are green at every hand-off.
    Example: the suite lives under `test/` (`test/data/`, `test/domain/`, `test/pages/`, helpers in `test/support/`).
