import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

class AddSearchField extends StatelessWidget {
  const AddSearchField({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
    child: TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: FujinText.inter16Medium.copyWith(
        color: FujinColorRole.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).addSearchHint,
        hintStyle: FujinText.inter16Regular.copyWith(
          color: FujinColorRole.textSecondary,
        ),
        prefixIcon: const Icon(
          Icons.search,
          size: FujinSize.searchIcon,
          color: FujinColorRole.textSecondary,
        ),
        suffixIcon: switch (controller.text) {
          '' => null,
          _ => IconButton(
            onPressed: onClear,
            tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
            icon: const Icon(
              Icons.cancel,
              size: FujinSize.searchIcon,
              color: FujinColorRole.textTertiary,
            ),
          ),
        },
        contentPadding: const EdgeInsets.symmetric(vertical: FujinSpace.s4),
        border: FujinTheme.searchFieldBorder,
        enabledBorder: FujinTheme.searchFieldBorder,
        focusedBorder: FujinTheme.searchFieldBorder,
      ),
    ),
  );
}
