# 47. Chat screens

Date: 2026-11-19

## Status

Accepted; built 2026-11-19. Draws the chat of [0045](0045-ekklo-chat.md) and [0046](0046-chat-media.md), where both left the screens to Figma. Amends [0019](0019-tab-shell.md) (a fourth item in the bar, Messages, that is not a branch), [0045](0045-ekklo-chat.md) (where the chat opens, `users/me` kept in the cache file, the reactions offered, the notification channels and their copy, a full-screen video that plays while it streams) and [0046](0046-chat-media.md) (the camera reached from the media menu, the voice recording rules, the editors on the camera surface, the background work found while building).

## Context

[0045](0045-ekklo-chat.md) left open where the chat opens from, and [0046](0046-chat-media.md) asked for the editors to be drawn in Figma first. A design agent drew every chat screen with the owner from 2026-11-18 to 2026-11-19, in light and dark, on the Playground section of the Figma file "Fūjin · Maquettes", frame "Expérience 6 · Chat Ekklo (ADR 0045, 0046)" (node 628:18884), built from the existing components, styles and variables. The owner validated each of the ten items one at a time; every frame is named "Validé · Ch…". The node ids and the copy in French and English are in `docs/notes/ekklo-chat.md`.

The owner's complaints about Ekklo's chat (0045) shaped the frames: a notification that opens the conversation, older messages that load visibly, media with a thumbnail and a progress, failures that say so, reactions that work.

## Decision

Where the chat opens (amends [0019](0019-tab-shell.md)):

