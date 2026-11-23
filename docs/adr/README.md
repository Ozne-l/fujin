# Architecture decision records

Each record follows Michael Nygard's format: Title, Status, Context, Decision, Consequences. A record is never rewritten once accepted; a later record supersedes it and says so in its Status.

| # | Decision | Status |
| --- | --- | --- |
| [0001](0001-recompute-statuses-from-both-sides.md) | Recompute statuses from both sides, with a send-link registry and no queue | Accepted (own-copy expectation settled by 0018; unattended items added by 0025; updates reviewed on screen 10 by 0018; extended to every connector by 0044) |
| [0002](0002-write-ordering.md) | Write ordering for add, undo, send and own copies | Accepted (sending implemented by 0018, add and undo by 0026, edit and delete by 0043; Fūjin's database written first, and sends run one at a time, by 0044) |
| [0003](0003-refresh-on-foreground-and-pull.md) | Refresh on foreground return and pull to refresh | Accepted (pull indicator drawn by 0028; selection re-read added by 0029) |
| [0004](0004-one-sqlite-file.md) | One SQLite file, schema and migrations | Accepted (ids and stamps added by 0044; cache file planned by 0044 and amended by 0045: one class for both files, WAL cache recreated on change, busy timeout; built) |
| [0005](0005-backup.md) | Backup: Auto Backup whitelist, manual JSON file | Accepted (B implemented, C implemented by 0021) |
| [0006](0006-riverpod-notifiers-as-presenters.md) | Riverpod notifiers as presenters | Accepted (undo and delete notifier built by 0026 and 0043, edit notifier by 0043, replaced by the background writer's notifier in 0044, import and export by 0021) |
| [0007](0007-dart-mappable-models.md) | dart_mappable models | Accepted |
| [0008](0008-theme-from-design-tokens.md) | Theme from design tokens, motion with motor | Accepted, amended by 0035, 0043 and 0049 (goal rings built by 0022, send progress by 0018; pill, sheet and snackbar motion built; reduced motion added by 0031; `hai-light` darkened by 0032) |
| [0009](0009-french-only-copy.md) | French-only copy | Superseded by 0015 |
| [0010](0010-go-router-navigation.md) | go_router navigation | Accepted (tab plans superseded by 0019) |
| [0011](0011-sessions-in-secure-storage.md) | Sessions in secure storage | Accepted |
| [0012](0012-test-doubles-at-process-edges.md) | Test doubles at process edges only | Accepted |
| [0013](0013-layers.md) | Layers | Accepted (planned memory and settings pages superseded by 0019; `lib/data/backup/` built by 0021, settings pages by 0020 and 0021, sending by 0018, adding by 0026, scanner by 0027) |
| [0014](0014-lints-and-code-style.md) | Lints and code style | Accepted |
| [0015](0015-french-and-english-copy.md) | French and English copy | Accepted |
| [0016](0016-english-in-code-and-tokens.md) | English in code, design tokens and docs | Accepted |
| [0017](0017-read-only-dev-environment.md) | Read-only dev environment | Accepted (barcode lookup let through by 0027; Ekklo chat blocked and replaced by a fake chat by 0045) |
| [0018](0018-send-flow.md) | Send flow: matching, review and execution | Accepted (automatic sends amended by 0025) |
| [0019](0019-tab-shell.md) | Tab shell: Journal and Mémoire tabs, Scanner disabled | Accepted (Scanner enabled by 0027; amended by 0033 and 0037; Messages bar item added by 0047, not a branch) |
| [0020](0020-goals.md) | Goals: one row in Fūjin's SQLite | Accepted (dated goals by 0052) |
| [0021](0021-backup-file.md) | Backup file: fujin-backup v1 behind the BackupFiles seam | Accepted (version 2 by 0027; version 4 by 0044; version 5 by 0052) |
| [0022](0022-journal-states-and-goal-rings.md) | Journal states and goal rings | Accepted (band reads held and neighbour weeks prefetched by 0029; MyFitnessPal foods shown with Ekklo missing and offline by 0030) |
| [0023](0023-ui-flags-in-shared-preferences.md) | UI flags in shared preferences | Accepted (settings and `FujinPreferences.open` added by 0025; connector roles kept there by 0044) |
| [0024](0024-splash-from-the-first-frame.md) | Splash from the first frame | Accepted |
| [0025](0025-automatic-mode.md) | Automatic mode: unattended items instead of Memory, a setting in shared preferences | Accepted (unattended items kept on the Ekklo link, and in the backup file, by 0044) |
| [0026](0026-adding-a-food.md) | Adding a food: one draft, the send flow's Ekklo half, undo | Accepted (scanner and 02d built by 0027; remembered foods added to the search, and "Ajouter" to screen 19, by 0034; undo moved to `RemoveEntryService` by 0043, then to `EditEntryService.remove` by 0053; fiche closing at once by 0044) |
| [0027](0027-barcode-scanner.md) | Barcode scanner: full-screen camera, barcode links in Memory, backup v2 | Accepted (built) |
| [0028](0028-fujin-drawn-controls.md) | Fūjin-drawn controls instead of stock Material | Accepted (Android stretch under the pull replaced by the bounce in 0038) |
| [0029](0029-journal-reads-held-for-display.md) | Journal reads held in memory for display, writes read live | Accepted (entries shown from Fūjin's database by 0044) |
| [0030](0030-mfp-foods-shown-when-a-side-is-missing.md) | MyFitnessPal foods shown when Ekklo or the network is missing | Accepted |
| [0031](0031-reduced-motion.md) | Reduced motion follows the phone setting | Accepted, amended by 0049 (iOS setting read, meaningful entrances dissolve) |
| [0032](0032-text-contrast.md) | Text roles meet 4.5:1 on page and card | Accepted |
| [0033](0033-liquid-glass-and-fade-through.md) | Liquid glass tab bar and fade-through navigation | Proposed (extended by 0036; top fade replaced by 0037; glass settings and rim superseded by 0041) |
| [0034](0034-remembered-foods-in-the-add-search.md) | Remembered foods in the add search, and "Ajouter" on screen 19 | Accepted |
| [0035](0035-dark-theme-and-appearance-setting.md) | Dark theme and the "Apparence" setting | Accepted (glass rim superseded by 0041) |
| [0036](0036-glass-on-buttons-search-and-filters.md) | Glass on buttons, the search field and filters | Proposed (rims, fills and tinted text superseded by 0041) |
| [0037](0037-progressive-blur-under-fixed-headers.md) | Progressive blur under fixed headers | Proposed |
| [0038](0038-bouncing-scroll-on-every-platform.md) | Bouncing scroll on every platform | Proposed |
| [0039](0039-app-version.md) | App version | Accepted |
| [0040](0040-flutter-sdk-per-project.md) | Flutter SDK per project | Accepted |
| [0041](0041-liquid-glass-renderer-1.0.md) | Liquid glass on liquid_glass_renderer 1.0 | Proposed, amended by 0048 (pub.dev pin replaced by a patched copy in third_party) and 0050 (the patched package comes from the owner's fork) |
| [0042](0042-text-contrast-on-tinted-surfaces.md) | Text contrast on tinted surfaces | Accepted |
| [0043](0043-edit-and-delete-a-logged-food.md) | Edit and delete a logged food | Accepted (edit and delete saved first and written in the background, and offline edit and delete of known foods built, by 0044; delete moved to `EditEntryService.remove` by 0053) |
| [0044](0044-connector-model.md) | Connector model: Fūjin's entry at the centre | Accepted (steps 1 to 4 built, offline included, and the role setting, kept in shared preferences; foods without servings completed from MyFitnessPal after an online Journal read; Ekklo "to remove" and Ekklo two-way not built; chat and cache file built by 0045 to 0047) |
| [0045](0045-ekklo-chat.md) | Ekklo chat: contract, sync, cache file, notifications, fake chat in dev | Accepted, amended by 0049 (built; screens drawn by 0047; seen mark added by 0049) |
| [0046](0046-chat-media.md) | Chat media: processing, edits and background upload | Accepted (built on Android; screens drawn and background work amended by 0047) |
| [0047](0047-chat-screens.md) | Chat screens: Messages tab, conversation, media tray and editors, voice, full screen, notification copy | Accepted (built) |
| [0048](0048-patched-liquid-glass-renderer.md) | Patched liquid_glass_renderer in third_party | Superseded by 0050 |
| [0049](0049-chat-motion.md) | Chat motion, shared-element flights and haptics | Accepted |
| [0050](0050-liquid-glass-renderer-from-the-fork.md) | liquid_glass_renderer from the owner's fork | Accepted |
| [0051](0051-worktrees-pull-requests-and-releases.md) | Worktrees, pull requests with CI, and signed releases installed by Obtainium | Accepted (built; first release v0.6.1, Pixel moved to the release key) |
| [0052](0052-dated-goals.md) | Dated goals: each set holds from the day it is saved, backup version 5 | Accepted |
| [0053](0053-one-rule-for-the-held-ekklo-job.md) | One rule for the held Ekklo job, in the background writer | Accepted |
| [0054](0054-a-dropped-write-waits.md) | A dropped write waits, like a failed read | Accepted |
