import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class SeigaihaBand extends StatelessWidget {
  const SeigaihaBand({this.height = FujinSize.motifBand, super.key});

  static const _tile = AssetImage('assets/images/seigaiha.png');

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: const DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _tile,
          repeat: ImageRepeat.repeat,
          alignment: Alignment.topLeft,
        ),
      ),
    ),
  );
}
