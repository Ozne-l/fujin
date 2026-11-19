import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class VoiceHint extends StatelessWidget {
  const VoiceHint(this.text, {super.key});

  final String text;

  static const double _vertical = 6;
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: FujinSpace.s3,
    vertical: _vertical,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: _padding,
      decoration: ShapeDecoration(
        color: colors.backgroundCard,
        shape: StadiumBorder(
          side: BorderSide(color: colors.borderCard),
        ),
      ),
      child: Text(
        text,
        style: FujinText.inter13Medium.copyWith(color: colors.textPrimary),
      ),
    );
  }
}
