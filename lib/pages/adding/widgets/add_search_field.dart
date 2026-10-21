import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/glass_search_field.dart';

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
    child: GlassSearchField(
      controller: controller,
      hint: context.intl.addSearchHint,
      textStyle: FujinText.inter16Medium,
      hintStyle: FujinText.inter16Regular,
      hintColor: context.colors.textSecondary,
      contentPadding: const EdgeInsets.symmetric(vertical: FujinSpace.s4),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      suffix: switch (controller.text) {
        '' => null,
        _ => Semantics(
          button: true,
          label: MaterialLocalizations.of(context).deleteButtonTooltip,
          child: InkResponse(
            onTap: onClear,
            radius: FujinSize.touchTarget / 2,
            child: SizedBox.square(
              dimension: FujinSize.touchTarget,
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.backgroundNeutral,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: FujinSize.searchIcon,
                    child: Icon(
                      Icons.close,
                      size: FujinSize.menuChevron,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      },
    ),
  );
}
