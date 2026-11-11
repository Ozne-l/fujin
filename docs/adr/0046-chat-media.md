# 46. Chat media: processing, edits and background upload

Date: 2026-11-10

## Status

Accepted; not built. The media half of the chat of [0045](0045-ekklo-chat.md). Adds native Android code to Fūjin (a Kotlin method channel and a foreground service) and changes its Android build. Android only: on iOS the chat sends no photo, video or voice message until an AVFoundation equivalent is designed.

## Context

The owner sends his coach five or six videos a week, one to two minutes long, filmed in 1080p at 30 fps; the coach analyses his technique from them, so quality matters. A Pixel 8 original of 88 s is HEVC, 1920×1080 stored with a −90° rotation (portrait), about 19.75 Mbit/s, 221 MB, AAC 48 kHz stereo, with a GPS location tag; the camera also films 10-bit HDR (HEVC Main10, BT.2020 HLG). Re-encoded to H.264 on a Mac, the same clip is 68 MB at 6 Mbit/s; side by side the owner saw no difference between the original, 6 and 8 Mbit/s, and ruled 4 Mbit/s out.

How Ekklo takes media ([0045](0045-ekklo-chat.md) for the calls):

- Each file is presigned (`file_name`, `file_type` such as `video/mp4`, `image/jpeg`, `audio/m4a`, `resource_type` `message_image`, `message_video` or `message_voice`, `resource_id` = the conversation id), then sent as one binary `PUT` to Cloudflare R2 at `upload_url`, valid 3600 s, with `Content-Type` and no `Authorization` (the SigV4 signature covers `host` only). The server picks the object key; `public_url` is `https://assets.ekklo.com/` + `file_key`. R2 accepted 41.5 MB in one request; no limit was found.
- Then one `POST direct-media` with every `public_url` of the message creates it. No body carries a client id or idempotency key: a POST sent twice makes two messages.
- Ekklo's embedded 2.2.0 bundle uploads videos untouched (the capture saw byte-identical bytes) and re-encodes photos to JPEG 0.8 without resizing. Its update of 2026-10-31 resizes photos to 1600 px at JPEG 0.7 and recompresses videos (`react-native-compressor`, `auto`). It shows no thumbnail and no progress, and a failed upload can vanish without an error.

