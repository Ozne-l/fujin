---
name: fujin-state
description: Riverpod 3 and flutter_hooks conventions in Fūjin. Load when adding or changing a provider, notifier, presenter, page state, dependency injection, overrides, refresh or reload logic, snackbars and other one-shot UI effects, or when asked "where does this state live", "how do I inject X", "riverpod", "notifier", "hooks".
---

# Fūjin state

Riverpod 3 does both injection and state. Providers are written by hand; a notifier is the presenter for one screen and knows nothing about widgets; widgets are `HookConsumerWidget`s that watch, render, and trigger. Background reading: riverpod.dev (Riverpod 3.0 docs: providers, `Notifier`/`AsyncNotifier`, families, auto dispose, automatic retry, `Ref.mounted`, overrides).

## Rules

1. **Write providers by hand as top-level `final`s; app-wide wiring goes in `lib/app/providers.dart`.**
   Why: plain Dart that reads without code generation; the only generators in the repo are the mappers, gen-l10n and the token tool. `riverpod_generator` is not used (owner decision recorded for the stack).
   Example: `journalServiceProvider`, `memoryRepositoryProvider`, `sentLinkRepositoryProvider` in `lib/app/providers.dart`. Providers that belong to one feature sit next to their type: `journalProvider` in `lib/pages/journal/journal_notifier.dart`, `selectedDayProvider` and `todayProvider` in `lib/pages/journal/selected_day.dart`, `routerProvider` in `lib/app/router.dart`.

2. **Put each process edge behind its own provider: clock, HTTP client, secure storage, both API clients, database.**
   Why: tests replace exactly these and nothing else (see the `fujin-tests` skill), and disposal is declared where the resource is created.
   Example: `lib/app/providers.dart`:
   ```dart
   final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
   ```
   ```dart
   final httpClientProvider = Provider<http.Client>((ref) {
     final client = http.Client();
     ref.onDispose(client.close);
     return client;
   });
   ```
   `mfpClientProvider` and `ekkloClientProvider` pass `clockProvider` and `httpClientProvider` into the client packages and close the client on dispose. `mfpUserAgentProvider` defaults to the client's own User-Agent; `lib/main.dart` overrides it with the web view's.

3. **Override `databaseProvider` at bootstrap; its default throws.**
   Why: opening `fujin.db` needs the app support directory, which is async; `main` resolves it once and hands the open database to the scope. A missing override fails loudly instead of opening a second database.
   Example: `lib/main.dart` (`databaseProvider.overrideWithValue(database)` inside `ProviderScope`), default in `lib/app/providers.dart`:
   ```dart
   final databaseProvider = Provider<FujinDatabase>(
     (ref) => throw StateError('databaseProvider is overridden in bootstrap'),
   );
   ```

4. **`ref.watch` inside `build`, `ref.read` inside methods and callbacks.**
   Why: `watch` subscribes and rebuilds; in a method or event handler it would add listeners the build does not own (riverpod.dev, "Reading a provider").
   Example: `JournalNotifier.build` watches `journalServiceProvider` and `mealNamesProvider.future`; `JournalNotifier._reread` reads them (`lib/pages/journal/journal_notifier.dart`). `JournalPage.build` takes the notifier with `ref.read(journalProvider(day).notifier)` (`lib/pages/journal/journal_page.dart`).

5. **Treat a notifier as the presenter: it owns state and logic and never touches `BuildContext`, navigation or localized strings.**
   Why: the presenter stays testable without widgets, and copy is chosen in one layer, in the device language.
   Example: `JournalNotifier` exposes a `JournalDay` and the methods `refresh()` and `reload()` (`lib/pages/journal/journal_notifier.dart`); the page turns `JournalDay.counts` into the localized button label and pills (`lib/pages/journal/widgets/meal_card.dart`, `lib/pages/journal/widgets/day_summary_card.dart`).

6. **Key per-day state with an auto-disposed family and pass the argument through the notifier constructor.**
   Why: each day gets its own cache, released when no widget shows it any more (riverpod.dev, "Family" and "Auto dispose").
   Example: `lib/pages/journal/journal_notifier.dart`:
   ```dart
   journalProvider = AsyncNotifierProvider.autoDispose
       .family<JournalNotifier, JournalDay, DateTime>(
         JournalNotifier.new,
         retry: _noRetry,
       );
   ```
   Family keys are normalized to UTC calendar days with `SelectedDay.calendarDay` (`lib/pages/journal/selected_day.dart`) so two moments of the same day share one notifier.

