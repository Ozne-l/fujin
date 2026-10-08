import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

class SheetFrame extends HookWidget {
  const SheetFrame({
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.onPrimary,
    this.titleStyle = FujinText.hina28,
    this.lead = const [],
    this.initialQuery = '',
    this.onSearch,
    this.sectionLabel,
    this.body = const [],
    this.secondaryLabel,
    this.onSecondary,
    this.onSkip,
    super.key,
  });

  static const _searchIconSize = 20.0;
  static const double _inset = FujinSize.textInset - FujinSize.screenMargin;

  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final List<Widget> lead;
  final String initialQuery;
  final ValueChanged<String>? onSearch;
  final String? sectionLabel;
  final List<Widget> body;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final VoidCallback? onSkip;

  static Future<void> show(
    BuildContext context, {
    required WidgetBuilder builder,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: builder,
  );

  static Widget inset(Widget child) => Padding(
    padding: const EdgeInsetsDirectional.symmetric(horizontal: _inset),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = useTextEditingController(text: initialQuery);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          FujinSize.screenMargin,
          0,
          FujinSize.screenMargin,
          FujinSpace.s3,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: FujinSpace.s4,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: FujinSpace.s3,
                children: [
                  inset(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: FujinSpace.s2,
                      children: [
                        Text(
                          title,
                          style: titleStyle.copyWith(
                            color: FujinColorRole.textPrimary,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: FujinText.inter13Regular.copyWith(
                            color: FujinColorRole.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...lead,
                ],
              ),
              if (onSearch case final onSearch?)
                _SearchField(controller: query, onSearch: onSearch),
              if (body.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: FujinSpace.s2,
                  children: [
                    if (sectionLabel case final sectionLabel?)
                      inset(
                        Text(
                          sectionLabel,
                          style: FujinText.inter12Medium.copyWith(
                            color: FujinColorRole.textSecondary,
                          ),
                        ),
                      ),
                    ...body,
                  ],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: FujinSpace.s3,
                children: [
                  FilledButton(onPressed: onPrimary, child: Text(primaryLabel)),
                  if (secondaryLabel != null || onSkip != null)
                    Row(
                      spacing: FujinSpace.s2,
                      children: [
                        if (secondaryLabel case final secondaryLabel?)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: onSecondary,
                              child: Text(secondaryLabel),
                            ),
                          ),
                        if (onSkip case final onSkip?)
                          Expanded(
                            child: TextButton(
                              onPressed: onSkip,
                              style: _skipStyle,
                              child: Text(l10n.skip),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final ButtonStyle _skipStyle = TextButton.styleFrom(
    minimumSize: const Size(0, FujinSize.buttonMedium),
    foregroundColor: FujinColorRole.textLink,
    textStyle: FujinText.inter15Medium,
    shape: const StadiumBorder(),
  );
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onSearch});

  static const _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(FujinRadius.pill)),
    borderSide: BorderSide(color: FujinColorRole.borderCard),
  );

  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    textInputAction: TextInputAction.search,
    style: FujinText.inter16Regular.copyWith(
      color: FujinColorRole.textPrimary,
    ),
    decoration: InputDecoration(
      hintText: AppLocalizations.of(context).searchEkklo,
      hintStyle: FujinText.inter16Regular.copyWith(
        color: FujinColorRole.textSecondary,
      ),
      prefixIcon: const Icon(
        Icons.search,
        size: SheetFrame._searchIconSize,
        color: FujinColorRole.textSecondary,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: FujinSpace.s4),
      border: _border,
      enabledBorder: _border,
      focusedBorder: _border,
    ),
    onSubmitted: (text) {
      if (text.trim().isEmpty) return;
      onSearch(text);
    },
  );
}
