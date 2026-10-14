import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassLayer extends StatelessWidget {
  const GlassLayer({required this.child, super.key});

  final Widget child;

  static const _settings = LiquidGlassSettings(
    glassColor: FujinColorRole.backgroundGlass,
    blur: FujinSize.glassBlur,
    thickness: 16,
    lightIntensity: 0.6,
    ambientStrength: 0.2,
    saturation: 1.2,
  );
  static const double _blend = 3;

  @override
  Widget build(BuildContext context) => LiquidGlassLayer(
    settings: _settings,
    child: LiquidGlassBlendGroup(blend: _blend, child: child),
  );
}
