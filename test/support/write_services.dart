import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/recents/recent_food_repository.dart';
import 'package:fujin/data/unattended/unattended_item_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_food_service.dart';
import 'package:fujin/domain/adding/add_outcome.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/compared_entry_lookup.dart';
import 'package:fujin/domain/editing/edit_entry_service.dart';
import 'package:fujin/domain/editing/remove_entry_service.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:http/http.dart' as http;
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import 'fake_backends.dart';
import 'fixtures.dart';

final class WriteServices {
  WriteServices._(
    this.backends,
    this.links,
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
    final links = SentLinkRepository(database);
    final memoryRepository = MemoryRepository(database);
    final unattended = UnattendedItemRepository(database);
    final journal = JournalService(
      mfp: mfp,
      ekklo: ekklo,
      links: links,
      unattended: unattended,
      memory: memoryRepository,
      database: database,
      clock: () => now,
    );
    final sending = SendService(
      journal: journal,
      ekklo: ekklo,
      memory: memoryRepository,
      links: links,
      unattended: unattended,
      database: database,
      clock: () => now,
    );
    return WriteServices._(
      backends,
      links,
      journal,
      AddFoodService(
        mfp: mfp,
        ekklo: ekklo,
        sending: sending,
        memory: memoryRepository,
        recents: RecentFoodRepository(database),
        clock: clock ?? () => now,
      ),
      RemoveEntryService(mfp: mfp, journal: journal, sending: sending),
      EditEntryService(
        mfp: mfp,
        ekklo: ekklo,
        journal: journal,
        sending: sending,
        memory: memoryRepository,
      ),
    );
  }

  final FakeBackends backends;
  final SentLinkRepository links;
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
