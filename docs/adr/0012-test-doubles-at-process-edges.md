# 12. Test doubles at process edges only

Date: 2026-10-07

## Status

Accepted

## Context

The rules that matter (statuses, adoption, orphan pairing, persistence of links) span the domain and the database. Mocking repositories would test the mocks' assumptions instead of the SQL, and would break on every refactor. Fūjin must never call the owner's real accounts from tests.

Vladimir Khorikov (*Unit Testing Principles, Practices, and Patterns*) argues for verifying observable behaviour and keeping mocks for dependencies that cross the application boundary, which for Fūjin are the two HTTP APIs and the system clock.

## Decision

- Assertions use `package:checks` (`checks` 0.3.2), not `expect` matchers. Plain tests import only the runner functions they need from `flutter_test` (`show group, test` in `test/domain/comparison/compare_day_test.dart`).
- Pure functions get plain tests with no doubles: `compareDay` (`test/domain/comparison/compare_day_test.dart`) and Ekklo energy (`test/domain/journal/ekklo_energy_test.dart`). Shared builders live in `test/support/fixtures.dart`.
- HTTP is faked at the `http.Client` seam with `package:http/testing.dart`'s `MockClient`. `FakeBackends` (`test/support/fake_backends.dart`) answers the MyFitnessPal and Ekklo routes from in-memory lists and records requests; the real client packages run on top of it.
- Time is injected: `compareDay` takes `now`, `JournalService` takes a clock (`test/domain/journal/journal_service_test.dart` passes a fixed one), and widget tests override `clockProvider` (`test/pages/journal_page_test.dart`).
- SQLite is never faked: tests open `FujinDatabase.inMemory()` or a real file in a temporary directory (`test/data/database_test.dart`).
- `JournalService` and the Journal page are tested end to end through those fakes (`test/domain/journal/journal_service_test.dart`, `test/pages/journal_page_test.dart`).
- Test names state behaviour in plain words ("claims each item once, in MyFitnessPal order").

## Consequences

- Refactoring a repository or the service does not touch the tests as long as behaviour holds.
- The fakes must follow the real route shapes; when a client package changes its endpoints, `FakeBackends` changes with it.
- Running against a phone or emulator uses separate local fake servers selected with `--dart-define` (see `AGENTS.md`), never the real accounts.
