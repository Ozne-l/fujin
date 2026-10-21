import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';

class GlassSearchField extends StatelessWidget {
  const GlassSearchField({
    required this.controller,
    required this.hint,
    required this.textStyle,
    required this.hintStyle,
    required this.hintColor,
    required this.contentPadding,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final Color hintColor;
  final EdgeInsetsGeometry contentPadding;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) => GlassFill(
    finish: GlassFinish.clear,
    floating: true,
    child: TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      cursorWidth: FujinTheme.cursorWidth,
      style: textStyle.copyWith(color: context.colors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintStyle.copyWith(color: hintColor),
        prefixIcon: Icon(
          Icons.search,
          size: FujinSize.searchIcon,
          color: hintColor,
        ),
        suffixIcon: suffix,
        contentPadding: contentPadding,
        filled: false,
        border: FujinTheme.glassSearchFieldBorder,
        enabledBorder: FujinTheme.glassSearchFieldBorder,
        focusedBorder: FujinTheme.searchFieldFocusedBorder(context.colors),
      ),
    ),
  );
}
