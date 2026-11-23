import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class KeypadField extends StatelessWidget {
  const KeypadField({
    required this.value,
    required this.error,
    this.suffix,
    super.key,
  });

  final String value;
  final bool error;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = FujinText.inter18Medium.copyWith(color: colors.textPrimary);
    final (border, width) = switch (error) {
      true => (colors.textAlert, FujinStroke.fieldError),
      false => (colors.textLink, FujinStroke.fieldFocus),
    };
    return Container(
      padding: const EdgeInsets.all(FujinSpace.s4),
      decoration: BoxDecoration(
        color: colors.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.field),
        border: Border.all(color: border, width: width),
      ),
      child: Row(
        children: [
          Text(value, style: style),
          Container(
            width: FujinStroke.fieldFocus,
            height: style.fontSize,
            color: colors.textLink,
          ),
          if (suffix case final suffix?) ...[
            const Spacer(),
            Text(
              suffix,
              style: FujinText.inter15Regular.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
