# Issue tracker: GitHub

Fūjin's issues and specs are GitHub issues on `Ozne-l/fujin`. Every operation goes through the `gh` CLI, run from the repo root so `gh` picks the repository from `origin`.

| Operation | Command |
|---|---|
| Create | `gh issue create --title "..." --body-file -` with the body on stdin (heredoc) |
| Read | `gh issue view <n> --json number,title,body,labels,comments` |
| List | `gh issue list --search "..." --json number,title,labels`; add `--label` to narrow, `--state all` to include closed ones |
| Comment | `gh issue comment <n> --body "..."` |
| Label | `gh issue edit <n> --add-label "..."` or `--remove-label "..."` |
| Sub-issue | `gh issue edit <parent> --add-sub-issue <child>`; otherwise start the child body with `Part of #<parent>` |
| Close | `gh issue close <n> --comment "..."` |

Write issues in English, like the rest of the repo. Quote French app copy verbatim and use the terms defined in `GLOSSARY.md`. Never paste credentials, tokens, cookies or real diary data into an issue: the repository is public.

**PRs as a request surface: no.** Only the owner opens pull requests.

"Publish to the issue tracker" means create a GitHub issue as above. "Fetch the ticket" means read it as above.
