import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/scanner/code_bounds.dart';
import 'package:fujin/pages/scanner/scanned_code.dart';
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
  final ValueChanged<ScannedCode> onRead;
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
    return LayoutBuilder(
      builder: (context, constraints) => MobileScanner(
        controller: controller,
        onDetect: (capture) {
          if (capture.barcodes
                  .where((barcode) => barcode.rawValue != null)
                  .firstOrNull
              case Barcode(rawValue: final code?, :final corners)) {
            onRead((
              code: code,
              bounds: CodeBounds.of(
                corners: corners,
                image: capture.size,
                view: constraints.biggest,
              ),
            ));
          }
        },
        errorBuilder: (context, error) =>
            ColoredBox(color: context.colors.cameraBackground),
        placeholderBuilder: (context) =>
            ColoredBox(color: context.colors.cameraBackground),
      ),
    );
  }
}
