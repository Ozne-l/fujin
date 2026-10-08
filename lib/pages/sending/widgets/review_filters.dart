import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';

class ReviewFilters extends StatelessWidget {
  const ReviewFilters({required this.chips, super.key});

  final List<
    ({String label, PillTone tone, bool selected, VoidCallback onSelected})
  >
  chips;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
    child: Row(
      spacing: FujinSpace.s2,
      children: [
        for (final chip in chips)
          Semantics(
            button: true,
            selected: chip.selected,
            child: InkWell(
              onTap: chip.onSelected,
              borderRadius: BorderRadius.circular(FujinRadius.pill),
              child: StatusPill(
                label: chip.label,
                tone: switch (chip.selected) {
                  true => PillTone.dark,
                  false => chip.tone,
                },
              ),
            ),
          ),
      ],
    ),
  );
}
