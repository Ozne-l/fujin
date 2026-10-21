import 'dart:async';

import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/router.dart';
import 'package:fujin/app/theme/fujin_system_bars.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/memory/barcode_link.dart';
import 'package:fujin/pages/adding/add_search_notifier.dart';
import 'package:fujin/pages/common/scan_button.dart';
import 'package:fujin/pages/scanner/widgets/code_keypad.dart';
import 'package:fujin/pages/tabs/floating_tab_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../support/fake_backends.dart';
import '../support/fake_scan_camera.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

const _dinner = 'Dinner';
const _snacks = 'Snacks';
const _code = '3275760750398';
const _storeCode = '2112345004501';
const _oatsName = 'Flocons d’avoine';
const _brand = 'Quaker';
const _query = '$_oatsName $_brand';
const _addToBoth = 'Ajouter à MFP et Ekklo';
const _scannerTitle = 'Scanner un code-barres';
const _journal = 'Journal';
final SystemUiOverlayStyle _lightBars = FujinSystemBars.of(
  FujinColors.light,
  Brightness.light,
);
const _memory = 'Mémoire';
const _settings = 'Réglages';
const _aim = 'Place le code-barres dans le cadre';
const _searchByText = 'Chercher par texte';
const _searchCode = 'Chercher ce code';
const _checkedOnPhone =
    'Vérifié sur le téléphone, rien n’a été envoyé. Corrige le dernier '
    'chiffre.';
const _unverifiedNote =
    'Saisi par un membre de MyFitnessPal. Vérifie que c’est bien ton paquet '
    'avant de continuer.';
const _unresolvedBanner =
    "MyFitnessPal connaît ce code-barres mais n'a pas de fiche pour cet "
    'aliment. Choisis-le dans la recherche.';

final MfpFood _oats = mfpFood(
  oats,
  description: _oatsName,
  brand: _brand,
  verified: false,
  nutrients: nutrients(kcal: 370, protein: 13, carbs: 60, fat: 7, fiber: 10),
);

final MfpFood _unlisted = mfpFood(
  'mfp-unlisted',
  description: _oatsName,
  brand: _brand,
);

final MfpFood _unlistedWithoutBrand = mfpFood(
  'mfp-unlisted',
  description: _oatsName,
);

FakeBackends _backends({Map<String, MfpFood> barcodes = const {}}) =>
    FakeBackends(
      mealNames: [breakfast, lunch, _dinner, _snacks],
      mfpFoods: [_oats],
      mfpBarcodes: barcodes,
      mfpSearches: {
        _query: [_oats],
        _oatsName: [_oats],
      },
    );

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(FujinApp)));

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> _tapText(WidgetTester tester, String text) =>
    _tap(tester, find.text(text));

Future<void> _openScanner(WidgetTester tester) =>
    _tap(tester, find.byType(ScanButton));

Future<void> _read(
  WidgetTester tester,
  FakeScanCamera camera,
  String code,
) async {
  camera.read(code);
  await tester.pumpAndSettle();
}

Future<void> _type(WidgetTester tester, String code) async {
  for (final digit in code.split('')) {
    await tester.tap(
      find.descendant(
        of: find.byType(CodeKeypad),
        matching: find.text(digit),
      ),
    );
    await tester.pump();
  }
}

void _sees(String text) => check(find.text(text).evaluate()).length.equals(1);

void _seesNo(String text) => check(find.text(text).evaluate()).isEmpty();

bool _enabled(WidgetTester tester, String label) => tester
    .widget<FilledButton>(
      find.ancestor(of: find.text(label), matching: find.byType(FilledButton)),
    )
    .enabled;

bool _scanEnabled(WidgetTester tester) =>
    tester.widget<ScanButton>(find.byType(ScanButton)).onTap != null;

Finder _tab(String label) => find.descendant(
  of: find.byType(FloatingTabBar),
  matching: find.text(label),
);

Color? _tabColor(WidgetTester tester, String label) =>
    tester.widget<Text>(_tab(label)).style?.color;

Future<void> _pullToRefresh(WidgetTester tester) async {
  await tester.fling(
    find.byType(CustomScrollView),
    const Offset(0, 1000),
    1000,
  );
  await tester.pumpAndSettle();
}

