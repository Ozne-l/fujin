import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class SeigaihaBand extends StatelessWidget {
  const SeigaihaBand({this.height = FujinSize.motifBand, super.key});

  static const _lightTile = AssetImage('assets/images/seigaiha.png');
  static const _darkTile = AssetImage('assets/images/seigaiha_dark.png');

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: switch (Theme.of(context).brightness) {
            Brightness.light => _lightTile,
            Brightness.dark => _darkTile,
          },
          repeat: ImageRepeat.repeat,
          alignment: Alignment.topLeft,
        ),
      ),
    ),
  );
}
