import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class SendFooter extends StatelessWidget {
  const SendFooter({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      FujinSize.screenMargin,
      FujinSpace.s3,
      FujinSize.screenMargin,
      FujinSpace.s4,
    ),
    child: child,
  );
}
