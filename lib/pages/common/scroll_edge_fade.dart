import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class ScrollEdgeFade extends HookWidget {
  const ScrollEdgeFade({required this.child, super.key});

  final Widget child;

  static const double _none = 0;

  @override
  Widget build(BuildContext context) {
    final fade = useState(_none);
    return NotificationListener<Notification>(
      onNotification: (notification) {
        if (notification
            case ScrollNotification(
                  :final metrics,
                  depth: 0,
                ) ||
                ScrollMetricsNotification(:final metrics, depth: 0)
            when metrics.axis == Axis.vertical) {
          fade.value = metrics.extentBefore.clamp(
            _none,
            FujinSize.scrollEdgeFade,
          );
        }
        return false;
      },
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FujinColorRole.backgroundPage.withValues(alpha: 0),
            FujinColorRole.backgroundPage,
          ],
          stops: [_none, fade.value / bounds.height],
        ).createShader(bounds),
        child: child,
      ),
    );
  }
}