- A fourth tab, « Messages », between Mémoire and Réglages, with a Lucide `message-circle` icon drawn at 80 % of the other icons. Its unread badge sits over the icon, absolutely placed: the count, « 9+ » above 9, nothing at 0. When the chat does not exist (Ekklo not connected, or messaging off), the bar has its three tabs as today.
- The conversation opens full screen over the tabs: no tab bar, a back button in its header. Rejected: a drop on the Journal and a row in Réglages.
- Messages is a bar item, not a shell branch: like the Scanner button, it pushes `FujinRoute.conversation` as a top-level route above the shell, and back (the header's button, Android back, predictive back) pops to the tab that opened it. The shell keeps its three branches, so no tab loses its place when Messages appears or goes. `/messages` redirects to the one conversation, or to the Journal without a chat. Rejected: a fourth `StatefulShellBranch` hidden from the bar without the chat, whose page would be the conversation with the bar hidden; back would be a `goBranch` to the previous tab instead of a pop.

The conversation:

- A fixed header with the coach's name and photo as Ekklo gives them, « Coach Ekklo » under the name, and the messages blurring under it ([0037](0037-progressive-blur-under-fixed-headers.md)). Day separators « Aujourd’hui », « Hier », then the weekday and date.
- At the top, « Chargement des messages plus anciens… » while an older page loads.
- A reply quotes its message; a quoted media shows its kind (« Photo », « Vidéo », « Message vocal »). Reactions are chips overlapping the bottom of the bubble, mine highlighted. A video shows its poster frame, a play button and its duration on a chip readable in both themes. A voice message has play or pause, a waveform whose played part takes the link colour, and the elapsed time. A voice message that does not load shows an alert disc, « Message vocal pas chargé », and loads again when touched.
- The composer: a field with a « Médias » button at its right end, and beside it a « Message vocal » button that becomes « Envoyer » once text is typed. The field grows up to 5 lines, then scrolls inside. No camera button in the composer.
- `can_send` false replaces the composer with « Tu ne peux pas répondre dans cette conversation. » Offline, a card « Pas de connexion » says the conversation can still be read. An expired session shows the « Déconnecté » card with « Se reconnecter à Ekklo », the conversation staying readable.

My messages: a text being sent reads « Envoi… »; a failed one « Non envoyé. » with « Réessayer ». A media message shows « Préparation de la vidéo · 38 % » while the video is exported, then « Envoi · 42 % »; each media not yet up carries a progress ring on an opaque card disc, the accent arc on the goal track, with the percentage in its centre. A failed media message has « Réessayer ». An HDR video that could not be converted says that it goes at its original size, with that size.

Actions on a message:

- A long press shows the quick reactions ❤️ 😆 😮 😢 😡 👍 and a « + » for any other emoji above the message, and a menu with « Répondre », plus « Supprimer » on my own messages only.
- Swiping a message replies to it: the coach's to the right, mine to the left, once the finger has moved 10 px sideways at more than three times its vertical travel; the bubble follows the finger, commits at 64 px with a haptic tick, then stretches like an elastic band towards 96 px (tuned with the motion of [0049](0049-chat-motion.md)) and an accent disc showing the reply icon. A drag that starts on a voice message's waveform scrubs it and never starts a reply. The reply preview sits above the composer, « Réponse à {coach} » or « Réponse à toi », with « Annuler la réponse ».
- Deleting asks in a sheet like K24: « Supprimer ce message ? », an excerpt (or « 2 photos », « Vidéo », « Message vocal »), « Supprimer » and « Garder »; the bubble then reads « Suppression… ». A media message Ekklo refuses to delete gives the snackbar « Pas supprimé dans Ekklo », « Ekklo ne supprime pas encore les médias », with no « Réessayer ». A reaction Ekklo refuses gives « Réaction pas envoyée ».

Media before sending (amends [0046](0046-chat-media.md)):

- « Médias » opens a menu: « Photos et vidéos », « Prendre une photo », « Filmer une vidéo ». The camera is reached only there.
- The tray shows the picked media as thumbnails with « Modifier » and « Retirer » on each, a tile to add more, the count and the coach (« 4 médias · Pour {coach} »), the reply if any, and a caption field. An edited media is marked « Recadrée » or « Coupée ». At 10 media, « 10 médias au maximum par message. » Closing the tray asks « Abandonner ces médias ? » only when a media was edited or a caption typed.
- Both editors use the Scanner's camera surface (the `role/camera/*` colours), the same in light and dark, with « 1 sur 4 » for the media being edited, « Annuler » and « Terminé ».
- Photo editor: crop with a grid and the ratios « Libre », « Original », 1:1, 4:5, 16:9 and 9:16 as chips; « Pivoter », a quarter turn counter-clockwise; « Réinitialiser ».
- Video editor: a timeline whose thumbnails appear one by one, two modes « Couper » and « Recadrer ». Couper trims the start and the end and selects a passage in the middle to « Retirer ce passage », which then reads « Remettre 0:06 »; Recadrer takes the photo ratios; « Son » and « Son coupé »; « Réinitialiser »; the preview plays the kept parts.

Voice message (amends [0046](0046-chat-media.md)): a tap on « Message vocal » starts recording, with a live waveform and the time; the bar has « Supprimer l’enregistrement » and « Envoyer ». Under 1 s, nothing is sent and the alert snackbar says « Message vocal trop court », « Il faut au moins 1 seconde. » At 4:50, « Il reste 10 secondes »; at 5:00 the recording stops and is kept, playable before sending, with « 5 minutes au maximum : enregistrement arrêté ». Going back or leaving the conversation deletes the recording, unless « Envoyer » was already tapped: that one is still sent.

Full screen (amends [0045](0045-ekklo-chat.md)): a photo opens with « 1 sur 2 · hier, 09:13 » and its caption. A video plays at once with its sound while it streams (0045: streamed, only the poster cached): until it plays, its poster is veiled with an endless accent arc, no percentage; a failure reads « Vidéo pas chargée » with « Réessayer ». A tap shows or hides the controls (play, pause, scrubber, « Couper le son »).

Offline and expired (amends [0045](0045-ekklo-chat.md)): `users/me` is kept in `fujin-cache.db` as one row, so whether the Messages item shows, whose messages are mine and the capture protection are known offline and after the session expired. An expired session keeps the chat and its cache readable behind the « Déconnecté » card; only disconnecting Ekklo wipes them.

Notifications (amends [0045](0045-ekklo-chat.md)): two channels, « Messages du coach » (`chat`) and « Envoi des médias » for the export and the upload. A message notification shows the coach's name and the text, or a label for media (« Photo », « 2 photos », « Vidéo », « Message vocal », « 3 médias », followed by the caption when there is one, « Contenu à ouvrir dans Ekklo » for the rest). The media notifications read « Préparation de la vidéo · Pour {coach} · 38 % », « Envoi à {coach} » with « 42% » for one file and « Média 2 sur 3 · 42% » for each file of several, « En attente du réseau », and on failure « Médias pas envoyés », « Touche pour réessayer dans la conversation. » Every notification opens the conversation; none is shown when a send succeeds.

Background work, found while building (amends [0046](0046-chat-media.md)):

- The upload callback opens `fujin-cache.db` through `package:sqlite3` in its plugin-less engine: on an Android 16 emulator (2026-11-19), a callback run after the app was killed mid-upload logged its write, the file's row had `completed_at` and `public_url`, and no marker file was written. The marker file stays only for a write that fails.
- `background_downloader` reschedules killed tasks by itself 5 s after `start()`. The chat already presigns and enqueues again every file that is neither complete nor uploading, so the package's own rescheduling is off (`start(doRescheduleKilledTasks: false)`): with both, a killed upload was sent twice, once to an expired URL.
- The video export, the upload progress and the media notices share one channel, `background_downloader`, named « Envoi des médias », because that package's channel id is fixed.
- Each file of a media message has its own upload notification. On Android 14 and later every upload runs as a user-initiated job that must post its own notification within about 10 s; `background_downloader` 9.6.6 merges the updates of a notification group under one id, so some jobs never post theirs and Android reports the app not responding (seen on the emulator with two videos). Its progress text is the package's own, hence « 42% » without the space of the French copy.
- An upload is identified by its presigned URL: a completion or failure for an earlier URL of the same file is ignored, and a file whose upload has not reported its result is never uploaded again.
- The WorkManager dispatcher is a top-level function: Android resolves a Dart callback by library and name only, so a static method is never found and every run fails.

Icons: the Lucide icons the frames use (`message-circle`, `image`, `camera`, `video`, `mic`, `send`, `play`, `pause`, `external-link`, `loader`, `reply`, `crop`, `scissors`, `rotate-ccw`, `volume-2`, `volume-x`) join `assets/icons/` as SVG in `currentColor`; the reaction bar's « + » reuses `plus.svg`.

## Consequences

- The tab bar shows three or four items depending on the chat; the shell's branches do not change with it, so each tab keeps its place.
- The chat reuses the glass, the edge blur, the K24 sheet, the alert snackbar and the Scanner's camera surface; no new design token is needed.
- Every string of the frames goes to `app_fr.arb` and `app_en.arb`, accessibility labels included.
- iOS still sends no media ([0046](0046-chat-media.md)); its screens are drawn for Android. On iOS the composer has neither the media button nor the voice button: an empty field shows a disabled send button.
