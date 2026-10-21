import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/glass_search_field.dart';

class MemorySearchField extends StatelessWidget {
  const MemorySearchField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: FujinSize.searchField,
    child: GlassSearchField(
      controller: controller,
      hint: context.intl.memorySearchHint,
      textStyle: FujinText.inter15Regular,
      hintStyle: FujinText.inter15Regular,
      hintColor: context.colors.textTertiary,
      contentPadding: EdgeInsets.zero,
    ),
  );
}
