import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/edge_blur.dart';
import 'package:fujin/pages/common/scroll_extent_listener.dart';

class ScrollEdgeBlur extends HookWidget {
  const ScrollEdgeBlur({
    required this.top,
    required this.child,
    this.cover = 0,
    super.key,
  });

  final double top;
  final double cover;
  final Widget child;

  static const double _none = 0;

  @override
  Widget build(BuildContext context) {
    final scrolled = useValueNotifier(_none);
    return ScrollExtentListener(
      scrolled: scrolled,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          child,
          ValueListenableBuilder(
            valueListenable: scrolled,
            builder: (context, scrolled, _) => switch (scrolled) {
              <= _none => const SizedBox.shrink(),
              _ => Positioned(
                top: _none,
                left: _none,
                right: _none,
                height:
                    top +
                    scrolled.clamp(_none, cover + FujinSize.scrollEdgeFade),
                child: const EdgeBlur(),
              ),
            },
          ),
        ],
      ),
    );
  }
}