What was verified before this record (Fūjin's Flutter 3.47.7, AGP 9.0.1, KGP 2.3.20):

- On an Android 16 emulator against a fake server (2026-11-09): every package below resolves and builds with Fūjin; `background_downloader` sends a 50 MB binary PUT with exact bytes; a periodic `workmanager` task runs with other plugins; SDR exports with Media3 1.9.2 keep the rotation and drop the location; the Kotlin photo pass works; `video_player` plays m4a and audio-only mp4 with exact durations; `record` records AAC-LC.
- The upload's `onTaskFinished` callback runs about 10 to 30 ms after the PUT ends, in every scenario (app in front, HOME, swiped from Recents, force-stopped and relaunched), but in an engine without plugins: reading secure storage throws `MissingPluginException`, and enqueuing WorkManager work throws a channel error. `dart:io` works there. A WorkManager one-off task registered from the app when the upload is enqueued delivered the authenticated POST 3.8 to 29 s after the PUT ended in all four scenarios. Two traps: after a swipe, `background_downloader` lost the final status, uploaded the file again at the next launch and called the callback a second time; and the callback reports `failed` for an attempt that is then retried.
- On the owner's Pixel 8, Android 17 (2026-11-10): `GlUtil.isYuvTargetExtensionSupported()` is true; HDR to SDR succeeds with OpenGL tone-mapping (4.8 s for 30.3 s of video) and with MediaCodec (11.4 s); the output is H.264 High 4.0, BT.709, 6.0 Mbit/s, rotation kept, AAC copied, no location. Tone-mapped frames have natural colours and are about 37 % darker than the HDR original as the phone shows it. Clipping, two kept passages in one sequence (audio then re-encoded, 10 to 19 ms behind the video, no frozen frame), a centred square crop and removing the sound all pass, in SDR and HDR, in 2.1 to 4.2 s each. Without a foreground service the export froze at 37 % once the app was in the background, then failed with `ERROR_CODE_MUXING_TIMEOUT`; with a `mediaProcessing` service it finished. `ServiceCompat.startForeground` (androidx.core 1.17.0) drops the `mediaProcessing` type and the app crashes with `InvalidForegroundServiceTypeException`; `Service.startForeground` works. A Pixel photo (3072×4080) is Ultra HDR; the pass gives 1639×2048 after a 4:5 crop and a quarter turn, keeps the gain map, drops GPS, make, model and date, in 159 ms with 63.6 MB of bitmaps at peak. The photo picker's copy keeps GPS.

## Decision

Videos:

- Every video is re-encoded once, by Media3 Transformer 1.9.2 in Kotlin: H.264 (Media3 picks High where the encoder has it), 6 Mbit/s, short side at most 1080 px with no upscaling (a `Presentation` only when the short side is larger), the source frame rate, the rotation kept as metadata, the audio copied unless an edit forces re-encoding. Muxer metadata are dropped, except the orientation. There is no "original quality" option.
- HDR input is tone-mapped to SDR: OpenGL when `isYuvTargetExtensionSupported()`, else MediaCodec; when neither works, the original is sent with a warning about its size. The darker SDR output is accepted.
- The export runs inside a `mediaProcessing` foreground service, `MediaProcessingService`, started with `Service.startForeground`, never `ServiceCompat.startForeground`, with a progress notification.
- The message's poster frame is taken from the exported SDR file, not from the HDR original (2 to 2.5 s per frame there, and darker).

Photos: a Kotlin bitmap pass decodes with the largest `inSampleSize` that keeps the long side at 2048 px or more, applies the EXIF orientation, the scale to 2048 px on the long side, the crop and the quarter turns in one `Matrix`, and writes JPEG at quality 85. `Bitmap.compress` keeps the Ultra HDR gain map, which the owner wants kept. Dropping GPS and the other EXIF tags is a side effect, not a requirement.

Edits before sending, chosen by the owner (2026-11-10):

- Photo: crop (free, original, square, 4:5, 16:9, 9:16) and rotate by quarter turns.
- Video: trim the start and the end, remove passages from the middle, crop, remove the sound. No speed change.
- An edit is a pure Dart value in `lib/domain/chat/`: a crop rectangle normalised in the upright picture, quarter turns, the kept segments of a video (trimming keeps one, removing passages keeps several), the sound on or off. The Kotlin side applies it in the same single pass as the compression: kept segments become `EditedMediaItem`s with a `ClippingConfiguration` in one `EditedMediaItemSequence`, the crop a `Crop` effect, the sound `setRemoveAudio`.
- Coordinates: a video crop is given to `Crop` in upright (display) coordinates whatever the rotation: for a rectangle (l, t, r, b) in pixels of the upright W×H picture, `Crop(2l/W − 1, 2r/W − 1, 1 − 2b/H, 1 − 2t/H)`. A photo crop is mapped back through the inverse of the orientation matrix before it reaches `createBitmap`; passing the upright rectangle as is crops the wrong area on a rotated photo.
- The editor is Fūjin's own, in Flutter and the glass style, drawn in Figma first. The preview plays the kept range with `video_player` and jumps over removed passages, so it is approximate where the exported file is exact. The timeline thumbnails come from `MediaMetadataRetriever` through the channel, one by one as they are ready (an HDR frame takes 2 to 2.5 s).

Voice: recorded with `record` 7.1.2 as AAC-LC in an m4a file, mono, 44.1 kHz, 64 kbit/s, with its amplitude every 100 ms for the waveform; between 1 s and 300 s, Ekklo's own limits. `record` gives no duration: Fūjin reads it back with `video_player` and sends it rounded to whole seconds. Received and sent voice messages are played with `video_player`.

Upload:

- A message gets up to 10 media, as in Ekklo's picker, taken with `image_picker` 1.2.4 (`useAndroidPhotoPicker = true`, lost data recovered after the app is killed) or the camera. Each processed file is presigned, then put by `background_downloader` 9.6.6: `UploadTask` with `httpRequestMethod: 'PUT'`, `post: 'binary'`, `mimeType` = the presigned `file_type`, `headers: {'Content-Disposition': ''}`, `priority: 0` and `Config.runInForeground`, a few retries, with its progress shown in the chat and in a notification. An interrupted upload starts again from byte 0. A 403 means the presigned URL expired: a new one is asked for and a new task enqueued.
- A message in progress (its files, their `public_url`, its caption and reply, its state) is a row of `fujin-cache.db` ([0045](0045-ekklo-chat.md)), so the chat shows it after a restart.

Creating the message once its files are up:

- One rule on every path, the anti-duplicate rule: before any `POST direct-media` or `voice-message`, Fūjin reads the conversation's newest page; if a message there already holds that `public_url`, the message is sent and nothing is posted. The object key is the server's and unique per upload, so the check is exact.
- App alive: the app listens to the uploads and posts as soon as every file of the message is `complete`, then cancels the relay.
- App in the background or closed: when the upload is enqueued, the app registers a WorkManager one-off task for the message (unique name, network required, first run after 20 s, linear backoff from 10 s). The upload callback, which has no plugins, records `complete` for its file and nothing else; a `failed` may be retried and is not final. The relay runs with every plugin, reads the token, and posts once every file of the message is recorded complete, after the rule above; until then it asks to be run again. It gives up 24 hours after the message was started, and the message shows as failed with "Réessayer".
- The callback records completion as a row of `fujin-cache.db`, through `package:sqlite3`, which goes through FFI rather than a plugin channel; the directory comes in the task's metadata, since `path_provider` is a plugin. That it opens in that engine is to be checked first in the build; the proven fallback is a marker file written with `dart:io` in the same directory.
- Rejected: posting from the callback (it cannot read the token); the token in the task's metadata (it would sit in plain text in the uploader's preferences); creating the message only at the next opening of Fūjin (the coach would get nothing until then).