int _lookups(FakeBackends backends) => backends.requests
    .where((request) => request.url.host == mfpSyncUri.host)
    .length;

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    addTearDown(view.reset);
    view
      ..physicalSize = const Size(800, 1800)
      ..devicePixelRatio = 1;
  });

  group('the scanner', () {
    testWidgets(
      'opens from the tab bar on the Journal day and the meal of the hour',
      (tester) async {
        await pumpFujin(tester, _backends());

        await _openScanner(tester);

        _sees(_scannerTitle);
        _sees('$_dinner · mer. 7 oct.');
        _sees(_aim);
        _sees('Saisir le code');
      },
    );

    testWidgets('opens from the search with its day and meal', (tester) async {
      await pumpFujin(tester, _backends());
      unawaited(
        _container(
              tester,
            )
            .read(routerProvider)
            .push<void>(FujinRoute.addFood.forMeal(day, lunch)),
      );
      await tester.pumpAndSettle();

      await _openScanner(tester);

      _sees('$lunch · mer. 7 oct.');
    });

    testWidgets('shows the MyFitnessPal food of a read code (A03c)', (
      tester,
    ) async {
      final camera = FakeScanCamera();
      await pumpFujin(
        tester,
        _backends(barcodes: {_code: _oats}),
        camera: camera,
      );
      await _openScanner(tester);

      await _read(tester, camera, _code);

      _sees('Code lu : $_code');
      _sees('MyFitnessPal');
      _sees('· trouvé par code-barres');
      _sees(_oatsName);
      _sees('$_brand · 370 kcal / 100 g');
      _sees('Non vérifié');
      _sees('EAN $_code');
      _sees(_unverifiedNote);
      _seesNo('Code magasin');
    });

    testWidgets('lights the torch and puts it out', (tester) async {
      final camera = FakeScanCamera();
      await pumpFujin(tester, _backends(), camera: camera);
      await _openScanner(tester);

      await _tap(tester, find.byTooltip('Lampe'));
      check(camera.torch).isTrue();
      await _tap(tester, find.byTooltip('Lampe'));
      check(camera.torch).isFalse();
    });

    testWidgets('keeps the torch lit back from the food card', (tester) async {
      final camera = FakeScanCamera();
      await pumpFujin(
        tester,
        _backends(barcodes: {_code: _oats}),
        camera: camera,
      );
      await _openScanner(tester);
      await _tap(tester, find.byTooltip('Lampe'));
      await _read(tester, camera, _code);
      await _tapText(tester, "C'est bien ce produit");
      camera.torch = false;

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      _sees('Code lu : $_code');
      check(camera.torch).isTrue();
    });

    testWidgets(
      'lightens the status bar over the camera only, not once closed nor on '
      'the food card',
      (tester) async {
        final camera = FakeScanCamera();
        await pumpFujin(
          tester,
          _backends(barcodes: {_code: _oats}),
          camera: camera,
        );

        await _openScanner(tester);
        check(
          SystemChrome.latestStyle,
        ).equals(FujinSystemBars.camera(FujinColors.light));
        await _tap(tester, find.byTooltip('Fermer'));
        _seesNo(_scannerTitle);
        check(SystemChrome.latestStyle).equals(_lightBars);

        await _openScanner(tester);
        await _read(tester, camera, _code);
        await _tapText(tester, "C'est bien ce produit");
        _sees('Ajouter à $_dinner');
        check(SystemChrome.latestStyle).equals(_lightBars);
      },
    );

    testWidgets('looks a code up once, whatever the camera reads meanwhile', (
      tester,
    ) async {
      final camera = FakeScanCamera();
      final backends = _backends(barcodes: {_code: _oats});
      await pumpFujin(tester, backends, camera: camera);
      await _openScanner(tester);

      camera
        ..read(_code)
        ..read(_storeCode);
      await tester.pumpAndSettle();
      camera.read(_storeCode);
      await tester.pumpAndSettle();

      check(_lookups(backends)).equals(1);
      _sees(_oatsName);
    });

    testWidgets('adds the confirmed product without linking the code', (
      tester,
    ) async {
      final camera = FakeScanCamera();
      final backends = _backends(barcodes: {_code: _oats});
      await pumpFujin(tester, backends, camera: camera);
      await _openScanner(tester);
      await _read(tester, camera, _code);

      await _tapText(tester, "C'est bien ce produit");
      _sees('Ajouter à $_dinner');
      _sees('EAN $_code');
      await _tapText(tester, _addToBoth);

      check(backends.entries.single)
        ..has((entry) => entry.mealName, 'meal').equals(_dinner)
        ..has((entry) => entry.food.id, 'food').equals(oats);
      check(
        _container(tester).read(memoryRepositoryProvider).barcodeFood(_code),
      ).isNull();
      _seesNo(_scannerTitle);
    });

    testWidgets('warns that a store code may name another product (A03h)', (
      tester,
    ) async {
      final camera = FakeScanCamera();
      await pumpFujin(
        tester,
        _backends(barcodes: {_storeCode: _oats}),
        camera: camera,
      );
      await _openScanner(tester);

      await _read(tester, camera, _storeCode);

      _sees(_oatsName);
      _sees('Code magasin');
      _sees(
        'Les codes qui commencent par 02 ou 20 à 29 sont attribués par chaque '
        'enseigne : ce produit n’est peut-être pas le tien.',
      );
      _sees(_unverifiedNote);
      _seesNo('EAN $_storeCode');
    });

    testWidgets('offers the food linked to the code in the Memory', (
      tester,
    ) async {
      final camera = FakeScanCamera();
      final backends = _backends();
      await pumpFujin(
        tester,
        backends,
        camera: camera,
        barcodeLinks: const [BarcodeLink(barcode: _code, mfpFoodId: oats)],
      );
      await _openScanner(tester);

      await _read(tester, camera, _code);

      _sees('Mémoire · retenu pour ce code-barres');
      _sees(_oatsName);
      _seesNo('· trouvé par code-barres');
      check(_lookups(backends)).equals(0);
    });

    testWidgets(
      'names a code without a food card (A03d), searches its name and brand '
      'under the banner (A02d), links the food added, then offers it on the '
      'next scan',
      (tester) async {
        final camera = FakeScanCamera();
        await pumpFujin(
          tester,
          _backends(barcodes: {_code: _unlisted}),
          camera: camera,
        );
        await _openScanner(tester);

        await _read(tester, camera, _code);

        _sees('Code lu : $_code');
        _sees('Produit reconnu, sans fiche');
        _sees(
          'MyFitnessPal connaît ce code ($_oatsName, $_brand) mais n’a pas '
          'ses valeurs nutritionnelles.',
        );
        _sees('Rescanner');
        await _tapText(tester, 'Chercher « $_query »');

        _sees(_unresolvedBanner);
        _sees(_query);
        await _tapText(tester, _oatsName);
        _sees('Ajouter à $_dinner');
        await _tapText(tester, _addToBoth);

        check(
          _container(tester).read(memoryRepositoryProvider).barcodeFood(_code),
        ).equals(oats);

        await _openScanner(tester);
        await _read(tester, camera, _code);

        _sees('Mémoire · retenu pour ce code-barres');
        _sees(_oatsName);
      },
    );

    testWidgets(
      'brings a scan without food card nor brand back to the search it was '
      'opened from (A03d)',
      (tester) async {
        final camera = FakeScanCamera();
        await pumpFujin(
          tester,
          _backends(barcodes: {_code: _unlistedWithoutBrand}),
          camera: camera,
        );
        final added =
            _container(
                  tester,
                )
                .read(routerProvider)
                .push<Object>(FujinRoute.addFood.forMeal(day, lunch));
        await tester.pumpAndSettle();
        await _openScanner(tester);

        await _read(tester, camera, _code);
        _sees(
          'MyFitnessPal connaît ce code ($_oatsName) mais n’a pas ses valeurs '
          'nutritionnelles.',
        );
        await _tapText(tester, 'Chercher « $_oatsName »');
        _sees(_unresolvedBanner);
        await _tap(
          tester,
          find.descendant(
            of: find.byType(CustomScrollView),
            matching: find.text(_oatsName),
          ),
        );
        _sees('Ajouter à $lunch');
        await _tapText(tester, _addToBoth);

        check(await added).isNotNull();
        check(
          _container(tester).read(memoryRepositoryProvider).barcodeFood(_code),
        ).equals(oats);
      },
    );

    testWidgets('searches by text when the product is not the right one', (
      tester,
    ) async {
      final camera = FakeScanCamera();
      await pumpFujin(
        tester,
        _backends(barcodes: {_code: _oats}),
        camera: camera,
      );
      await _openScanner(tester);
      await _read(tester, camera, _code);

      await _tapText(tester, 'Pas le bon produit : chercher par texte');

      _sees(_query);
      _seesNo(_unresolvedBanner);
    });

    testWidgets(
      'says MyFitnessPal does not know the code (A03e) and keeps it for a '
      'food found by text',
      (tester) async {
        final camera = FakeScanCamera();
        await pumpFujin(tester, _backends(), camera: camera);
        await _openScanner(tester);

        await _read(tester, camera, _code);

        _sees('Code lu : $_code');
        _sees('Code-barres inconnu');
        _sees(
          'Le code $_code n’est pas dans la base MyFitnessPal. Cherche le '
          'produit par son nom, ou crée-le dans l’app MyFitnessPal.',
        );
        await _tapText(tester, 'Rescanner');
        _sees(_aim);

        await _read(tester, camera, _code);
        await _tapText(tester, _searchByText);
        _seesNo(_unresolvedBanner);
        await tester.enterText(find.byType(TextField).first, _query);
        await tester.pump(AddSearchNotifier.typingPause);
        await tester.pumpAndSettle();
        await _tapText(tester, _oatsName);
        await _tapText(tester, _addToBoth);

        check(
          _container(tester).read(memoryRepositoryProvider).barcodeFood(_code),
        ).equals(oats);
      },
    );

    testWidgets(
      'checks a typed code on the phone and searches it only once valid '
      '(A03f)',
      (tester) async {
        final backends = _backends(barcodes: {_code: _oats});
        await pumpFujin(tester, backends);
        await _openScanner(tester);

        await _tapText(tester, 'Saisir le code');
        _sees('Saisir le code-barres');
        await _type(tester, '32757');
        check(_enabled(tester, _searchCode)).isFalse();
        _seesNo(_checkedOnPhone);
        await _type(tester, '60750399');

        _sees('Chiffre de contrôle 9, 8 attendu');
        _sees(_checkedOnPhone);
        check(_enabled(tester, _searchCode)).isFalse();
        check(_lookups(backends)).equals(0);

        await _tap(tester, find.byIcon(Icons.backspace_outlined));
        await _type(tester, '8');
        _sees('EAN-13, chiffre de contrôle correct');
        _seesNo(_checkedOnPhone);
        check(_enabled(tester, _searchCode)).isTrue();
        await _tapText(tester, _searchCode);
        _sees(_oatsName);
      },
    );

    testWidgets('opens the keypad on a read code that fails the check (A03f)', (
      tester,
    ) async {
      final camera = FakeScanCamera();
      final backends = _backends();
      await pumpFujin(tester, backends, camera: camera);
      await _openScanner(tester);

      await _read(tester, camera, '3275760750399');

      _sees('Saisir le code-barres');
      _sees('3275760750399');
      _sees('Chiffre de contrôle 9, 8 attendu');
      check(_enabled(tester, _searchCode)).isFalse();
      check(_lookups(backends)).equals(0);
    });

    testWidgets(
      'says the barcode service does not answer and retries on demand (A03g)',
      (tester) async {
        final camera = FakeScanCamera();
        final backends = _backends(barcodes: {_code: _oats})
          ..mfpSyncStatus = 503;
        await pumpFujin(tester, backends, camera: camera);
        await _openScanner(tester);

        await _read(tester, camera, _code);

        _sees('Code lu : $_code');
        _sees('Codes-barres indisponibles');
        _sees(
          'Le service code-barres de MyFitnessPal ne répond pas. La recherche '
          'par texte, elle, fonctionne.',
        );
        _sees(_searchByText);
        check(_lookups(backends)).equals(1);
        backends.mfpSyncStatus = null;
        await _tapText(tester, 'Réessayer le scan');
        _sees(_oatsName);
      },
    );

    testWidgets(
      'asks to sign in to MyFitnessPal again when its session expired during '
      'a scan, then looks the code up',
      (tester) async {
        final camera = FakeScanCamera();
        final backends = _backends(barcodes: {_code: _oats});
        final store = InMemoryMfpSessionStore();
        await store.write(FakeBackends.mfpSession);
        await pumpFujin(
          tester,
          backends,
          camera: camera,
          mfp: backends.mfpWith(store),
        );
        await _openScanner(tester);
        await store.write(FakeBackends.refusedMfpSession);

        await _read(tester, camera, _code);

        _sees('Session MyFitnessPal expirée');
        _sees('Reconnecte-toi pour chercher le code $_code. Il est gardé.');
        _seesNo('Codes-barres indisponibles');
        _seesNo(_searchByText);

        await tester.tap(find.text('Se reconnecter à MyFitnessPal'));
        await tester.pump();
        tester.takeException();
        await store.write(FakeBackends.mfpSession);
        _container(tester).read(routerProvider).pop(true);
        await tester.pumpAndSettle();

        _sees(_oatsName);
      },
    );

    testWidgets('says the phone is offline (A03g)', (tester) async {
      final camera = FakeScanCamera();
      final backends = _backends(barcodes: {_code: _oats});
      await pumpFujin(tester, backends, camera: camera);
      await _openScanner(tester);
      backends.mfpReachable = false;

      await _read(tester, camera, _code);

      _sees('Pas de connexion');
      _sees("Le code $_code n'a pas pu être cherché.");
      _sees(_searchByText);
      _sees('Réessayer le scan');
    });

    testWidgets('explains a refused camera and offers to type (A03i)', (
      tester,
    ) async {
      final camera = FakeScanCamera();
      await pumpFujin(tester, _backends(), camera: camera);
      await _openScanner(tester);

      camera.refuse();
      await tester.pumpAndSettle();

      _sees("Pas d'accès à l'appareil photo");
      _sees(
        "Autorise l'appareil photo pour Fūjin dans les réglages du "
        'téléphone, ou saisis le code à la main.',
      );
      await _tapText(tester, 'Saisir le code');
      _sees('Saisir le code-barres');
    });
  });

  group('the tab bar scanner', () {
    testWidgets('opens on a normal day', (tester) async {
      await pumpFujin(tester, _backends());

      check(_scanEnabled(tester)).isTrue();
      await _openScanner(tester);
      _sees(_scannerTitle);
    });

    testWidgets('marks the Journal tab once a food scanned from Mémoire is '
        'added', (tester) async {
      final camera = FakeScanCamera();
      await pumpFujin(
        tester,
        _backends(barcodes: {_code: _oats}),
        camera: camera,
      );
      await _tap(tester, _tab(_memory));

      await _openScanner(tester);
      await _read(tester, camera, _code);
      await _tapText(tester, "C'est bien ce produit");
      await _tapText(tester, _addToBoth);

      check(_tabColor(tester, _journal)).equals(FujinColors.light.textLink);
      check(_tabColor(tester, _memory)).equals(FujinColors.light.textPrimary);
    });

    testWidgets('stays usable when MyFitnessPal answers with a server error', (
      tester,
    ) async {
      final backends = _backends()..mfpDiaryStatus = 503;
      await pumpFujin(tester, backends);

      check(_scanEnabled(tester)).isTrue();
      await _openScanner(tester);
      _sees(_scannerTitle);
    });

    testWidgets('is greyed and opens nothing when the Ekklo session expired', (
      tester,
    ) async {
      final backends = _backends();
      final store = InMemoryEkkloTokenStore();
      await store.write(FakeBackends.staleEkkloTokens);
      await pumpFujin(tester, backends, ekklo: backends.ekkloWith(store));

      check(_scanEnabled(tester)).isFalse();
      await _openScanner(tester);
      _seesNo(_scannerTitle);
    });

    testWidgets('is greyed offline on every tab, then usable once back', (
      tester,
    ) async {
      final backends = _backends();
      await pumpFujin(tester, backends);

      backends
        ..mfpReachable = false
        ..ekkloReachable = false;
      await _pullToRefresh(tester);

      for (final tab in [_memory, _settings, _journal]) {
        await _tap(tester, _tab(tab));
        check(_scanEnabled(tester)).isFalse();
        await _openScanner(tester);
        _seesNo(_scannerTitle);
      }

      backends
        ..mfpReachable = true
        ..ekkloReachable = true;
      await _pullToRefresh(tester);

      check(_scanEnabled(tester)).isTrue();
    });
  });
}
