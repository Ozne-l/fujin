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
      cursorWidth: FujinTheme.cursorWidth,
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
          _ => Semantics(
            button: true,
            label: MaterialLocalizations.of(context).deleteButtonTooltip,
            child: InkResponse(
              onTap: onClear,
              radius: FujinSize.touchTarget / 2,
              child: const SizedBox.square(
                dimension: FujinSize.touchTarget,
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: FujinColor.kinari,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(
                      dimension: FujinSize.searchIcon,
                      child: Icon(
                        Icons.close,
                        size: FujinSize.menuChevron,
                        color: FujinColorRole.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        },
        contentPadding: const EdgeInsets.symmetric(vertical: FujinSpace.s4),
        border: FujinTheme.searchFieldBorder,
        enabledBorder: FujinTheme.searchFieldBorder,
        focusedBorder: FujinTheme.searchFieldFocusedBorder,
      ),
    ),
  );
}
