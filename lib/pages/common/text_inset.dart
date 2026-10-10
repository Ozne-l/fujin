import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class TextInset extends StatelessWidget {
  const TextInset({
    required this.child,
    this.top = 0,
    this.bottom = 0,
    super.key,
  });

  static const double horizontal = FujinSize.textInset - FujinSize.screenMargin;

  final double top;
  final double bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsDirectional.fromSTEB(
      horizontal,
      top,
      horizontal,
      bottom,
    ),
    child: child,
  );
}
