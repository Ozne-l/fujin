import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/gold_volute.dart';

class GoldSeparator extends StatelessWidget {
  const GoldSeparator({this.volute = false, super.key});

  final bool volute;

  @override
  Widget build(BuildContext context) => switch (volute) {
    false => const _GoldRule(),
    true => const Row(
      spacing: FujinSpace.s2,
      children: [
        Expanded(child: _GoldRule()),
        SizedBox.square(dimension: FujinSize.volute, child: GoldVolute()),
        Expanded(child: _GoldRule()),
      ],
    ),
  };
}

class _GoldRule extends StatelessWidget {
  const _GoldRule();

  @override
  Widget build(BuildContext context) => const Divider(
    color: FujinColorRole.borderDivider,
    thickness: FujinStroke.dayRing,
    height: FujinStroke.dayRing,
  );
}
