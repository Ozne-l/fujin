import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

class MemorySearchField extends StatelessWidget {
  const MemorySearchField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: FujinSize.searchField,
    child: TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      style: FujinText.inter15Regular.copyWith(
        color: FujinColorRole.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).memorySearchHint,
        hintStyle: FujinText.inter15Regular.copyWith(
          color: FujinColorRole.textTertiary,
        ),
        prefixIcon: const Icon(
          Icons.search,
          size: FujinSize.searchIcon,
          color: FujinColorRole.textTertiary,
        ),
        contentPadding: EdgeInsets.zero,
        border: FujinTheme.searchFieldBorder,
        enabledBorder: FujinTheme.searchFieldBorder,
        focusedBorder: FujinTheme.searchFieldBorder,
      ),
    ),
  );
}
