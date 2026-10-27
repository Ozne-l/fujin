# 42. Text contrast on tinted surfaces

Date: 2026-10-27

## Status

Accepted. Extends [0032](0032-text-contrast.md) from page and card to the tinted surfaces text sits on, and changes the light text of two glass finishes of [0041](0041-liquid-glass-renderer-1.0.md).

## Context

[0032](0032-text-contrast.md) checks every text role on the page and the card only. The Figma sync of 2026-10-27 measured the light theme where text sits on something else:

- `text/secondary` (`hai`, `#6F6857`) on `background/neutral` (`kinari`, `#E3DAC0`): 3.97:1. The unselected labels of the segmented control, the muted and neutral pills ("Aucun aliment proche", "F n.c." at 11 px).
- `text/gold` (`kin-dark`, `#8C6418`) on `background/highlight` (`kin-light`, `#F3E6C4`): 4.28:1. The attention pills ("Mémorisé", "Nouveau choix", "Poids à confirmer").
- `text/glass-alert` (`shu`) on the alert glass: 4.2:1 measured on the Pixel 8 for "Réessayer" on the alert card ([0041](0041-liquid-glass-renderer-1.0.md)), about 4.3:1 for "Oublier cet aliment" on the page.
- `text/glass-gold` (`kin-dark`) on the attention glass of the unchosen "à vérifier" filter: about 3.9:1 on the page.

The snack bar detail line was coloured `text/disabled`, a role [0032](0032-text-contrast.md) exempts from contrast because it marks inactive things.

## Decision

- `hai` becomes `#645E4F`: 4.62:1 on `kinari`, 5.72:1 on `washi`, same hue. It now sits further from `hai-light` (`#736C5A`), which restores some of the hierarchy [0032](0032-text-contrast.md) gave up.
- `kin-dark` becomes `#855F17`: 4.64:1 on `kin-light`, same hue.
- Two primitives carry the light text of tinted glass: `kin-deep` `#795615` for `text/glass-gold` and `shu-dark` `#9E3322` for `text/glass-alert`. `text/gold`, `text/alert` and the tints behind the glass keep `kin-dark` and `shu`. On the face [0041](0041-liquid-glass-renderer-1.0.md) measured for "Réessayer" (`#F3D2C8`), `shu-dark` reads at 5.0:1. The dark values do not change.
- The snack bar detail takes a new role, `text/on-dark-secondary`: `usuzumi` in light (8.4:1 on sumi), `#6B6556` in dark (4.7:1 on cream), the colours it already had.
- `test/app/theme/fujin_colors_contrast_test.dart` also checks, in both themes: `text/secondary` on `background/neutral`, `text/gold` on `background/highlight`, both on-dark roles on `background/dark`, and the text of each tinted glass finish in use on its tint laid over the surfaces it sits on (validated, attention, alert and muted over page and card, alert over `background/alert`).

## Consequences

- The glass check composites the tint over the surface without the renderer's wash, which lightened the face of "Réessayer" on the phone; the targets keep a margin for that (4.5:1 flat on the alert card, 5.0:1 on the measured face).
- Every secondary text in light is slightly darker. The Figma variables `color/hai` and `color/kin-dark` take the new values, and `color/kin-deep`, `color/shu-dark` and `role/text/on-dark-secondary` are created there.
- The info glass finish is not used on any surface yet, so it has no check; its light text would read about 4.3:1 on the page.
