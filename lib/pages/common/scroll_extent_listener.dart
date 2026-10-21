import 'package:flutter/widgets.dart';

class ScrollExtentListener extends StatelessWidget {
  const ScrollExtentListener({
    required this.scrolled,
    required this.child,
    super.key,
  });

  final ValueNotifier<double> scrolled;
  final Widget child;

  @override
  Widget build(BuildContext context) => NotificationListener<Notification>(
    onNotification: (notification) {
      if (notification
          case ScrollNotification(:final metrics, depth: 0) ||
              ScrollMetricsNotification(:final metrics, depth: 0)
          when metrics.axis == Axis.vertical) {
        scrolled.value = metrics.pixels - metrics.minScrollExtent;
      }
      return false;
    },
    child: child,
  );
}
