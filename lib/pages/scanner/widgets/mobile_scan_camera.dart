import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScanCamera extends HookWidget {
  const MobileScanCamera({
    required this.torch,
    required this.onRead,
    required this.onRefused,
    super.key,
  });

  static const List<BarcodeFormat> _formats = [
    BarcodeFormat.ean13,
    BarcodeFormat.ean8,
    BarcodeFormat.upcA,
  ];

  final bool torch;
  final ValueChanged<String> onRead;
  final VoidCallback onRefused;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(
      () => MobileScannerController(formats: _formats),
    );
    final running = useListenableSelector(
      controller,
      () => controller.value.isRunning,
    );
    useEffect(
      () =>
          () => unawaited(controller.dispose()),
      [controller],
    );
    useEffect(() {
      void report() {
        if (controller.value.error?.errorCode
            case MobileScannerErrorCode.permissionDenied) {
          onRefused();
        }
      }

      controller.addListener(report);
      return () => controller.removeListener(report);
    }, [controller, onRefused]);
    useEffect(() {
      switch ((controller.value.torchState, torch)) {
        case (TorchState.off, true) || (TorchState.on, false):
          unawaited(controller.toggleTorch());
        case (TorchState.off || TorchState.auto || TorchState.unavailable, _) ||
            (TorchState.on, true):
          break;
      }
      return null;
    }, [controller, torch, running]);
    return MobileScanner(
      controller: controller,
      onDetect: (capture) {
        if (capture.barcodes
                .map((barcode) => barcode.rawValue)
                .nonNulls
                .firstOrNull
            case final code?) {
          onRead(code);
        }
      },
      errorBuilder: (context, error) =>
          const ColoredBox(color: FujinColorRole.backgroundDark),
      placeholderBuilder: (context) =>
          const ColoredBox(color: FujinColorRole.backgroundDark),
    );
  }
}
