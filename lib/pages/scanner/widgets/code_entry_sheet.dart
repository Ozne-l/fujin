import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/adding/add_text.dart';
import 'package:fujin/pages/common/code_keypad.dart';
import 'package:fujin/pages/common/field_helper.dart';
import 'package:fujin/pages/common/keypad_field.dart';
import 'package:fujin/pages/common/sheet_card.dart';
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
    final error = switch (check) {
      MfpBarcodeWrongCheckDigit() => true,
      MfpValidBarcode() ||
      MfpBarcodeNotDigits() ||
      MfpBarcodeWrongLength() => false,
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
            KeypadField(value: code, error: error),
            ...switch (check) {
              MfpValidBarcode(:final format) => [
                FieldHelper(
                  icon: Icons.check_circle,
                  text: context.intl.scannerCodeValid(
                    AddText.barcodeFormat(format),
                  ),
                  color: context.colors.textLink,
                ),
              ],
              MfpBarcodeWrongCheckDigit(:final actual, :final expected) => [
                FieldHelper(
                  icon: Icons.warning_amber_rounded,
                  text: context.intl.scannerCheckDigit(actual, expected),
                  color: context.colors.textAlert,
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
}
