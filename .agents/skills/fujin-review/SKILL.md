---
name: fujin-review
description: Review Fūjin changes before a push, for regressions against main, bugs, duplicated code, AI slop, divergence from the ADRs and the house conventions. Invoked by the owner as /fujin-review.
argument-hint: "[staged | <commit> | <range>] (default: everything not on origin/main)"
disable-model-invocation: true
---

# Fūjin review

Audit a set of changes the way a careful senior reviewer of this codebase would, and report to the owner before he pushes. The review reads, runs and reports; it does not edit, commit or push.

## 1. Scope

Pick the changes from the argument:

| Argument | Changes reviewed |
| --- | --- |
| none | everything not on `origin/main`: `git log origin/main..HEAD`, `git diff origin/main` (committed, staged and unstaged together) and untracked files (`git ls-files --others --exclude-standard`) |
| `staged` | `git diff --cached` |
| a commit | `git show <commit>` |
| a range | `git log <range>` and `git diff <range>` |

Do not fetch. Say which `origin/main` commit the review compared against. If the scope is empty, say so and stop.

List the changed files grouped by layer (`lib/app`, `lib/pages`, `lib/domain`, `lib/data`, `test`, docs and skills, design tokens, platform folders). Read each changed file in full, not only the hunks: duplication and divergence hide in the unchanged lines around a change.

## 2. Context

Load before judging anything:

- `AGENTS.md`, `GLOSSARY.md`, and every ADR in `docs/adr/` that the changed files touch.
- The skills `fujin-dialect` (always), `fujin-state` (providers, notifiers, pages), `fujin-storage` (`lib/data/`, migrations), `fujin-tests` (any test).
- For each changed public symbol, its references (language server first, `grep` only as a fallback), to see every caller the change affects.

A rule in these files is the reference. Cite it by skill and rule number, or by ADR number, in every convention finding.

## 3. Mechanical checks

Run them all, even when one fails, and keep the output:

1. `dart analyze --fatal-infos`
2. `dart format --output=none --set-exit-if-changed lib test tool`
3. `flutter test`
4. When the scope touches their sources, the generators: `dart run build_runner build` (models), `flutter gen-l10n` (`lib/l10n/app_fr.arb`), `dart run tool/generate_tokens.dart` (`design/tokens/`). Then `git status --short`: a generated file that changed means it was out of date in the scope. This is the only way the review writes files; the output is deterministic, so leave it and report it.

## 4. Read the changes

With more than about 15 changed files, split the scope into slices that do not overlap (for example domain and data, pages and widgets, state and routing, tests and docs) and give each slice to its own read-only reviewer subagent, all at once. Give each one the scope, the skills to load and the checklist below. Otherwise review inline. Either way, go through every item of the checklist for every slice.

### Regressions against main

- A behaviour of `origin/main` that the change alters without the commit message, an ADR or the owner asking for it.
- Every caller of a changed signature, sealed family or provider, still correct, including tests and `test/support/`.
- Migrations: only appended to `schemaMigrations`, never edited once shipped; existing rows are carried over; foreign key cascades do not delete what they should keep (`fujin-storage` rules 3, 5, 9).
- Removed or renamed ARB keys, routes, table columns, tokens and assets: nothing still refers to them.
- Retries and re-reads stay idempotent: an interrupted send never writes an item or an own copy twice (ADR 0002, ADR 0018).

### Bugs

- Edge cases: empty lists, `null` values from MyFitnessPal (missing nutrients, entries without an id), a second unit for the same food, the same food twice in a meal, day boundaries and time zones.
- Wrong keys or identity: maps or rows keyed by too little (one value where the decision depends on two), lookups that can return another entity's data.
- Error classification: what the owner reads matches what happened (a 5xx is not a refusal, a network loss is not a server error, a dev write block is only for writes).
- Writes that belong together outside one transaction (`fujin-storage` rule 7).
- Async: `context.mounted` after every `await` in widgets, notifiers that keep working after disposal, futures that are neither awaited nor passed to `unawaited`.
- Quantities and units: grams against portions, rounding, `servings` × serving value.

