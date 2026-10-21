import 'package:flutter/material.dart';
import 'package:fujin/data/settings/appearance.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_glass_button.dart';
import 'package:fujin/pages/common/fujin_glass_button_size.dart';
import 'package:fujin/pages/common/glass_layer.dart';
import 'package:fujin/pages/common/theme_reveal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppearanceToggle extends ConsumerWidget {
  const AppearanceToggle({super.key});

  static const _moonIcon = 'assets/icons/moon.svg';
  static const _sunIcon = 'assets/icons/sun.svg';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (icon, label, next) = switch (Theme.of(context).brightness) {
      Brightness.light => (
        _moonIcon,
        context.intl.appearanceToDark,
        Appearance.dark,
      ),
      Brightness.dark => (
        _sunIcon,
        context.intl.appearanceToLight,
        Appearance.light,
      ),
    };
    return GlassLayer(
      child: FujinGlassButton(
        icon: icon,
        label: label,
        onPressed: () => ThemeReveal.choose(context, ref, next),
        size: FujinGlassButtonSize.small,
      ),
    );
  }
}
