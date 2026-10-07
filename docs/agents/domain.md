# Domain docs

Fūjin is a single-context repository: one glossary and one set of decision records at the root.

```
GLOSSARY.md     domain terms (Journal, Memory, Send link, statuses...) and screen codes
docs/adr/       decision records, indexed in docs/adr/README.md
```

## Before exploring

Read `GLOSSARY.md`, then the records in `docs/adr/` that cover the area you will touch. `docs/adr/README.md` lists them with one line each.

## Vocabulary

Name things with the glossary's words: in issue titles, test names, refactor proposals and hypotheses. "Send link", not "sync record"; "Own copy", not "custom food". If a concept has no entry, either the word is invented (pick an existing one) or the glossary has a gap (add the entry in the same change).

## Decisions

When a proposal goes against a record, say so explicitly, name the record (for example "contradicts ADR 0004") and give the reason to reopen it. Record a new decision as the next numbered file in `docs/adr/`, in the same Context, Decision, Consequences format, and add it to the index.
