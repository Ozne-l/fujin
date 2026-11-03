import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/domain/adding/ekklo_side.dart';
import 'package:fujin/domain/sending/entry_planning.dart';
import 'package:fujin/domain/sending/plan_entry.dart';
import 'package:fujin/domain/sending/planned_entry.dart';

PlannedEntry? derivedSend(LoggedEntry stored, Memory memory) =>
    switch (planEntry(entry: stored, memory: memory)) {
      Planned(:final planned)
          when planned.sends && EkkloSide.of(planned) == EkkloSide.remembered =>
        planned,
      Planned() || NeedsEkkloFood() || NeedsSearch() => null,
    };
