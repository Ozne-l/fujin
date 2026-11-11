# 45. Ekklo chat

Date: 2026-11-10

## Status

Accepted; not built. Builds the chat that [0044](0044-connector-model.md) defers, on its connector contract and its cache file `fujin-cache.db`. Amends [0004](0004-one-sqlite-file.md) (one database class for both files, the cache file's rules, a busy timeout on every connection) and [0017](0017-read-only-dev-environment.md) (the dev guard blocks the Ekklo chat, and dev talks to a fake chat). The media of the chat (photo and video processing, edits before sending, background upload, creating a media message when the app is closed) are in [0046](0046-chat-media.md). The screens go through Figma before the build.

## Context

The owner's coach talks to him through the chat of the Ekklo app ("Messagerie"). The owner finds it hard to use (2026-11-05): push notifications arrive about one time in five and stay on after the message was read in the chat, messages are sometimes shown wrong or not refreshed, older messages do not load properly, media are sent with no thumbnail and no progress bar and sometimes fail without an error, and reactions barely work. A notification never opens the conversation. He wants Fūjin to be a reliable client of that chat, nothing more: no tie with the Journal.

What Ekklo exposes was read without sending anything on the owner's conversation from an agent: a static reading of the Hermes bundle of Ekklo 2.2.0 and of its Expo update of 2026-10-31, three read-only schema probes on the owner's account (types, key paths and counts only; the third walked the whole history, 343 messages from 2026-04 to 2026-11, in 7 pages), a passive mitmproxy capture of the official app on an emulator while the owner sent one video-and-photo reply and one voice message, and a probe of Ekklo's token refresh. The evidence is in `ekklo_client/doc/` (`MESSAGING_BUNDLE_FINDINGS.md`, `MESSAGING_SCHEMA_PROBE.md`, `_V2`, `_V3`, `MESSAGING_SEND_CAPTURE.md`, `MESSAGING_OTA_DIFF.md`); the facts that decide this record are repeated here.

The contract, all paths under `https://api.prod.ekklo.com/api`, every call with `Authorization: Bearer`:

| Call | Request | Answer and observed behaviour |
| --- | --- | --- |
| `GET /v1/users/me` | | `id` (string), `settings.messaging` (true for the owner), `screen_capture_protection` (false), `coaches_settings[]` with `coach_id` and `screen_capture_protection` (true for his coach) |
| `GET /v1/messaging/conversations` | | `{conversations: [...]}`; one conversation for the owner, with `id`, `coach`, `customer`, `can_send` (true), `unread_count`, `is_pinned`, `updated_at` and `last_messages` (an array, newest first, without `media_urls`) |
| `GET …/conversations/{id}/messages` | `limit` (Ekklo uses 50), `before_id` | `{messages, has_more, total}`. Messages within a page are **oldest first**. `before_id` = the first (oldest) message of the previous page gives the next older page with no overlap; `has_more` false ends the walk. `total` is wrong (43 at the end of a 343-message walk). Ekklo's own app passes the last message of the page, the newest, which is probably why its history does not load properly |
| `POST …/{id}/messages` | `{content, reply_to_id}` (no `message_type`) | the message |
| `POST …/{id}/direct-media` | `{medias: [{url, media_type}], caption, reply_to_id}` for files already uploaded ([0046](0046-chat-media.md)); no `caption` key when there is no text | 201 and the message, `content` `""`; one image and one video give `message_type` `mixed` |
| `POST …/{id}/voice-message` | `{url, duration, reply_to_id}`, `duration` in whole seconds | 201 and the message (`audio`), with no duration in it |
| `POST /v1/uploads/presigned-url` | `{file_name, file_type, resource_type, resource_id}` | `{upload_url, file_key, public_url, expires_at}`, the upload URL valid 1 hour ([0046](0046-chat-media.md)) |
| `DELETE …/{id}/messages/{msgId}` | | text: deleted; image, video and voice messages: **HTTP 500 with an empty body**, 10 times out of 10 in the capture and from the owner's phone; both test messages are still in the conversation |
| `POST …/{id}/messages/{msgId}/reactions`, `DELETE` (same path, body) | `{emoji}` | `{emoji, count, mine}` (from the bundle, not observed) |
| `POST …/{id}/read` | | not observed; the app calls it only when the open conversation has `unread_count > 0` |
| WebSocket `wss://api.prod.ekklo.com/api/v1/messaging/ws` | `Authorization` header; the client's only frame is `{event: "focus_conversation", data: {conversation_id}}` | events `{event, data}`: `new_message`, `message_deleted`, `message_edited`, `message_read`, `reaction_added`, `reaction_removed`. The server pings every 58 to 60 s, and the connection drops without a close frame (1006) on a steady 60 s cycle; Ekklo reconnects about 1 s later. The echo of an own media message came after the POST answer and equal to it; no echo came for the voice message (one sample) |

Message shape: `id` (string), `sender_id` ("mine" when it equals `users/me` `id`), `content`, `message_type`, `media_urls`, `created_at`, `conversation_id`, `internal`, `is_read`, and when present `reply_to` (`{id, sender_id, sender_name, content, message_type, deleted}`), `reactions` (`[{emoji, count, mine, sample_user_ids}]`) and `content_ref`. Optional keys are omitted, never null. Types in the history: `text` 295, `video` 22 (1 to 4 mp4 each), `audio` 16 (m4a or mp4), `image` 7 (jpg, png), `mixed` 3 (mp4 and jpg in one message); `content_ref` 0 times; `internal` always false; `is_read` true on every message, own ones included from their creation, so it is not a "seen" mark. Media URLs are public on `assets.ekklo.com` (no auth, no signature, `Accept-Ranges: bytes`, images and videos `max-age=14400`); the bundle also accepts a bare key, prefixed with `https://assets.ekklo.com/ekklo/`.

Push: Ekklo sends through Expo to a single `customer_push_token` per user. Fūjin cannot receive those pushes, and writing its own token there would evict the Ekklo app's, which writes its own back at its next launch. The official app also sends `PUT /v1/users/{id}/connection-state` on each return to the foreground, with a body of unknown shape.

Session: the refresh probe (2026-11-09) found access tokens of 3600 s, refresh tokens of 36,000,000 s (416.7 days), with or without `?mobile`. A refresh returns a new refresh token, and the old one is still accepted afterwards (tried 0.1 s after its first use) without revoking the newer one; two refreshes of the same token sent together both succeed, and both lineages stay usable. An access token stays valid after a refresh.

## Decision

Scope of v1:

- Read a conversation and send text, photos, videos and voice messages, reply to a message, react, and delete one's own messages. No edit, no documents (`file-message`), no pinning, no list of who reacted, no presence (`connection-state`), no push token.
- A message Fūjin cannot show (`content_ref`, an unknown `message_type`) is a bubble "Contenu à ouvrir dans Ekklo". A message with `internal` true is not shown.
- The chat is a part of the Ekklo connector, not a domain with a Role ([0044](0044-connector-model.md)): no setting. It exists when Ekklo is connected and `users/me` `settings.messaging` is true; otherwise nothing of it shows. `can_send` false hides the composer. An expired Ekklo session shows the same "reconnect to Ekklo" card as the Journal. Where the chat opens from is drawn in Figma.

Reading:

- `package:ekklo_client` gets a messaging resource (users/me fields above, conversations, a page of messages, the sends, presign, delete, read, reactions), a timeout per call (120 s for `direct-media`, as Ekklo), `DELETE` with a body, and `EkkloMessagingSocket`. The socket uses `package:web_socket` through `IOWebSocket`, the only way to send the `Authorization` header, so `ekklo_client` becomes `dart:io` only. The socket's channel factory is injected.
- Decoding: `message_type` `text`, `image`, `video`, `audio` or `voice` (both are voice: every URL is a voice file), `mixed` (each URL takes its kind from its extension); absolute URLs as they are, bare keys under `https://assets.ekklo.com/ekklo/`; `content` is the caption of a media message. `is_read`, `read_by_other` and `sample_user_ids` are not used, so there is no "seen" mark.
- Older messages: `before_id` = the oldest message of the previous page, until `has_more` is false; `total` is ignored.
- While the app is in the foreground with the chat available, the socket is open; it is closed when the app is paused. Before each connection the token is refreshed if it is about to expire. A drop, the 60 s cycle included, is followed by a reconnection, at once the first time, then after `min(30 s, 2ⁿ s)`; a successful connection resets the delay. While a conversation is open, `focus_conversation` is the first frame of each connection, as Ekklo does (its effect on the server is unknown).
- After each connection, Fūjin reads the conversations again and, for an open conversation, its newest page, then older pages until one holds a message already cached. Events are applied by pure reducers in `lib/domain/chat/`: `new_message` and `message_edited` insert or replace by id, `message_deleted` removes, a reaction event sets `count` from `new_count` and sets `mine` from `mine_now` only when its `user_id` is the owner's (the bundle copies `mine_now` as is; whether the server personalises it is unknown). `message_read` is ignored.
- Duplicates are dropped by id; Fūjin never waits for the echo of its own message: the answer of the POST replaces the pending bubble.

Cache, `fujin-cache.db` ([0044](0044-connector-model.md)): conversations and messages as rows with indexed columns (ids, `conversation_id`, `created_at`) and the JSON as received, so a new field or a decoding change needs no migration. The whole history is kept: the first opening walks it (7 requests today). A newest page read again replaces the cached messages from its oldest one onward, so a message deleted there disappears; older deletions are seen through `message_deleted` only. Media are never stored in SQLite: images and voice messages are files named after a hash of their URL (Ekklo's URLs never change), in the app's cache directory; videos are streamed with `video_player` (ranges), and only their poster frame is kept. Offline, the chat is read-only from the cache. Disconnecting Ekklo deletes the cache file, the media files, the chat's notifications and its background work.

Database (amends [0004](0004-one-sqlite-file.md)):

- `FujinDatabase` stays the only class that touches `package:sqlite3`, now opened with a schema: `fujin.db` with today's migration scripts and `FujinTable`, `fujin-cache.db` with one creation script, a version and its own table enum. Both enums implement one table interface, and the database is typed by its enum, so writing a cache table into `fujin.db` does not compile.
- `fujin.db` keeps `journal_mode = DELETE`, so that a backup stays one file. `fujin-cache.db` uses WAL: the app, the chat's background task and the upload callback ([0046](0046-chat-media.md)) each open their own connection to it, from their own isolates in the same process (more than one connection from isolates sharing one `libsqlite3` is not verified yet).
- Every connection, to either file, sets `busy_timeout` to 5000 ms, so a second connection waits for a lock instead of failing with `SQLITE_BUSY`.
- When the cache's version differs from the code's, the UI isolate deletes the file (with its `-wal` and `-shm`) and creates it again; a background isolate that finds another version skips its run. The cache file sits next to `fujin.db`; the Auto Backup rules name `fujin.db` only, so it is not backed up ([0005](0005-backup.md)). No transaction spans the two files.
- The rule covers Fūjin's Dart code: WorkManager brings androidx.room, which keeps its job database in Android's own SQLite; the APK still ships only the `libsqlite3.so` of `package:sqlite3`.

Sending text, reacting, deleting, reading:

- A text is shown at once as a pending bubble, then replaced by the POST's answer. A failure leaves it failed with "Réessayer", never retried by itself: Ekklo takes no client id or idempotency key, so a lost answer retried could send the message twice. "Réessayer" first reads the newest page; an own message with the same text created after the first attempt means it was sent.
- A reply sends `reply_to_id`; text, media and voice messages all take it.
- A reaction is toggled at once and rolled back if the call fails; the server's `{count, mine}` wins.
- Deleting an own message (for both sides, after a confirmation) is not optimistic: the bubble shows that it is being deleted until a 2xx or `message_deleted`. On a media message Ekklo answers 500; Fūjin shows that Ekklo cannot delete that message yet and keeps it, and the same action will work the day Ekklo fixes its server.
- Opening a conversation whose `unread_count` is above 0 sends `/read` and removes its notification. Only the app in the foreground sends `/read`.

Notifications (Ekklo's push being out of reach):

- A WorkManager periodic task (`workmanager` 0.10.10) every 15 minutes, Android's minimum, when the network is up, registered while the chat is available. It runs in the app's process in its own isolate, where the plugins work (secure storage, notifications). It calls `GET /v1/messaging/conversations` and nothing else, never `/read`, and skips its run when the app was in the foreground in the last 2 minutes, which the app records in `fujin-cache.db` on each return to the foreground and each socket connection.
- One notification per conversation, built from the unread `last_messages` sent by others (`flutter_local_notifications` 22.3.3, `MessagingStyle`, category message, channel `chat` with high importance, `onlyAlertOnce`), updated in place, a media shown by a label for its type. Tapping it opens the conversation. It goes away when the conversation is read in Fūjin or its `unread_count` falls to 0. Notification permission is asked from the chat.
- Visibility `private`. FLN has no public version, so the lock screen shows the content under Android's default "show all content", and only the app name once the owner chooses "hide sensitive content" in Android's settings; the owner accepted this (2026-11-09).
- The owner turns off message pushes in the Ekklo app himself.
- Rejected: Ekklo's Expo push (single token, evicted by the Ekklo app); a foreground service holding the socket (a permanent notification and battery for little gain over 15 minutes); a shorter period (Android does not run periodic work more often than every 15 minutes).

Session: no lock between the app and the background task. Each isolate refreshes through `ekklo_client`'s transport, whose refresh first reads the token store again and keeps tokens another isolate already refreshed; when both refresh the same token, both answers are valid (refresh probe), and the last one written wins. Tokens stay in secure storage ([0011](0011-sessions-in-secure-storage.md)).

Screen capture: the chat's screens set `FLAG_SECURE` (through the native channel of [0046](0046-chat-media.md)) while `users/me` `screen_capture_protection` or the `coaches_settings` entry of the conversation's coach is true, and clear it when they close. The owner's coach has it on.

Dev and tests (amends [0017](0017-read-only-dev-environment.md)):

- Fūjin DEV never shows the production chat. Its guard blocks every request under `/api/v1/messaging` and `/api/v1/uploads`, reads included, and its socket factory never connects to Ekklo.
- DEV talks to a fake chat instead: a fake Ekklo messaging backend in Dart, served on a loopback `HttpServer` inside the dev app, because `video_player`, the uploader and `MediaMetadataRetriever` fetch URLs natively, outside `http.Client`. It is seeded at each launch with one conversation holding every kind of message in the history's proportions (text, image, video, `mixed`, voice in m4a and mp4, replies, reactions), with oldest-first pages, a working `before_id`, omitted optional keys and `content` `""` on media, and media from assets packaged for the dev flavor only. Sends work and come back as `new_message`; deleting a text works and sends `message_deleted`; deleting a media message answers 500 with an empty body, as Ekklo; `screen_capture_protection` is false, so the screens can be captured while they are designed. Cleartext is allowed to the loopback address only, in the dev flavor.
- The same fake backend serves the tests through `FakeBackends` and an in-memory socket, at the process edge ([0012](0012-test-doubles-at-process-edges.md)).

Code: `ekklo_client` (REST and socket), `lib/domain/chat/` (the pure reducers and decoding rules, `ChatService` for the socket, the resync and the sends), `lib/data/chat/` (the cache repository), `lib/pages/chat/` ([0013](0013-layers.md)).

## Consequences

- A notification comes up to 15 minutes after the message, more under Doze or battery saving; while the app is open, messages arrive through the socket.
- The coach may see the owner as offline, or as last seen in the Ekklo app, while he uses Fūjin, since presence is not sent.
- A media message cannot be deleted until Ekklo fixes its server; the action stays and fails clearly.
- A message deleted by the coach while Fūjin was closed stays in the cache when it is older than the newest page.
- The first opening walks the whole history; later openings read one page or a few.
- The background task and the upload callback write to `fujin-cache.db` while the app may be reading it; WAL and the busy timeout are what make that safe, and the multi-isolate access is to be checked early in the build.
- The absence of a lock rests on Ekklo accepting a reused refresh token. If Ekklo starts revoking a refresh token on reuse, a race between the app and the task can sign the owner out of Ekklo in Fūjin, and a lock shared by the isolates becomes necessary.
- Fūjin DEV shows a made-up conversation, never the owner's; the owner judges the chat on the fake one and on the production app.
- A schema change of the cache costs one walk of the history, and drops the pending sends of [0046](0046-chat-media.md) still waiting in it.
