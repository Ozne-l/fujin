import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';

class GlassTextField extends StatelessWidget {
  const GlassTextField({
    required this.controller,
    required this.hint,
    this.focusNode,
    this.trailing,
    this.endInset,
    this.radius = FujinRadius.button,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final FocusNode? focusNode;
  final Widget? trailing;
  final double? endInset;
  final double radius;

  static const int _maxLines = 5;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      minLines: 1,
      maxLines: _maxLines,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      cursorWidth: FujinTheme.cursorWidth,
      style: FujinText.inter16Regular.copyWith(
        color: colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: FujinText.inter16Regular.copyWith(
          color: colors.textSecondary,
        ),
        filled: false,
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: FujinSpace.s4,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
    return GlassFill(
      finish: GlassFinish.clear,
      floating: true,
      radius: radius,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: FujinSize.field),
        child: Padding(
          padding: EdgeInsets.only(
            left: FujinSpace.s4,
            right: switch ((endInset, trailing)) {
              (final endInset?, _) => endInset,
              (null, null) => FujinSpace.s4,
              (null, _) => FujinSpace.s1,
            },
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: switch (FujinMotion.reduced(context)) {
                  true => field,
                  false => AnimatedSize(
                    duration: FujinMotion.grow.duration,
                    curve: FujinMotion.grow.curve,
                    alignment: Alignment.bottomLeft,
                    child: field,
                  ),
                },
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
