# 6. Riverpod notifiers as presenters

Date: 2026-10-07

## Status

Accepted. The Journal follows it today; the write notifiers are planned.

## Context

Fūjin needs dependency injection (clients, database, clock) that tests can override, and per-screen state with loading and error cases. Widgets should stay thin enough that the interesting logic can be tested without pumping them.

## Decision

- Riverpod 3 (`hooks_riverpod` 3.4.3, `pubspec.lock`) for both injection and state.
- Providers are hand-written; no `riverpod_generator`, no `build_runner` for providers. Injection providers live in `lib/app/providers.dart` (`clockProvider`, `databaseProvider`, `httpClientProvider`, `secureStorageProvider`, the two client providers, repositories, `journalServiceProvider`). `databaseProvider` throws until `lib/main.dart` overrides it with the opened database.
- A `Notifier` or `AsyncNotifier` is the presenter of a screen: it holds state and logic, and has no `BuildContext`, no navigation and no l10n lookups. Example: `JournalNotifier` in `lib/pages/journal/journal_notifier.dart`, an `AsyncNotifierProvider.autoDispose.family` keyed by the day, with retry disabled. It returns a `RefreshOutcome` and the page decides what to show (`lib/pages/journal/journal_page.dart`).
- Small UI state that outlives a widget gets its own notifier next to the page, for example `SelectedDay` in `lib/pages/journal/selected_day.dart`.
- Riverpod's `Mutation` API is still under `package:riverpod/experimental/` in 3.4.3, so it is not used. Planned: each write use case (send, update, undo, import, export) gets its own notifier whose state is a sealed type (idle, running, done, failed), switched over exhaustively by its page.
- `flutter_hooks` handles controllers owned by a single widget (`useTextEditingController`, `useFocusNode`, lifecycle callbacks) inside a `HookConsumerWidget`. Example: `useOnAppLifecycleStateChange` in `lib/pages/journal/journal_page.dart`. A controller whose text is business state belongs to the notifier instead.

Sources: Riverpod docs (riverpod.dev) for providers, families, `autoDispose` and overrides; flutter_hooks package docs for hooks.

## Consequences

- Tests swap the clock and the HTTP client with `ProviderScope` overrides (`test/pages/journal_page_test.dart`) and need nothing else.
- Hand-written providers cost a few more lines each and keep the build free of a second generator.
- Every write screen will share one shape (sealed state, exhaustive switch), so the page cannot forget a case.
