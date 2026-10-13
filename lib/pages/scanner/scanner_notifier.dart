import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/adding/scan_outcome.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/pages/scanner/scanner_exit.dart';
import 'package:fujin/pages/scanner/scanner_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final NotifierProvider<ScannerNotifier, ScannerState> scannerProvider =
    NotifierProvider.autoDispose<ScannerNotifier, ScannerState>(
      ScannerNotifier.new,
    );

final class ScannerNotifier extends Notifier<ScannerState> {
  static final int _maxDigits = MfpBarcodeFormat.gtin14.length;

  var _cameraRefused = false;

  @override
  ScannerState build() => const ScannerAiming();

  Future<void> read(String code) async {
    if (state case ScannerAiming()) {
      switch (checkBarcode(code)) {
        case MfpValidBarcode():
          await _lookUp(code);
        case MfpBarcodeNotDigits() ||
            MfpBarcodeWrongLength() ||
            MfpBarcodeWrongCheckDigit():
          state = ScannerTyping(code);
      }
    }
  }

  void refused() {
    _cameraRefused = true;
    if (state case ScannerAiming()) state = const ScannerRefused();
  }

  void aim() => state = switch (_cameraRefused) {
    true => const ScannerRefused(),
    false => const ScannerAiming(),
  };

  void type() => state = const ScannerTyping('');

  void press(int digit) {
    if (state case ScannerTyping(:final code) when code.length < _maxDigits) {
      state = ScannerTyping('$code$digit');
    }
  }

  void erase() {
    if (state case ScannerTyping(:final code) when code.isNotEmpty) {
      state = ScannerTyping(code.substring(0, code.length - 1));
    }
  }

  Future<void> submit() async {
    if (state case ScannerTyping(
      :final code,
    ) when checkBarcode(code) is MfpValidBarcode) {
      await _lookUp(code);
    }
  }

  Future<void> retry() async {
    if (state case ScannerFailed(:final code)) await _lookUp(code);
  }

  ScannerSearch? searchByText() => switch (state) {
    ScannerFound(:final code, :final food) => ScannerSearch(
      query: ScannerSearch.queryOf(food.description, food.brandName),
      barcode: code,
    ),
    ScannerUnresolved(:final code, :final description, :final brandName) =>
      ScannerSearch(
        query: ScannerSearch.queryOf(description, brandName),
        barcode: code,
        unresolved: true,
      ),
    ScannerUnknown(:final code) || ScannerFailed(:final code) => ScannerSearch(
      query: '',
      barcode: code,
    ),
    ScannerAiming() ||
    ScannerRefused() ||
    ScannerTyping() ||
    ScannerLooking() => null,
  };

  Future<void> _lookUp(String code) async {
    final looking = ScannerLooking(code);
    state = looking;
    try {
      final outcome = await ref.read(addFoodServiceProvider).scan(code);
      if (!ref.mounted || state != looking) return;
      state = switch (outcome) {
        ScanFound(:final food, :final remembered) => ScannerFound(
          code,
          food,
          remembered: remembered,
        ),
        ScanUnresolved(:final description, :final brandName) =>
          ScannerUnresolved(
            code,
            description: description,
            brandName: brandName,
          ),
        ScanUnknown() => ScannerUnknown(code),
      };
    } on Object catch (error) {
      if (ref.mounted && state == looking) {
        state = ScannerFailed(code, ReadProblem.of(error));
      }
    }
  }
}
