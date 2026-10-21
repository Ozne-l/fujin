# 27. Barcode scanner

Date: 2026-10-12

## Status

Accepted. Built in `lib/pages/scanner/`. Builds the scanner left out by [0026](0026-adding-a-food.md), enables the Scanner button that [0019](0019-tab-shell.md) draws disabled, adds a table to the Memory and a version 2 to the backup file of [0021](0021-backup-file.md), and allows one MyFitnessPal `POST` through the dev guard of [0017](0017-read-only-dev-environment.md).

## Context

Section "03 Scan" of the Figma file "Fūjin · Maquettes" draws a full-screen camera, then "une feuille par issue du code-barres : a trouvé, b reconnu sans fiche, c inconnu, d invalide, e service indisponible. Plus la variante code magasin." Each outcome has a frame:

- 03a "Scan, visée": camera, aiming frame, "Place le code-barres dans le cadre", "Fermer", a torch button top right, "Saisir le code" at the bottom. Its note: the read is automatic, with no trigger; the meal and date are recalled; a short vibration (`HapticFeedback.mediumImpact`) when a code is read.
- 03b "Scan, saisie manuelle": the same camera behind a numeric keypad and "Chercher ce code". Its note: the format is checked while typing (8, 12, 13 or 14 digits, check digit); the button is enabled only for a valid code.
- 03c "Scan, aliment trouvé" (outcome a): a sheet with "MyFitnessPal · trouvé par code-barres", the name, brand and kilocalories, "Non vérifié", the EAN, "Saisi par un membre de MyFitnessPal. Vérifie que c'est bien ton paquet avant de continuer.", "C'est bien ce produit" and "Pas le bon produit : chercher par texte".
- 03d "Scan, reconnu sans fiche" (outcome b): "Produit reconnu, sans fiche", "MyFitnessPal connaît ce code (Riz Basmati, Taureau Ailé) mais n’a pas ses valeurs nutritionnelles.", "Chercher « Riz Basmati Taureau Ailé »", which opens the prefilled text search (02d), and "Rescanner".
- 03e "Scan, code inconnu" (outcome c): "Code-barres inconnu", "Le code 809722878566 n’est pas dans la base MyFitnessPal. Cherche le produit par son nom, ou crée-le dans l’app MyFitnessPal.", "Chercher par texte" and "Rescanner".
- 03f "Scan, code invalide" (outcome d): no sheet; the keypad of 03b shows "Chiffre de contrôle 9, 8 attendu" and "Vérifié sur le téléphone, rien n’a été envoyé. Corrige le dernier chiffre.", and "Chercher ce code" stays disabled.
- 03g "Scan, service indisponible" (outcome e): "Codes-barres indisponibles", "Le service code-barres de MyFitnessPal ne répond pas. La recherche par texte, elle, fonctionne.", "Chercher par texte" and "Réessayer le scan". Its note: no retry in the background, only the button.
- 03h "Scan, code magasin": outcome a for a code that starts with 02 or 20 to 29, where a pill "Code magasin" replaces the EAN pill and a line is added under the note of an unverified food: "Les codes qui commencent par 02 ou 20 à 29 sont attribués par chaque enseigne : ce produit n’est peut-être pas le tien."
- 02d, a note in the search section (outcome b): MyFitnessPal knows the code but has no food card; the text search opens with the name and brand under a banner saying why, and the chosen barcode-to-food link is kept in the Memory so the next scan of the same package offers that food directly.

A refused camera and the loss of network during a lookup have no frame. The lookup already exists for typed codes (A02c): `foods.byBarcode` in `package:myfitnesspal_client` returns `MfpBarcodeFound`, `MfpBarcodeUnknown` or `MfpBarcodeUnresolved` (name and brand without a food), and throws `MfpBarcodeException`. It is the only caller of the sync endpoint (`POST /iphone_api/synchronize` on the sync host); diary writes go through `POST` and `DELETE /v2/diary` on the API host.

## Decision

Screens take the add flow's "A" prefix ([GLOSSARY](../../GLOSSARY.md)): A03a to A03h as drawn, A02d for the prefilled search, and what has no frame:

- A03b checks the code while typing with `checkBarcode`; A03f is that check failing. A code read by the camera that fails the check opens A03b with that code and the A03f error.
- A03d is `MfpBarcodeUnresolved`, and a found food without any serving size; A03e is `MfpBarcodeUnknown`; A03g is `MfpBarcodeException` or a transport failure.
- A03g without network gets its own title and text (table below), since "La recherche par texte, elle, fonctionne" is false offline.
- A03i, camera refused: the reason, and "Saisir le code" as the way on. No extra package to open the phone settings.

Flow:

