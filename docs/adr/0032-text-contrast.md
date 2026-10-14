# 32. Text roles meet 4.5:1 on page and card

Date: 2026-10-14

## Status

Accepted. Changes one primitive of [0008](0008-theme-from-design-tokens.md).

## Context

The UI/UX audit of 2026-10-14 measured the text roles against the page (`washi`, `#F7F1E0`) and the card (`kinu`, `#FFFCF4`). `textTertiary` (`hai-light`, `#8A826C`) gave 3.39:1 on the page, below the 4.5:1 that WCAG 2.2 (1.4.3) asks for text under 18 pt. It carries information in 12 and 13 px: goal denominators ("/ 1 800 kcal"), read times ("à 14:54"), macro lines under each food, the tolerance note of the send review.

## Decision

- `hai-light` becomes `#736C5A`: 4.63:1 on `washi`, 5.09:1 on `kinu`, same hue as before. `design/tokens/fujin.tokens.json` holds the value and `lib/app/theme/fujin_tokens.g.dart` is regenerated from it.
- Every role used for readable text (`textPrimary`, `textSecondary`, `textTertiary`, `textLink`, `textGold`, `textAlert`) keeps at least 4.5:1 on both backgrounds. `textDisabled` (`usuzumi`) and `buttonDisabledText` are exempt: WCAG excludes inactive controls, and `usuzumi` only marks days to come and disabled text.

## Consequences

- `textTertiary` and `textSecondary` (`hai`, `#6F6857`) are now close in value; the hierarchy between them rests on size and weight.
- The Figma variable `color/hai-light` (collection "Fūjin") still holds `#8A826C`: the owner updates it in Figma, since the Figma bridge cannot set variable values.
