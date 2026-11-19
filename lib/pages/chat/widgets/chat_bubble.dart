import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.mine,
    required this.child,
    this.padding = textPadding,
    this.failed = false,
    super.key,
  });

  final bool mine;
  final EdgeInsets padding;
  final bool failed;
  final Widget child;

  static const EdgeInsets textPadding = EdgeInsets.symmetric(
    horizontal: _horizontal,
    vertical: _vertical,
  );
  static const EdgeInsets mediaPadding = EdgeInsets.fromLTRB(
    FujinSpace.s1,
    FujinSpace.s1,
    FujinSpace.s1,
    FujinSpace.s2,
  );
  static const double _horizontal = 14;
  static const double _vertical = 10;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: switch (mine) {
        true => context.colors.backgroundTabActive,
        false => context.colors.backgroundCard,
      },
      border: switch ((failed, mine)) {
        (true, _) => Border.all(color: context.colors.borderAlert),
        (false, true) => null,
        (false, false) => Border.all(color: context.colors.borderCard),
      },
      borderRadius: BorderRadius.circular(FujinRadius.field),
    ),
    child: Padding(padding: padding, child: child),
  );
}
