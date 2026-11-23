import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown;
import 'package:fujin/data/connectors/connector_roles.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_food_service.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/adding/entry_writer.dart';
import 'package:fujin/domain/adding/food_completion_service.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/compared_entry_lookup.dart';
import 'package:fujin/domain/editing/edit_entry_service.dart';
import 'package:fujin/domain/journal/fresh_read_service.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:fujin/domain/writing/background_writer.dart';
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
    this.sending,
    this.adding,
    this.editing,
    this.background,
    this.freshReads,
  );

  static Future<WriteServices> over(
    FakeBackends backends,
    FujinDatabase<FujinTable> database, {
    http.Client? httpClient,
    EkkloTokenStore? ekkloTokens,
    DateTime Function()? clock,
    ConnectorRoles Function()? roles,
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
    final journal = journalOver(
      database,
      mfp: mfp,
      ekklo: ekklo,
      roles: roles,
    );
    final sending = sendingOver(database, journal: journal, ekklo: ekklo);
    final writeClock = clock ?? () => now;
    final writer = EntryWriter(
      database: database,
      foods: foods,
      meals: mealsOf(database),
      entries: entries,
      clock: writeClock,
    );
    final background = BackgroundWriter(
      mfp: mfp,
      sending: sending,
      memory: memoryRepository,
      entries: entries,
      writer: writer,
      readOnly: httpClient is ReadOnlyHttpClient,
    );
    addTearDown(background.run);
    return WriteServices._(
      backends,
      entries,
      journal,
      sending,
      AddFoodService(
        mfp: mfp,
        sending: sending,
        memory: memoryRepository,
        foods: foods,
        recents: recentsOf(database),
        writer: writer,
        background: background,
        clock: writeClock,
      ),
      EditEntryService(
        mfp: mfp,
        sending: sending,
        foods: foods,
        entries: entries,
        writer: writer,
        background: background,
      ),
      background,
      FreshReadService(
        journal: journal,
        completion: FoodCompletionService(mfp: mfp, foods: foods),
        writer: background,
      ),
    );
  }

  final FakeBackends backends;
  final EntryRepository entries;
  final JournalService journal;
  final SendService sending;
  final AddFoodService adding;
  final EditEntryService editing;
  final BackgroundWriter background;
  final FreshReadService freshReads;

  Future<AddedFood> add(AddDraft draft) async =>
      adding.add(draft, await adding.plan(draft));

  Future<void> settle() => background.run();

  Future<ComparedEntry?> find(String entryId, DateTime date) async =>
      (await journal.readDay(date)).comparison.entryWithId(entryId);

  List<String> writes() => [
    for (final request in backends.requests)
      if (request.method != 'GET') '${request.method} ${request.url.host}',
  ];
}