7. **Turn off automatic retry on providers that call MyFitnessPal or Ekklo.**
   Why: Riverpod 3 retries a failing provider by default (riverpod.dev, "Automatic retry"); a dead session or a server error must show the problem card once, not hammer the APIs in the background.
   Example: `_noRetry` passed as `retry:` to `journalProvider` and `mealNamesProvider` (`lib/pages/journal/journal_notifier.dart`):
   ```dart
   Duration? _noRetry(int retryCount, Object error) => null;
   ```

8. **Return an outcome from the method for a one-shot UI effect; do not keep events in state.**
   Why: state describes what the screen shows; an event stored there replays on every rebuild and needs clearing.
   Example: `JournalNotifier.refresh` returns `RefreshOutcome.nothingNew` when the MyFitnessPal diary is equal before and after the read (`lib/pages/journal/journal_notifier.dart`, `lib/pages/journal/refresh_outcome.dart`); only then does `JournalPage` show the 6 s "Rien de nouveau" snackbar (`JournalPage._showNothingNew` in `lib/pages/journal/journal_page.dart`). `reload()` returns nothing, so a foreground return never shows it.

9. **Check `ref.mounted` after an `await` before writing `state`; check `context.mounted` in widgets.**
   Why: an auto-disposed notifier can be gone when the future completes (`Ref.mounted` is new in Riverpod 3, riverpod.dev).
   Example: `if (ref.mounted) state = next;` in `JournalNotifier._reread`; `if (!context.mounted) return;` in the refresh callback of `JournalPage.build`.

10. **Wrap reads in `AsyncValue.guard` and render `AsyncValue` with a `switch` on its patterns, data first.**
    Why: errors become state instead of escaping, and matching `AsyncValue(value: ...)` first keeps the previous day on screen while a refresh runs.
    Example: `JournalNotifier._reread` (`AsyncValue.guard`), and in `JournalPage.build`:
    ```dart
    ...switch (journal) {
      AsyncValue(value: final JournalDay loaded) => _loaded(
        context,
        loaded,
      ),
      AsyncError(:final error) => [
        SliverToBoxAdapter(child: JournalProblemCard(error: error)),
      ],
      _ => [
    ```

11. **Write screens as `HookConsumerWidget` and use hooks for what one widget owns: lifecycle listeners, text controllers, view toggles.**
    Why: hooks tie setup and disposal to the widget without a `StatefulWidget`.
    Examples: `useOnAppLifecycleStateChange` calls `notifier.reload()` on `AppLifecycleState.resumed` in `JournalPage.build` (`lib/pages/journal/journal_page.dart`); `EkkloSignInPage` keeps the email and password in `useTextEditingController`, rebuilds on typing with `useListenable`, and holds the password's red outline and its show/hide toggle in `useState` (`lib/pages/ekklo_sign_in/ekklo_sign_in_page.dart`). A controller whose text is business state (a search query, for example) will belong to the notifier, not the widget.

12. **Give each write use case (sign-in, send, update, undo, import, export) its own auto-disposed notifier with a sealed state `idle`, `running`, `done`, `failed`; the page reacts to transitions with `ref.listen`.**
    Why: a write has a lifecycle the page must render (screen 14 "Envoi en cours", failure banners and sheets) and must not be mixed into the read state of `JournalNotifier`. `done` and `failed` are states the page shows or leaves on, not stored events, so rule 8 still holds.
    Example: `EkkloSignInNotifier` with `EkkloSignInState` (`EkkloSignInIdle`, `EkkloSignInRunning`, `EkkloSignInDone`, `EkkloSignInFailed` carrying a `SignInFailure` and Ekklo's message) in `lib/pages/ekklo_sign_in/`; the sealed state follows the `EntryStatus` shape (`lib/domain/comparison/entry_status.dart`). `EkkloSignInPage` pops with `true` on `EkkloSignInDone` and outlines the password on a refusal, both from `ref.listen`. `MfpSignInNotifier` (`lib/pages/mfp_sign_in/`) has the same four states; its `offer` ignores cookies without a session or already refused, and queues cookies that arrive while a check runs. Planned users: send and update (the send button is shown disabled with its computed label in `lib/pages/journal/widgets/day_summary_card.dart`). Riverpod's `Mutation` is not used: in `riverpod` 3.4.3 it still ships under `package:riverpod/experimental/mutation.dart`.
