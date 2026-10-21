import 'package:flutter/widgets.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_glass_button.dart';
import 'package:fujin/pages/common/fujin_glass_button_size.dart';
import 'package:fujin/pages/common/scan_icon.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({required this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => FujinGlassButton(
    icon: ScanIcon.asset,
    label: context.intl.tabScanner,
    onPressed: onTap,
    size: FujinGlassButtonSize.large,
  );
}
