# 16. English in code, design tokens and docs

Date: 2026-10-07

## Status

Accepted. Applied the same day: the Figma variables, text styles and mode were renamed, and the code follows.

## Context

Fūjin's code, docs and commits are in English, but the design tokens came from Figma variables, text styles and descriptions written in French (`role/texte/principal`, `taille/marge-ecran`, mode `Clair`). The generator turned those names into Dart identifiers such as `FujinRole.textePrincipal`, so French leaked into every widget that used a token.

## Decision

- Identifiers, file names, SQL names, docs, issues and commit messages are in English.
- French appears only in `lib/l10n/app_fr.arb` and where a doc or test quotes the app's French copy verbatim.
- Design tokens are named in English at the source, in Figma: groups `color`, `space`, `radius`, `stroke`, `size`, `role/background|border|text|button|source|goal`, `font/family|weight`, text styles under `text/`, mode `Light`. Token descriptions are in English too. The Japanese palette names (`sumi`, `kin`, `sora`, `shu`, `washi`...) stay: they are proper names of the palette, only their variants are English (`kin-light`, `kin-dark`).
- Figma and `design/tokens/` carry the same names; `tool/generate_tokens.dart` holds no translation table. Role colours are generated as `FujinColorRole` (formerly `FujinRole`), next to the raw palette `FujinColor`.
- The Figma plugin behind the FujinFigma MCP server has `get_variables` and `rename_tokens` commands; renames go through `rename_tokens`, then `design/tokens/` is updated to match and checked against `get_variables`.
- When an agent finds French anywhere else in the repository, it reports it to the owner instead of renaming on its own; the owner decides.

## Consequences

- A token rename touches Figma, `design/tokens/`, the generated Dart and every widget using the token; the analyzer lists the widgets.
- The generator's group paths are constants in `tool/generate_tokens.dart` and change with the Figma groups.
- [ADR 0008](0008-theme-from-design-tokens.md) still says `FujinRole`; read it as `FujinColorRole`.
