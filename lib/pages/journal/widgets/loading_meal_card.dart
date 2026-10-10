import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/journal/widgets/skeleton_bar.dart';

class LoadingMealCard extends StatelessWidget {
  const LoadingMealCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
    padding: const EdgeInsets.all(FujinSpace.s5),
    decoration: BoxDecoration(
      color: FujinColorRole.backgroundCard,
      borderRadius: BorderRadius.circular(FujinRadius.card),
      border: Border.all(color: FujinColorRole.borderCard),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FujinSpace.s3,
      children: [
        SkeletonBar(
          width: FujinSize.skeletonMealTitle,
          height: FujinSize.skeletonTitle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SkeletonBar(
              width: FujinSize.skeletonMealDetail,
              height: FujinSize.skeletonLine,
            ),
            SkeletonBar(
              width: FujinSize.skeletonPillWidth,
              height: FujinSize.skeletonPill,
            ),
          ],
        ),
      ],
    ),
  );
}