- The scanner is a full-screen route pushed above the tabs, not a branch. It opens from the Scanner button of the tab bar and from a round button bottom right of A02a, drawn like the tab bar's.
- The tab bar's Scanner button is greyed where adding is impossible, as the Figma "Lisez-moi · développement" asks ("Le Scanner est sur les trois onglets, grisé là où l'ajout est impossible (hors ligne, session MyFitnessPal ou Ekklo expirée : rien n'est écrit d'un seul côté)"; component "Barre d'onglets", variants `Scanner=Disponible` and `Scanner=Grisé`). The latest Journal read of the selected day decides, on all three tabs (`addingPossible`, `lib/domain/adding/adding_possible.dart`): greyed when either side, or the whole read, failed offline or with an expired session; usable on a full read, before the first read ends, and when a service is down or fails otherwise, which A03g covers. While a read runs, the previous decision stays. Greyed means the icon in `textDisabled`, no ink, no action, and announced disabled. The round button of A02a is not greyed.
- From the tab bar it starts on the day shown in the Journal (`SelectedDay`) and the meal of the time of day, by the position of the meal in the MyFitnessPal diary: the first (breakfast) before 11:00, the second (lunch) from 11:00, the fourth (snacks) from 16:00, the third (dinner) from 18:00. From A02a it takes the search's day and meal. A03a recalls them.
- A code read once is looked up once: the Memory first, then `foods.byBarcode`. A Memory hit opens the A03c sheet with its food.
- "C'est bien ce produit" opens the food card (A04) of [0026](0026-adding-a-food.md), where meal and date stay editable as for any add. "Pas le bon produit : chercher par texte" and the search button of A03d open the search prefilled with the name and brand; from A03d it opens under the A02d banner. "Chercher par texte" on A03e and A03g opens the search empty.
- When a food reached from a scan through the search is added, the barcode-to-food link is kept in a new Memory table, `memory_barcode`, keyed by the code. The next scan of that code offers that food.

Platform: `mobile_scanner` for the camera and decoding (version and licence pinned when added), the `CAMERA` permission on Android and `NSCameraUsageDescription` on iOS, in French and English through `InfoPlist.strings`. The camera reads with `DetectionSpeed.normal`: with `noDuplicates`, the Android side never reports again the code it read last until the camera restarts, so "Rescanner" could not read the same package twice. The scanner state alone makes a read code looked up once: a read is ignored unless the scanner is aiming. The torch is applied again whenever the camera starts running, since the camera is rebuilt after the food card. The status bar is light over the camera only: `FujinApp` gives every page dark status bar icons (`FujinSystemBars.of(colors, brightness)`, following the theme since [0035](0035-dark-theme-and-appearance-setting.md)) and the camera scaffold overrides them (`FujinSystemBars.camera(colors)`) while it is shown, so the food card and the page left after closing get dark icons back.

Backup: version 2 of `fujin-backup` adds the barcode links. Import accepts versions 1 and 2 and still replaces every table, so a version 1 file leaves no barcode link.

Dev guard: `ReadOnlyHttpClient` allows `POST` to the MyFitnessPal sync origin and the exact path `/iphone_api/synchronize`, as it allows the Ekklo sign-in paths.

Copy of what has no frame, confirmed by the owner:

| Screen | Title | Text | Actions |
|---|---|---|---|
| A02d banner | | « MyFitnessPal connaît ce code-barres mais n'a pas de fiche pour cet aliment. Choisis-le dans la recherche. » | |
| A03c from Memory | | source line « Mémoire · retenu pour ce code-barres » | as A03c |
| A03g offline | « Pas de connexion » | « Le code {code} n'a pas pu être cherché. » | as A03g |
| A03g, MyFitnessPal session expired | « Session MyFitnessPal expirée » | « Reconnecte-toi pour chercher le code {code}. Il est gardé. » | « Se reconnecter à MyFitnessPal », then the lookup again |
| A03i | « Pas d'accès à l'appareil photo » | « Autorise l'appareil photo pour Fūjin dans les réglages du téléphone, ou saisis le code à la main. » | « Saisir le code » |

Done when:

- Every outcome, the Memory hit and the store-code pill are reached in tests from `FakeBackends`.
- A version 2 backup round-trips, and a version 1 file still imports.
- The guard's test lets the sync path through in dev and still stops any other MyFitnessPal `POST`.
- `GLOSSARY.md` lists A02d and A03a to A03i in its Screens table and defines the barcode link; the Status lines of [0017](0017-read-only-dev-environment.md), [0019](0019-tab-shell.md) and [0021](0021-backup-file.md) point to this record.

## Consequences

- A scan never writes on its own: every add still goes through the food card and the write order of [0002](0002-write-ordering.md).
- The dev app can look barcodes up. If the client ever sends a write through the sync endpoint, the guard lets it through; the guard's test pins the one allowed path so such a change is visible.
- The meal-by-hour rule assumes the MyFitnessPal default order of four meals (breakfast, lunch, dinner, snacks); with other meals, the owner picks on the food card.
- Barcode links are not listed in the Mémoire tab; a wrong link is replaced the next time a scan ends on another food through the search.