### Duplicated code

- A widget, style, helper or rule that already exists in `lib/pages/common/`, `lib/app/theme/`, `lib/domain/comparison/` or a sibling feature, written again.
- Two new copies of the same thing inside the scope, typical of work done in parallel: the same private widget in two screens, the same computation in a rule and in a service.
- Search by shape as well as by name: the same `switch`, the same padding and radius set, the same formula.

### AI slop

- Dead code: unused parameters, getters, private members, enum values, ARB keys, mapper parts left after a removal, files nothing imports.
- Abstractions with one user and no reason, wrappers that only forward, options nobody passes.
- Workarounds instead of fixes: keep-alive listeners, artificial delays, catch-all `catch`, fallbacks such as `?? ''` or `?? 0` that hide a missing value the type says can be missing.
- Code that looks finished but is not: placeholders, a branch that silently does nothing, a TODO, a test that only checks a widget exists.
- Comments, `!`, magic numbers and strings, raw colours, sizes and durations, user-facing text outside the ARB files.
- Prose in docs, ADRs, skills and commit messages that claims something the code or a test does not show, or that pads with filler.
- French outside `lib/l10n/app_fr.arb` and verbatim app copy: report it, the owner decides (`AGENTS.md`).

### Divergence

- From the ADRs: the code does something an ADR rules out, or an ADR describes code that no longer exists.
- From `GLOSSARY.md`: a domain word used with another meaning, or a new word without an entry.
- From Figma: copy, structure or values that differ from the frame the screen implements. Keep a deliberate difference only when the code or an ADR says why; otherwise report it.
- Docs and skills left behind: a skill example naming a moved symbol, a table or file list that misses the new one, a status line that is now false.

### Conventions

Check each changed file against the four house skills, rule by rule, and against `AGENTS.md`: layers point down only (ADR 0013), one public type per file, `final class` for models and services, plain `class` for widgets, `switch` over if-chains and exhaustive on sealed types, `dart_mappable` models with a discriminator on sealed unions, tokens for every visual value, ARB for every string, providers in `lib/app/providers.dart`, notifiers as presenters (`fujin-state`), SQL only in repositories (`fujin-storage`).

### Tests

- Every new behaviour and every fixed bug has a test that would fail without the change; say which ones are missing.
- `fujin-tests` rules: `package:checks`, doubles only at the process edges (`FakeBackends`, the clock), real SQLite, names that state behaviour.
- Tests that only re-check wiring, a mock, a default or a wording: report them for deletion.

## 5. Confirm every finding

Before a finding goes in the report, re-read the lines it cites and prove it: a failing command, a reproduction, a reference that breaks, two code locations side by side. Drop what does not hold. What cannot be proved without the real Ekklo or MyFitnessPal stays in the report as unverified, never as fact.

## 6. Smoke run

When the scope changes what a screen shows or does, and `adb devices` lists an emulator, run the changed path there against fake servers, as `AGENTS.md` describes in "Running without real accounts", and look at the result. Never install on a physical phone and never point a build at the real accounts. Without an emulator, say the screens were not run.

## 7. Report

Write to the owner in French, without em dashes, conclusion first:

1. Verdict: ready to push, or not, in one sentence with the count of findings per severity.
2. Findings, most severe first, one row each: severity (`bloquant` for a bug or regression, `à corriger` for a convention, duplication or slop finding, `mineur` for the rest), category, `file:line`, what is wrong, the evidence, the fix proposed.
3. The checks of step 3 and the smoke run of step 6, with their result.
4. What stays unverified, and the points the owner has to decide.

Stop after the report. Fix only what the owner then approves, and after fixing run step 3 again and recheck the slices the fixes touched.
