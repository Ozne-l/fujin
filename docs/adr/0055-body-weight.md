# 55. Body weight: Fūjin's weigh-ins, written to Ekklo and MyFitnessPal

Date: 2026-11-22

## Status

Accepted; built. The client resources (`client.measurements` in `ekklo_client` and `myfitnesspal_client`), the tables, the import, the writer, backup version 6 and the screens W01 to W06 (Figma "Expérience 7 · Poids (ADR 0052)" in the file "App", named while this record was still numbered 52) are built; the curve is left for later. Adds backup file version 6 to [0021](0021-backup-file.md) and the milestones to the shared preferences of [0023](0023-ui-flags-in-shared-preferences.md).

## Context

The owner weighs himself and logs the value in the Ekklo app (86 entries from 2026-02-02 to 2026-11-22 on 2026-11-22), and wants Fūjin to keep his body weight and write it to both apps, as it does for food ([0044](0044-connector-model.md)). Entry is by hand; no scale, no Health Connect for now. Coach-assigned measurements (Ekklo "Mensurations"), weight goals and units other than kilograms are out of scope.

What each app exposes was read statically (Ekklo 2.2.0 Hermes bundle, MyFitnessPal 26.39.0 APK and website bundle; notes kept on the owner's machine, untracked, in `doc/measurements.md` of each client package), then checked by two probes the owner ran on 2026-11-22 (`~/Dev/bridge_poc/bin/ekklo_weight_probe.dart`, `mfp_weight_probe.dart`):

- Ekklo, `/api/v1/nutritions/weight-tracking`: `GET /all` returns every entry as a bare list (`id`, `date` at midnight UTC, `weight` in kilograms, `note`, `created_at`, `updated_at`); 6 of the 80 days held more than one entry. `GET ?date=` returns one entry, `{}` for a day with none. `POST {date, weight}` replaces the day's entry: two posts left one row, `updated_at` moved. There is no update or delete.
- MyFitnessPal, `/v2/measurements` with the bearer token the client already holds: `POST` creates a measurement and returns it with its id (a numeric string); `GET ?entry_date=&types=weight` returns only the first weight saved that day, so a second `POST` stays hidden; `DELETE /{id}` removes one. The website's own routes (`PUT /api/services/incubator/measurements/upsert`, range reads, delete), called with the session cookies, also work and replace in place; a weight written there showed in the MyFitnessPal app, and `/v2` and the website see each other's rows.

## Decision

Model:

- A weigh-in is Fūjin's record of the owner's body weight on one day, in kilograms: a Fūjin id (UUIDv7), the day, the kilograms, `updated_at` and `deleted_at`, in `fujin.db` ([0004](0004-one-sqlite-file.md)). At most one live weigh-in per day; saving a weight for a day that has one replaces its value (the last entry wins). No note: Ekklo's notes are not imported.
- Each app's copy is tied to the weigh-in by a link that records what was written: the day and kilograms for Ekklo, plus the measurement id for MyFitnessPal. What an app still owes is derived from the weigh-ins and the links on each look, with no queue ([0001](0001-recompute-statuses-from-both-sides.md)): a live weigh-in without a link, or whose kilograms differ from its link, is owed a write; a deleted weigh-in whose MyFitnessPal link is live is owed a deletion.
- Both apps only receive. Fūjin never reads a weight back after the import below, so a weight changed or added in either app afterwards is not seen. There is no role setting for body weight: neither app can be two-way (Ekklo's history could, but the owner wants Fūjin alone to decide; MyFitnessPal shows only the first weight of a day).

Import, once:

- On the first weigh-in writer run after this is built, Fūjin reads Ekklo's whole history and stores one weigh-in per day that has none in Fūjin (live or deleted), from the day's latest entry (`updated_at`), rounded to 0.1 kg and skipped when that leaves 0 kg or less (the table refuses it), with an Ekklo link holding those values, so Ekklo owes nothing. A marker on this phone (`Milestone.ekkloWeightsImported` in shared preferences, [0023](0023-ui-flags-in-shared-preferences.md)) stops later runs once an import succeeded; a run whose read fails leaves it unset and the next run tries again; a run on a new phone after a backup import fills only empty days, so it is harmless. A read, so Fūjin DEV runs it too ([0017](0017-read-only-dev-environment.md)).
- The imported weigh-ins have no MyFitnessPal link, so the weigh-in writer writes the whole history to MyFitnessPal, oldest day first, by the rule below.
- Neither the import nor that first write has a screen of its own: no message when the import ends, no progress while MyFitnessPal is written. The Poids page shows each waiting weigh-in with its MyFitnessPal pill, as for any other write. A script copying Ekklo's history to MyFitnessPal before Fūjin's first run was considered and dropped: it would only save the phone those requests, at the cost of a second copy of the MyFitnessPal write rule.

Writes, by a weigh-in writer of their own beside the food's background writer, started by each Journal read that reached either app and after each save or deletion: one weigh-in at a time, oldest day first, a deletion before a new weigh-in of the same day. The two apps are independent: either may fail alone, and its first failure stops that app for the rest of the run, since a session, network or Fūjin DEV refusal would fail every following write too. A network error stops it the same way but records no failure, as for the food ([0054](0054-a-dropped-write-waits.md)): `networkDown(error, readOnly:)` decides, so in Fūjin DEV a refused write stays a failure. Each write reads its weigh-in again just before it is sent, so a weigh-in deleted or corrected while the run is under way is written as it now stands, or not at all. A run asked for while one is going runs once more when it ends (`SingleFlight`, `lib/domain/writing/single_flight.dart`, shared with the background writer). The failures are kept in the writer's state for the screens, with "Réessayer":

- Ekklo: `POST {date, weight}`, which replaces the day's entry; the link then takes the values written. A deletion in Fūjin is not written: Ekklo cannot delete, so the weight stays there and the screen says so.
- MyFitnessPal, through `/v2/measurements` rather than the website's routes, which are undocumented and could change without notice: read the day first. A weight equal to the weigh-in's (within 0.05 kg) is adopted, the link taking its id. Any other weight, written by Fūjin or not, is deleted, and the day read again until it holds none, since a deletion can reveal the next hidden weight, at most 10 reads a day, after which the write fails for this run; then the weigh-in is posted and the link takes the new id. A deletion in Fūjin deletes the linked measurement (a 404 means it is already gone), then the link is soft-deleted.
- Values are rounded to 0.1 kg before they are stored or sent.

Backup file version 6 adds the weigh-ins and their links, which its import replaces; versions 1 to 5 still import and leave the weigh-ins as they are, since they do not describe them and the import from Ekklo would not run again to refill them ([0021](0021-backup-file.md); version 5 is [0052](0052-dated-goals.md)'s dated goals). After an import, `BackupNotifier` also invalidates `weighInsProvider` and runs the weigh-in writer, so the POIDS card and the Poids page show the file's weigh-ins and the apps receive what they owe.

Screens, in French app copy, the feature named "Poids" and one weigh-in "Pesée":

- Where: a "POIDS" section in Réglages, after the goals, with a card that gives today's weigh-in ("Aujourd’hui · 68,9 kg", or "Pas encore de pesée aujourd’hui") and opens the Poids page (W01, W06b). No Journal card and no tab of its own.
- The Poids page lists every weigh-in, newest first, one row per day with its kilograms and the pill of each app that still owes it, and "Nouvelle pesée" pinned at the bottom (W03a); with none, "Pas encore de pesée" (W06a). The curve, its period ("30 jours · 90 jours · Tout") and its summary are drawn but left out of the first version; when they come, the period filters the curve only, never the list.
- "Nouvelle pesée" opens a sheet: today by default, another past day from the day picker (future days greyed), the Fūjin keypad with a "," key, a value from 20,0 to 300,0 kg ("Entre 20 et 300 kg" outside, "Enregistrer" greyed) (W02a). On a day that has a weigh-in, the sheet shows the old value and the button reads "Remplacer la pesée" (W02b).
- After a save, the snackbar "Pesée enregistrée" has no "Annuler": the writer starts at once, and an undone weigh-in already written to Ekklo would stay there. A mistake is corrected from its row (W03b).
- Touching a row opens "Modifier la pesée": the kilograms change, the day does not, and "Supprimer la pesée" asks for a confirmation that says Ekklo keeps the weight (W04a, W04b); swiping a row left opens the same confirmation. A weigh-in deleted while MyFitnessPal still owes the deletion stays in the list, greyed, "Supprimé dans Fūjin · reste dans Ekklo" (W04c).
- Write failures show only on the Poids page: the failed app's pill stops and the snackbar of the food writes says "Pas écrit dans MyFitnessPal" (or Ekklo), which weigh-ins stay waiting, and "Réessayer", which runs the weigh-in writer again (W06c). An expired session is such a failure; reconnecting happens from the Journal's problem card. A refusal in Fūjin DEV uses the same snackbar with the food's DEV sentence and no "Réessayer" (W06d). Offline is waiting, not failure: the pills keep turning, with no snackbar and no card (W06e).

## Consequences

- Fūjin holds the weight history from Ekklo's first entry, and both apps follow Fūjin's values from then on.
- The first run after the import writes about 80 weigh-ins to MyFitnessPal, two requests for a day without a weight (a read and a creation), four for a day holding another one (a read, a deletion, a second read and a creation), two more for each hidden weight, and replaces any MyFitnessPal weight of those days that differs from Ekklo's: a weight logged in the MyFitnessPal app on such a day is lost, on purpose.
- A weight logged in the Ekklo or MyFitnessPal app after the import never reaches Fūjin, and the next write of that day replaces it in both.
- A weigh-in deleted in Fūjin stays in Ekklo.
- A correction costs MyFitnessPal four requests, a read, a deletion, a second read and a creation: the measurement gets a new id each time.
- The import and the first write run unannounced: until MyFitnessPal has the history, the Poids page shows a MyFitnessPal pill on each waiting day, the most recent days last.
- A weigh-in saved by mistake cannot be undone from the snackbar; deleting it from its row leaves it in Ekklo.
