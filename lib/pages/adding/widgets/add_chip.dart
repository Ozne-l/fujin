import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';

class AddChip extends StatelessWidget {
  const AddChip({
    required this.label,
    required this.selected,
    this.icon,
    this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final Widget? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final finish = switch (selected) {
      true => GlassFinish.validated,
      false => GlassFinish.clear,
    };
    final foreground = finish.foreground(context.colors);
    return Semantics(
      button: true,
      selected: selected,
      child: GlassFill(
        finish: finish,
        floating: true,
        pressable: onTap != null,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            customBorder: const StadiumBorder(),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: FujinSize.touchTarget,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: FujinSpace.s2,
                  children: [
                    if (icon case final icon?)
                      IconTheme(
                        data: IconThemeData(
                          color: foreground,
                          size: FujinSize.searchIcon,
                        ),
                        child: icon,
                      ),
                    Text(
                      label,
                      style: FujinText.inter14Medium.copyWith(
                        color: foreground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
