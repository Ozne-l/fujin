# 29. Journal reads held in memory for display, writes read live

Date: 2026-10-13

## Status

Accepted.

## Context

The week band felt slow. Each week crossed by a fling selected a new day, which started a full read of that day (MyFitnessPal diary and Ekklo meals) and put the whole Journal back to skeletons while the finger was still moving. The rings read the seven MyFitnessPal diaries of the shown week and kept only their kilocalories, so a tap on a day of that week read its diary a second time. Nothing was kept: coming back to a day seen seconds earlier read it again behind skeletons.

`~/Dev/bridge_poc/bin/journal_latency_probe.dart` (outside this repository), run by the owner from his Mac on 2026-10-13, measured (medians):

| Read | Time |
| --- | --- |
| One MyFitnessPal diary | 539 to 569 ms |
| One Ekklo day | 58 to 115 ms |
| One day, both in parallel (what a tap waited for) | 578 to 706 ms |
| A week of MyFitnessPal diaries (the rings) | 501 to 1151 ms |
| A week of Ekklo days | 102 to 220 ms |
| Last day after a three-week fling, read per week crossed | 515 to 634 ms |
| Last day after the same fling, read only where it stops | 448 to 741 ms |

MyFitnessPal dominates. Loading only where the fling stops does not make data arrive sooner; it removes the skeletons and two thirds of the requests during the gesture.

## Decision

- Each day's two reads are their own providers in `lib/pages/journal/journal_notifier.dart`: `mfpDiaryProvider(day)` and `ekkloMealsProvider(day)`, each a `Fetched` value (the read and its time, `lib/domain/journal/fetch.dart`). They are kept in memory for 5 minutes after the last screen stops showing them, then dropped; a screen merely hidden (another tab, a pushed page) counts as showing them again when it comes back, so the 5 minutes restart from there (`_holdAfterLastListener`). Nothing is stored in `fujin.db`.
- `weekReadProvider(monday)` reads both sides of every day of a week, up to today. The band watches it for the week it settles on and, once that week's diaries are in, for the week before and the week after (when that one is not wholly in the future). A finger drag reveals about one neighbour week, so the rings it uncovers are already drawn and a stop on it shows the selected day at once.
- Each day of the band draws its ring from its held `mfpDiaryProvider` when one exists (`WidgetRef.exists`) and never starts a read itself, so pages crossed by a fling stay bare and are not read. Tapping a day of a held week no longer reads its diary first.
- `JournalNotifier` composes the day from whatever the two providers hold (`JournalService.journalOf`): a held day shows at once, without skeletons. While either side is being read again, the notifier keeps the day it already shows instead of composing one side's new read with the other side's old one; it composes once both have landed. Each time a day becomes the selected day, the Journal reads it again in the background (`JournalNotifier.revalidate`); a read that changes nothing changes nothing on screen. Pull to refresh, the foreground return ([0003](0003-refresh-on-foreground-and-pull.md)), the offline retry and the returns from sending, adding, undoing and signing in read again (`JournalNotifier.reload`): both sides of the selected day, the MyFitnessPal diaries of the rest of its week (so the rings recover from a failed or outdated read, as the week read did before), and that week's Ekklo reads that failed.
- Composing writes nothing. `journalOf` compares against the stored links without changing them, because a held read can predate a send or an add that wrote links since. Link adoptions and drops and the unattended items are stored (`JournalService.settleLinks`) only from a pair of reads the notifier itself just made or waited for: the first read of a day, a reload, and a revalidation once both sides land, so a link written by a send keeps its `sent_at` ([0002](0002-write-ordering.md)). `JournalService.readDay`, the live read behind every write, stores them as before.
- A sign-in drops every held day (the whole `mfpDiaryProvider` and `ekkloMealsProvider` families are invalidated, so a held `sessionExpired` cannot outlive it) and reads again at once every day still shown: the selected day, the shown week and its two neighbours, up to 42 requests. An add from the Scanner, and an undo whose food is on another day than the selected one, invalidate the two reads of that food's day.
- The week band selects a day only when the scroll rests on a whole page (`ScrollEndNotification` with a whole page), not when a page is half crossed nor when a finger catches a fling between two pages, so a fling across several weeks reads only the week where it stops.
- Everything that writes reads both sides live, never from these providers: `JournalService.readDay` for sending, the undo and the add flow's own reads. Statuses stay recomputed from both services before any write, as [0001](0001-recompute-statuses-from-both-sides.md) requires.

## Consequences

- A tap on a day of the shown week shows it at once, then corrects it if the background read differs. For up to one read (about 0.6 s on the probe's network) the screen can show the state before an edit made in the MyFitnessPal app; a send started in that window still plans from a live read.
- A fling no longer reads every week it crosses.
- Each settled week costs up to fourteen reads per newly held week, its own and its two neighbours' (about 0.5 to 1.2 s for the MyFitnessPal half and 0.1 to 0.2 s for the Ekklo half, in parallel, on the probe's network); a neighbour already held costs nothing. Each selection adds one more read of each side. Each reload (pull, foreground return, the 15 s offline retry, the returns from writes) costs the selected day's two reads plus up to six MyFitnessPal diaries of its week, as the week read did before, and an Ekklo read for each day of that week whose last one failed. The neighbours start only once the settled week's diaries are in, so they never slow its first read.
- A day 2 weeks from the settled one, seen only at the far end of a drag, shows a bare ring until the band settles.
- A read that failed is held like a success for 5 minutes; selecting the day shows the problem at once and reads again.
- The latencies were measured from a Mac, not the phone; the ratio between the two services is what the decision rests on.
