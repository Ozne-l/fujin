import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class SeigaihaBand extends StatelessWidget {
  const SeigaihaBand({super.key});

  static const _tile = AssetImage('assets/images/seigaiha.png');

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: FujinSize.motifBand,
    width: double.infinity,
    child: DecoratedBox(
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
