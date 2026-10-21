import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_layer.dart';
import 'package:fujin/pages/common/scan_button.dart';
import 'package:fujin/pages/tabs/fujin_tab.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';
import 'package:motor/motor.dart';

class FloatingTabBar extends StatelessWidget {
  const FloatingTabBar({
    required this.selected,
    required this.onSelect,
    required this.onScan,
    required this.minimized,
    super.key,
  });

  final FujinTab selected;
  final ValueChanged<FujinTab> onSelect;
  final VoidCallback? onScan;
  final bool minimized;

  static const double _fullScale = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s5),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: FujinSpace.s6),
        child: SingleMotionBuilder(
          motion: FujinMotion.of(context, FujinMotion.barMinimize),
          value: switch (minimized) {
            true => FujinMotion.minimizedBarScale,
            false => _fullScale,
          },
          builder: (context, scale, child) => Transform.scale(
            scale: scale,
            alignment: Alignment.bottomCenter,
            child: child,
          ),
          child: GlassLayer(
            child: Row(
              spacing: FujinSpace.s2,
              children: [
                Expanded(
                  child: TabPlate(selected: selected, onSelect: onSelect),
                ),
                ScanButton(onTap: onScan),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
