import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class SheetCard extends StatelessWidget {
  const SheetCard({
    required this.children,
    this.handle = false,
    this.bottomSafe = true,
    this.spacing = FujinSpace.s4,
    super.key,
  });

  final List<Widget> children;
  final bool handle;
  final bool bottomSafe;
  final double spacing;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.backgroundCard,
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(FujinRadius.sheet),
    ),
    child: SafeArea(
      top: false,
      bottom: bottomSafe,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          FujinSize.textInset,
          switch (handle) {
            true => FujinSpace.s2,
            false => FujinSpace.s6,
          },
          FujinSize.textInset,
          FujinSpace.s4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing,
          children: [
            if (handle)
              Center(
                child: Container(
                  width: FujinSize.dragHandleWidth,
                  height: FujinSize.dragHandleHeight,
                  decoration: BoxDecoration(
                    color: context.colors.borderCard,
                    borderRadius: BorderRadius.circular(FujinRadius.bar),
                  ),
                ),
              ),
            ...children,
          ],
        ),
      ),
    ),
  );
}
