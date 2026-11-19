import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class PageDots extends StatelessWidget {
  const PageDots({required this.count, required this.index, super.key});

  static const double _gap = 6;

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: _gap,
      children: [
        for (var page = 0; page < count; page++)
          Container(
            width: FujinSize.kcalBar,
            height: FujinSize.kcalBar,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: switch (page == index) {
                true => context.colors.cameraText,
                false => context.colors.cameraButton,
              },
            ),
          ),
      ],
    ),
  );
}
