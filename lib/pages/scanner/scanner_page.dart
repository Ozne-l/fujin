import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_system_bars.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/adding/widgets/food_view.dart';
import 'package:fujin/pages/common/in_page_sheet.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/scan_icon.dart';
import 'package:fujin/pages/scanner/scan_camera.dart';
import 'package:fujin/pages/scanner/scanner_exit.dart';
import 'package:fujin/pages/scanner/scanner_notifier.dart';
import 'package:fujin/pages/scanner/scanner_state.dart';
import 'package:fujin/pages/scanner/widgets/aim_frame.dart';
import 'package:fujin/pages/scanner/widgets/camera_icon_button.dart';
import 'package:fujin/pages/scanner/widgets/code_entry_sheet.dart';
import 'package:fujin/pages/scanner/widgets/scanned_food_sheet.dart';
import 'package:fujin/pages/scanner/widgets/scanner_message_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScannerPage extends HookConsumerWidget {
  const ScannerPage({required this.date, required this.mfpMealName, super.key});

  final DateTime date;
  final String mfpMealName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scannerProvider);
    final notifier = ref.read(scannerProvider.notifier);
    final camera = ref.watch(scanCameraProvider);
    final torch = useState(false);
    final opened = useState<({AddDraft draft, String barcode})?>(null);

    ref.listen(scannerProvider, (previous, next) {
      if ((previous, next) case (
        ScannerAiming(),
        ScannerLooking() || ScannerTyping(code: String(isNotEmpty: true)),
      )) {
        unawaited(HapticFeedback.mediumImpact());
      }
    });

    void searchByText() {
      if (notifier.searchByText() case final search?) context.pop(search);
    }

    Future<void> signIn() async {
      final signedIn = await context.push<bool>(FujinRoute.mfpSignIn.path);
      if (signedIn case true) await notifier.retry();
    }

    if (opened.value case (:final draft, :final barcode)) {
      return Scaffold(
        body: SafeArea(
          bottom: false,
          child: FoodView(
            key: ValueKey(draft),
            initial: draft,
            barcode: barcode,
            onBack: () => opened.value = null,
            onLeave: (added) => context.pop(ScannerAdded(added)),
          ),
        ),
      );
    }

    final code = switch (state) {
      ScannerLooking(:final code) ||
      ScannerFound(:final code) ||
      ScannerUnknown(:final code) ||
      ScannerUnresolved(:final code) ||
      ScannerFailed(:final code) => code,
      ScannerAiming() || ScannerRefused() || ScannerTyping() => null,
    };

    final sheet = switch (state) {
      ScannerAiming() || ScannerLooking() => null,
      ScannerRefused() => ScannerMessageSheet(
        icon: const Icon(Icons.no_photography_outlined),
        title: context.intl.scannerCameraRefusedTitle,
        detail: context.intl.scannerCameraRefusedDetail,
        primary: (context.intl.scannerTypeCode, notifier.type),
      ),
      ScannerTyping(:final code) => CodeEntrySheet(
        code: code,
        onDigit: notifier.press,
        onErase: notifier.erase,
        onSubmit: () => unawaited(notifier.submit()),
      ),
      ScannerFound(:final code, :final food, :final remembered) =>
        ScannedFoodSheet(
          code: code,
          food: food,
          remembered: remembered,
          onConfirm: () {
            if (AddDraft.of(food, mfpMealName: mfpMealName, date: date)
                case final draft?) {
              opened.value = (draft: draft, barcode: code);
            }
          },
          onSearch: searchByText,
        ),
      ScannerUnresolved(:final description, :final brandName) =>
        ScannerMessageSheet(
          icon: SvgPicture.asset(
            ScanIcon.asset,
            width: FujinSize.pictogramIcon,
            height: FujinSize.pictogramIcon,
            theme: SvgTheme(currentColor: PillTone.info.foreground),
            excludeFromSemantics: true,
          ),
          tone: PillTone.info,
          title: context.intl.addBarcodeUnresolvedTitle,
          detail: context.intl.addBarcodeUnresolvedDetail(switch (brandName
              ?.trim()) {
            null || '' => description,
            final brand => context.intl.scannerNameAndBrand(description, brand),
          }),
          primary: (
            context.intl.addSearchQuoted(
              ScannerSearch.queryOf(description, brandName),
            ),
            searchByText,
          ),
          secondary: (context.intl.scannerRescan, notifier.aim),
        ),
      ScannerUnknown(:final code) => ScannerMessageSheet(
        icon: const Icon(Icons.help_outline),
        title: context.intl.addBarcodeUnknownTitle,
        detail: context.intl.addBarcodeUnknownDetail(code),
        primary: (context.intl.scannerSearchText, searchByText),
        secondary: (context.intl.scannerRescan, notifier.aim),
      ),
      ScannerFailed(:final code, :final problem) => _failedSheet(
        context.intl,
        problem,
        code: code,
        onRetry: () => unawaited(notifier.retry()),
        onSearch: searchByText,
        onSignIn: () => unawaited(signIn()),
      ),
    };

    return PopScope(
      canPop: switch (state) {
        ScannerAiming() || ScannerLooking() || ScannerRefused() => true,
        ScannerTyping() ||
        ScannerFound() ||
        ScannerUnknown() ||
        ScannerUnresolved() ||
        ScannerFailed() => false,
      },
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) notifier.aim();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: FujinSystemBars.onDark,
        child: Scaffold(
          backgroundColor: FujinColorRole.backgroundDark,
          body: Stack(
            fit: StackFit.expand,
            children: [
              camera(
                torch: torch.value,
                onRead: (code) => unawaited(notifier.read(code)),
                onRefused: notifier.refused,
              ),
              AimFrame(
                hint: switch (code) {
                  final code? => context.intl.scannerCodeRead(code),
                  null => context.intl.scannerAim,
                },
                read: code != null,
                busy: state is ScannerLooking,
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: FujinSize.screenMargin,
                        vertical: FujinSpace.s1,
                      ),
                      child: Row(
                        spacing: FujinSpace.s2,
                        children: [
                          CameraIconButton(
                            icon: Icons.close,
                            tooltip: context.intl.close,
                            onPressed: () => context.pop(),
                          ),
                          Expanded(
                            child: Column(
                              spacing: FujinSpace.s1,
                              children: [
                                Text(
                                  context.intl.scannerTitle,
                                  textAlign: TextAlign.center,
                                  style: FujinText.inter16Medium.copyWith(
                                    color: FujinColor.washi,
                                  ),
                                ),
                                Text(
                                  context.intl.scannerContext(
                                    mfpMealName,
                                    date,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: FujinText.inter13Regular.copyWith(
                                    color: FujinColorRole.textDisabled,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CameraIconButton(
                            icon: switch (torch.value) {
                              true => Icons.flashlight_off_outlined,
                              false => Icons.flashlight_on_outlined,
                            },
                            tooltip: context.intl.scannerTorch,
                            onPressed: () => torch.value = !torch.value,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (state case ScannerAiming())
                      TextButton.icon(
                        onPressed: notifier.type,
                        icon: const Icon(
                          Icons.keyboard_outlined,
                          size: FujinSize.searchIcon,
                        ),
                        label: Text(context.intl.scannerTypeCode),
                        style: TextButton.styleFrom(
                          backgroundColor: FujinColorRole.backgroundGlass,
                          foregroundColor: FujinColor.washi,
                        ),
                      ),
                    const SizedBox(height: FujinSize.cameraActionGap),
                  ],
                ),
              ),
              if (sheet case final sheet?)
                InPageSheet(onDismiss: notifier.aim, child: sheet),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _failedSheet(
    AppLocalizations intl,
    ReadProblem problem, {
    required String code,
    required VoidCallback onRetry,
    required VoidCallback onSearch,
    required VoidCallback onSignIn,
  }) => switch (problem) {
    ReadProblem.mfpSessionExpired => ScannerMessageSheet(
      icon: const Icon(Icons.lock_outline),
      tone: PillTone.error,
      title: intl.addMfpSessionTitle,
      detail: intl.scannerMfpSessionDetail(code),
      primary: (intl.mfpReconnect, onSignIn),
    ),
    ReadProblem.offline => ScannerMessageSheet(
      icon: const Icon(Icons.wifi_off),
      tone: PillTone.error,
      title: intl.scannerOfflineTitle,
      detail: intl.scannerFailedDetail(code),
      primary: (intl.scannerSearchText, onSearch),
      secondary: (intl.scannerRetryScan, onRetry),
    ),
    ReadProblem.ekkloSessionExpired ||
    ReadProblem.mfpUnavailable ||
    ReadProblem.ekkloUnavailable ||
    ReadProblem.unknown => ScannerMessageSheet(
      icon: const Icon(Icons.dns_outlined),
      tone: PillTone.error,
      title: intl.scannerUnavailableTitle,
      detail: intl.scannerUnavailableDetail,
      primary: (intl.scannerSearchText, onSearch),
      secondary: (intl.scannerRetryScan, onRetry),
    ),
  };
}
