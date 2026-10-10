# Architecture decision records

Each record follows Michael Nygard's format: Title, Status, Context, Decision, Consequences. A record is never rewritten once accepted; a later record supersedes it and says so in its Status.

| # | Decision | Status |
| --- | --- | --- |
| [0001](0001-recompute-statuses-from-both-sides.md) | Recompute statuses from both sides, with a send-link registry and no queue | Accepted (own-copy expectation settled by 0018) |
| [0002](0002-write-ordering.md) | Write ordering for add, undo, send and own copies | Accepted (sending implemented by 0018; add and undo planned) |
| [0003](0003-refresh-on-foreground-and-pull.md) | Refresh on foreground return and pull to refresh | Accepted |
| [0004](0004-one-sqlite-file.md) | One SQLite file, schema and migrations | Accepted |
| [0005](0005-backup.md) | Backup: Auto Backup whitelist, manual JSON file | Accepted (B implemented, C planned) |
| [0006](0006-riverpod-notifiers-as-presenters.md) | Riverpod notifiers as presenters | Accepted |
| [0007](0007-dart-mappable-models.md) | dart_mappable models | Accepted |
| [0008](0008-theme-from-design-tokens.md) | Theme from design tokens, motion with motor | Accepted |
| [0009](0009-french-only-copy.md) | French-only copy | Superseded by 0015 |
| [0010](0010-go-router-navigation.md) | go_router navigation | Accepted (tab plans superseded by 0019) |
| [0011](0011-sessions-in-secure-storage.md) | Sessions in secure storage | Accepted |
| [0012](0012-test-doubles-at-process-edges.md) | Test doubles at process edges only | Accepted |
| [0013](0013-layers.md) | Layers | Accepted (planned memory and settings pages superseded by 0019) |
| [0014](0014-lints-and-code-style.md) | Lints and code style | Accepted |
| [0015](0015-french-and-english-copy.md) | French and English copy | Accepted |
| [0016](0016-english-in-code-and-tokens.md) | English in code, design tokens and docs | Accepted |
| [0017](0017-read-only-dev-environment.md) | Read-only dev environment | Accepted |
| [0018](0018-send-flow.md) | Send flow: matching, review and execution | Accepted |
| [0019](0019-tab-shell.md) | Tab shell: Journal and Mémoire tabs, Scanner disabled | Accepted |
