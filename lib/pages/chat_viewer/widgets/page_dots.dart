import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

class PageDots extends StatelessWidget {
  const PageDots({required this.count, required this.index, super.key});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: FujinSize.pageDotGap,
        children: [
          for (var page = 0; page < count; page++)
            SingleMotionBuilder(
              motion: FujinMotion.of(context, FujinMotion.pill),
              value: switch (page == index) {
                true => 1.0,
                false => 0.0,
              },
              builder: (context, selected, child) {
                final shown = selected.clamp(0.0, 1.0);
                return Container(
                  width: FujinSize.kcalBar * (1 + shown),
                  height: FujinSize.kcalBar,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(FujinRadius.pill),
                    color: Color.lerp(
                      colors.cameraButton,
                      colors.cameraText,
                      shown,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
