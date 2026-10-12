# 25. Automatic mode

Date: 2026-10-10

## Status

Accepted. Amends the execution of [0018](0018-send-flow.md) for automatic sends, adds a rule to the comparison of [0001](0001-recompute-statuses-from-both-sides.md), and adds the first setting to the shared preferences of [0023](0023-ui-flags-in-shared-preferences.md).

## Context

The Réglages tab of the Figma file "Fūjin · Maquettes" (O1, O2) has a section "ENVOI" with one switch, "Mode automatique": "Ne me demande rien : aliments mémorisés, puis meilleur candidat, sinon aliment perso." Screen 17 ("Mode automatique · résultat") replaces screen 15 after such a send: "Mode automatique : rien ne t'a été demandé.", then "CHOIX FAITS SANS TOI (N)", one row per entry Fūjin decided alone, each with "Revoir", and "Ces choix ne sont pas mémorisés. « Revoir » permet de les garder pour les prochaines fois."

Two rules of [0018](0018-send-flow.md) stand in the way of "not remembered":

- Step 2 writes Memory before Ekklo, because adoption ([0001](0001-recompute-statuses-from-both-sides.md)) finds the items of an interrupted send through `ExpectedItem.forEntry`, which reads Memory. Without that write, a meal whose reply was lost would be sent twice on the retry.
- A linked entry whose item exists is "Dans Ekklo" whatever Memory says, so a choice the owner changes after the send would never reach Ekklo.

## Decision

The setting:

- `Setting.automaticMode` (`lib/data/settings/setting.dart`, key `setting_automatic_mode`), read and written by `SettingsRepository` (`lib/data/settings/settings_repository.dart`) in the shared preferences of [0023](0023-ui-flags-in-shared-preferences.md), off when absent. `FujinPreferences.open` (`lib/data/preferences/fujin_preferences.dart`) now opens the cache for the keys of `Hint` and `Setting`; it replaces `HintRepository.openPreferences`.
- It is a preference of this phone, not the owner's work: it stays out of `fujin.db` and out of the backup file, and Auto Backup does not carry it. A new phone starts in reviewed mode.
- Presenter `AutomaticModeNotifier` (`automaticModeProvider`, `lib/pages/common/automatic_mode_notifier.dart`); the switch is `SettingsSwitchRow` (`lib/pages/settings/widgets/settings_switch_row.dart`), a `CupertinoSwitch` in the colours of the Figma component "Interrupteur" (track `fujin` on, `kinari` off, thumb `background/card`), the whole row toggling it.

The send:

- `SendService.send` takes a `SendMode` (`lib/domain/sending/send_mode.dart`): `reviewed` or `automatic`, read from the setting by `SendNotifier` at each send, so a retry from screen 16 keeps the mode.
- In automatic mode `SendPage` sends the plan as soon as it is ready (screen 09, then 14), skipping screen 10: every proposal is used as is, as the review would have used it without changes. A plan with nothing to send still shows screen 10.
- An automatic send writes nothing to Memory in step 2: no association, no unit weight, no meal mapping. Own copies are the exception: they are real Ekklo foods once created, so step 3 still saves each one in Memory as soon as Ekklo returns it, and the next send reuses it instead of creating a duplicate.
- Before each Ekklo write of an item (a quantity update, or a meal's removals and `appendItems`), the send records an **unattended item** for every entry it is about to write whose item Memory does not predict, and for every entry the owner would have had to review: entry id, date, and the expected item (Ekklo meal, food, quantity, quantity type). Table `unattended_item` (migration 5), `UnattendedItem` (`lib/data/unattended/unattended_item.dart`), `UnattendedItemRepository` (`lib/data/unattended/unattended_item_repository.dart`). Once Ekklo has accepted the write, the unattended item of every other entry it wrote, including all those of a reviewed send, is forgotten in the same transaction as the send links: the row always says whether the entry's last successful write was decided without the owner, and a failed write leaves the entry "À mettre à jour".
- `SendReport` carries the mode and the planned entries that were to review (`SendReport.unattended`); `SendPage` shows `AutomaticSentView` (screen 17, `lib/pages/sending/widgets/automatic_sent_view.dart`) instead of `SentView` for an automatic send. Both share `SentFrame`.

The comparison (`compareDay`, `lib/domain/comparison/compare_day.dart`), which now also takes the day's unattended items:

- Adoption and orphan pairing accept an item that matches either Memory's expected item or the entry's unattended item. An automatic send interrupted after Ekklo wrote a meal is therefore adopted on the next read, as before, without Memory knowing the choice. Orphan pairing also reads the unattended item of the orphan link's old entry id, as long as the re-saved entry still has the meal, servings and serving of that link: an entry re-saved unchanged in MyFitnessPal is relinked "Dans Ekklo", one re-saved with another quantity or meal is "À mettre à jour", and its unattended item moves to the new id in the same transaction as the link.
- A linked entry with an unattended item is "À mettre à jour" when Memory expects an item and the linked item does not match it (`UpdateKind` as for orphans). While Memory has no opinion, it stays "Dans Ekklo". A linked entry without an unattended item keeps the old rule: "Dans Ekklo" whatever Memory expects.
- `JournalService.readDay` forgets the unattended items of entries that are no longer in the day.

"Revoir" (screen 17):

- Each row opens the sheet screen 10 would have opened for its reason: 12 for "Poids à confirmer", 13 for "Aucun aliment proche", 11 otherwise, without "Sauter". The sheets take their actions as `EntryChoices` (`lib/pages/sending/entry_choices.dart`), so screen 10 and screen 17 share them.
- Confirming calls `SendService.keep` through `KeptChoicesNotifier` (`lib/pages/sending/kept_choices_notifier.dart`): it remembers the choice as a reviewed send would (association, unit weight, missing meal mapping); for an own copy it reuses the fresh copy in Memory or creates one in Ekklo. When Memory then expects exactly the item that was sent, the unattended item is forgotten. When it expects another, the row stays, and the Journal shows the entry "À mettre à jour" at its next read; screen 17 never sends anything itself.
- A kept row shows the kept choice and the "Mémorisé" pill (`PillTone.validated`) in place of "Revoir". While a choice is being kept, its "Revoir" is disabled and a second confirmation does nothing, so one row never creates two own copies. If keeping fails, the row keeps "Revoir" and a snackbar says why: no connection, an expired session (with "Se reconnecter" for Ekklo), the dev flavor's guard, otherwise "Choix non gardé".

Interrupted automatic sends use screen 16 unchanged; the dev flavor's read-only guard still stops the first write.

## Consequences

- An interrupted or retried automatic send never duplicates an item or an own copy: `test/domain/sending/send_service_test.dart`, "in automatic mode never sends twice an item or an own copy whose reply was lost", which also checks that the Journal shows the items of the lost reply "Dans Ekklo" before the retry.
- An automatic send leaves Memory as it was, except for the own copies it created (same file, "sends every proposal and remembers only the own copies it created").
- An entry sent without the owner follows his later choices: if he associates its MyFitnessPal food with another Ekklo food, by "Revoir" or by any later reviewed send or Mémoire edit, the day shows it "À mettre à jour" until it is sent again. Entries sent with the owner keep their "Dans Ekklo" status when Memory changes, as before.
- Rows of `unattended_item` are not in the backup file; an import leaves them, since they describe items in Ekklo, which the import does not change. After a restore on a new phone, entries sent automatically on the old one behave like reviewed ones.
- An own copy chosen on "Revoir" for an entry sent with a matched food is created in Ekklo at once; it is the only Ekklo write screen 17 can make.
