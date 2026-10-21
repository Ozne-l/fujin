import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/adding/add_text.dart';
import 'package:fujin/pages/common/sheet_card.dart';
import 'package:fujin/pages/scanner/widgets/code_keypad.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class CodeEntrySheet extends StatelessWidget {
  const CodeEntrySheet({
    required this.code,
    required this.onDigit,
    required this.onErase,
    required this.onSubmit,
    super.key,
  });

  final String code;
  final ValueChanged<int> onDigit;
  final VoidCallback onErase;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final check = checkBarcode(code);
    final value = FujinText.inter18Medium.copyWith(
      color: context.colors.textPrimary,
    );
    final (border, borderWidth) = switch (check) {
      MfpBarcodeWrongCheckDigit() => (
        context.colors.textAlert,
        FujinStroke.fieldError,
      ),
      MfpValidBarcode() || MfpBarcodeNotDigits() || MfpBarcodeWrongLength() => (
        context.colors.textLink,
        FujinStroke.fieldFocus,
      ),
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SheetCard(
          handle: true,
          spacing: FujinSpace.s3,
          bottomSafe: false,
          children: [
            Text(
              context.intl.scannerTypeTitle,
              style: FujinText.hina24.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(FujinSpace.s4),
              decoration: BoxDecoration(
                color: context.colors.backgroundCard,
                borderRadius: BorderRadius.circular(FujinRadius.field),
                border: Border.all(color: border, width: borderWidth),
              ),
              child: Row(
                children: [
                  Text(code, style: value),
                  Container(
                    width: FujinStroke.fieldFocus,
                    height: value.fontSize,
                    color: context.colors.textLink,
                  ),
                ],
              ),
            ),
            ...switch (check) {
              MfpValidBarcode(:final format) => [
                _helper(
                  Icons.check_circle,
                  context.intl.scannerCodeValid(AddText.barcodeFormat(format)),
                  context.colors.textLink,
                ),
              ],
              MfpBarcodeWrongCheckDigit(:final actual, :final expected) => [
                _helper(
                  Icons.warning_amber_rounded,
                  context.intl.scannerCheckDigit(actual, expected),
                  context.colors.textAlert,
                ),
                Text(
                  context.intl.scannerCheckedOnPhone,
                  style: FujinText.inter12Regular.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
              MfpBarcodeNotDigits() || MfpBarcodeWrongLength() => const [],
            },
            FilledButton(
              onPressed: switch (check) {
                MfpValidBarcode() => onSubmit,
                MfpBarcodeNotDigits() ||
                MfpBarcodeWrongLength() ||
                MfpBarcodeWrongCheckDigit() => null,
              },
              child: Text(context.intl.scannerSearchCode),
            ),
          ],
        ),
        CodeKeypad(onDigit: onDigit, onErase: onErase),
      ],
    );
  }

  static Widget _helper(IconData icon, String text, Color color) => Row(
    spacing: FujinSpace.s2,
    children: [
      Icon(icon, size: FujinSize.tileIcon, color: color),
      Flexible(
        child: Text(
          text,
          style: FujinText.inter13Medium.copyWith(color: color),
        ),
      ),
    ],
  );
}
