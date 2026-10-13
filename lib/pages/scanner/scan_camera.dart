import 'package:flutter/widgets.dart';
import 'package:fujin/pages/scanner/widgets/mobile_scan_camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef ScanCamera =
    Widget Function({
      required bool torch,
      required ValueChanged<String> onRead,
      required VoidCallback onRefused,
    });

final scanCameraProvider = Provider<ScanCamera>(
  (ref) => MobileScanCamera.new,
);
