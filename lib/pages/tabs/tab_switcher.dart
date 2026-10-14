import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:motor/motor.dart';

class TabSwitcher extends StatelessWidget {
  const TabSwitcher({required this.index, required this.children, super.key});

  final int index;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      for (final (branch, child) in children.indexed)
        _Branch(active: branch == index, child: child),
    ],
  );
}

class _Branch extends StatelessWidget {
  const _Branch({required this.active, required this.child});

  final bool active;
  final Widget child;

  static const double _shown = 1;
  static const double _hidden = 0;

  @override
  Widget build(BuildContext context) => SingleMotionBuilder(
    motion: FujinMotion.of(context, FujinMotion.fadeThrough),
    value: active ? _shown : _hidden,
    builder: (context, visibility, child) => Offstage(
      offstage: !active && visibility == _hidden,
      child: TickerMode(
        enabled: active,
        child: IgnorePointer(
          ignoring: !active,
          child: ExcludeSemantics(
            excluding: !active,
            child: ExcludeFocus(
              excluding: !active,
              child: Opacity(
                opacity: visibility.clamp(_hidden, _shown),
                child: Transform.scale(
                  scale:
                      FujinMotion.fadeThroughScale +
                      (_shown - FujinMotion.fadeThroughScale) * visibility,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    child: child,
  );
}
