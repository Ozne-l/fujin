# Issue tracker: none, specs live in ADRs

Fūjin uses no issue tracker. A feature's spec is an ADR in `docs/adr/`, listed in `docs/adr/README.md`: the context from the Figma file, the decision, the confirmed copy, what "done" means, and the consequences. Work not built yet says so in its Status ("Accepted, not built"); the Status changes when it is built.

Do not open GitHub issues on `Ozne-l/fujin`.

**PRs as a request surface: no.** A pull request carries the code of one task to `main` ([ADR 0051](../adr/0051-worktrees-pull-requests-and-releases.md)), never a spec. Agents open one only when the owner asks.

"Publish to the issue tracker" means write or amend the ADR. "Fetch the ticket" means read the ADR the owner names.
