import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_food_service.dart';
import 'package:fujin/domain/adding/add_outcome.dart';
import 'package:fujin/domain/adding/entry_writer.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/compared_entry_lookup.dart';
import 'package:fujin/domain/editing/edit_entry_service.dart';
import 'package:fujin/domain/editing/remove_entry_service.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:http/http.dart' as http;
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import 'fake_backends.dart';
import 'fixtures.dart';
import 'repositories.dart';

final class WriteServices {
  WriteServices._(
    this.backends,
    this.entries,
    this.journal,
    this.adding,
    this.removing,
    this.editing,
  );

  static Future<WriteServices> over(
    FakeBackends backends,
    FujinDatabase database, {
    http.Client? httpClient,
    EkkloTokenStore? ekkloTokens,
    DateTime Function()? clock,
  }) async {
    final mfp = backends.mfpWith(
      InMemoryMfpSessionStore(),
      client: httpClient,
    );
    await mfp.signIn(FakeBackends.mfpSession);
    final ekklo = backends.ekkloWith(
      ekkloTokens ?? await backends.ekkloTokenStore(),
      client: httpClient,
    );
    final entries = entriesOf(database);
    final foods = foodsOf(database);
    final memoryRepository = memoryOf(database);
    final journal = journalOver(database, mfp: mfp, ekklo: ekklo);
    final sending = sendingOver(database, journal: journal, ekklo: ekklo);
    final writeClock = clock ?? () => now;
    final writer = EntryWriter(
      database: database,
      foods: foods,
      meals: mealsOf(database),
      entries: entries,
      clock: writeClock,
    );
    return WriteServices._(
      backends,
      entries,
      journal,
      AddFoodService(
        mfp: mfp,
        ekklo: ekklo,
        sending: sending,
        memory: memoryRepository,
        foods: foods,
        recents: recentsOf(database),
        writer: writer,
        clock: writeClock,
      ),
      RemoveEntryService(
        mfp: mfp,
        journal: journal,
        sending: sending,
        entries: entries,
      ),
      EditEntryService(
        mfp: mfp,
        ekklo: ekklo,
        journal: journal,
        sending: sending,
        memory: memoryRepository,
        foods: foods,
        entries: entries,
        writer: writer,
      ),
    );
  }

  final FakeBackends backends;
  final EntryRepository entries;
  final JournalService journal;
  final AddFoodService adding;
  final RemoveEntryService removing;
  final EditEntryService editing;

  Future<AddOutcome> add(AddDraft draft) async =>
      adding.add(draft, await adding.plan(draft));

  Future<ComparedEntry?> find(String entryId, DateTime date) async =>
      (await journal.readDay(date)).comparison.entryWithId(entryId);

  List<String> writes() => [
    for (final request in backends.requests)
      if (request.method != 'GET') '${request.method} ${request.url.host}',
  ];
}
