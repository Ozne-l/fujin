# 2. Write ordering

Date: 2026-10-07

## Status

Accepted. Sending is implemented as described in [0018](0018-send-flow.md); adding a food and undo are planned.

## Context

Every Fūjin write touches two services that share no transaction. A crash, a lost connection or an expired session can stop a write halfway. The recovery Fūjin has is the one in [0001](0001-recompute-statuses-from-both-sides.md): the next read recomputes statuses from both sides and adopts Ekklo items that Memory expects. The order of the two halves decides which half-written state that recovery sees.

Client capabilities (from `~/Dev/myfitnesspal_client` and `~/Dev/ekklo_client`): MyFitnessPal `diary.addFood` returns the new entry id and `diary.remove` deletes one; Ekklo `meals.appendItems` returns the whole meal, without saying which items are new, and `foods.createOwn` creates an own copy ("aliment perso").

## Decision

- Adding a food from Fūjin: check that both sessions are valid first, then write MyFitnessPal, then Ekklo. A stop after the first half leaves a MyFitnessPal entry that the Journal shows as "À envoyer", which is the normal state Fūjin already handles.
- Undo: Ekklo first, then MyFitnessPal. A stop after the first half leaves an entry "À envoyer", never an Ekklo item without its MyFitnessPal source.
- Sending: call `appendItems`, compare the meal's item ids before and after to find the items Fūjin created, then write the send links. A stop before the links are written is repaired by adoption on the next read.
- Own copies: before reusing an own copy, re-read the MyFitnessPal food with `foods.byId` and compare its `version` with the one stored in Memory (`OwnCopy.mfpFoodVersion`, `lib/data/memory/remembered_food.dart`). A different version means the copy is stale (screen 06e).
- The anti-bot block from MyFitnessPal (K14) is out of v1. K15 is the generic MyFitnessPal error banner.

Each write use case gets one service in `lib/domain/` and one notifier ([0006](0006-riverpod-notifiers-as-presenters.md)). Sending is `SendService` (`lib/domain/sending/send_service.dart`) with `SendNotifier` (`lib/pages/sending/send_notifier.dart`); adding a food and undo are planned.

## Consequences

- Every interrupted write leaves a state the Journal already shows correctly, so no recovery journal is needed.
- Sending costs one extra read of the meal (the before ids) per Ekklo meal written.
- Two Fūjin sends racing on the same meal could confuse the id diff. The app has one user and one send flow at a time, so this is accepted.