Code: the Kotlin side (`MainActivity`'s method channel, `MediaProcessingService`) exports videos, processes photos, extracts frames and sets `FLAG_SECURE`; its Dart side is in `lib/data/media/`, a process edge replaced by a fake in tests ([0012](0012-test-doubles-at-process-edges.md)). The edit value and the rules of a send are in `lib/domain/chat/`, the editor in `lib/pages/chat/`.

Packages: `image_picker` 1.2.4, `video_player` 2.14.1, `record` 7.1.2, `background_downloader` 9.6.6, `workmanager` 0.10.10, `flutter_local_notifications` 22.3.3, `web_socket` (in `ekklo_client`), and in Gradle `androidx.media3:media3-transformer`, `media3-effect` and `media3-common` 1.9.2 (the version `video_player_android` pins; every Media3 module must match), `androidx.exifinterface:exifinterface` 1.4.2 and `androidx.core:core-ktx` 1.17.0.

Android build changes:

- `android/app/build.gradle.kts`: core library desugaring with `desugar_jdk_libs` 2.1.4 (required by `flutter_local_notifications`), and the dependencies above. compileSdk and targetSdk stay Flutter's.
- `AndroidManifest.xml`: `FOREGROUND_SERVICE_DATA_SYNC`, `RUN_USER_INITIATED_JOBS` and `FOREGROUND_SERVICE_MEDIA_PROCESSING`; WorkManager's `SystemForegroundService` overridden with `foregroundServiceType="dataSync"`; `.MediaProcessingService` with `foregroundServiceType="mediaProcessing|dataSync"`. `POST_NOTIFICATIONS` and the microphone are asked at runtime.

Rejected options:

- `just_audio`: `video_player` plays voice messages, and `just_audio` pins Media3 1.4.1.
- `flutter_image_compress`: the Kotlin pass does the same with crop and rotation in one step, and keeps the gain map.
- `flutter_local_notifications` 23.0.0: it needs compileSdk 37, AGP 9.1.1 and Gradle 9.3.1, and brings nothing the chat uses; Fūjin moves to it when Flutter's template moves to compileSdk 37.
- `flutter_cache_manager`: it brings `sqflite`, a second SQLite engine; Ekklo's URLs never change, so files named by URL hash are enough.
- `image_cropper` (a native screen that is not Fūjin's, and a JPEG encoded twice), `pro_image_editor` and `pro_video_editor` (their own interface, and Media3 1.11.1 against `video_player`'s 1.9.2), `video_editor` (last released in 2023, Dart below 3), `ffmpeg_kit_flutter_new` (an abandoned upstream, heavy native binaries, the same work as Media3), the system editor through `ACTION_EDIT` (outside Fūjin, depends on the installed app).

## Consequences

- An 88 s video goes from about 221 MB to about 68 MB, compressed in roughly 0.15 times its length on the Pixel 8 and uploaded in the background with a visible progress.
- A message posted while the app is closed reaches the coach up to about 30 s after its upload ends, more when the network or the system delays WorkManager.
- No path can post the same media twice, even when the uploader repeats an upload after a swipe; a text, which has no URL to look for, is never retried by itself ([0045](0045-ekklo-chat.md)).
- HDR videos reach the coach darker than the owner saw them on his phone.
- Fūjin has native Android code to maintain, and its Android build carries desugaring, three permissions and two service declarations.
- Media3 stays at the version `video_player_android` pins; moving it means moving `video_player` first.
- Not verified: iOS, PQ (HDR10) inputs, phones with neither tone-mapping path, EXIF orientations other than 1 and 6 on the photo pass, the 6 h per day limit of `dataSync` services, and the foreground service started from the background.
