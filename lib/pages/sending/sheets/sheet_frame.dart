import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

class SheetFrame extends HookWidget {
  const SheetFrame({
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.onPrimary,
    this.titleStyle = FujinText.hina28,
    this.subtitleStyle = FujinText.inter13Regular,
    this.glyph,
    this.lead = const [],
    this.initialQuery = '',
    this.onSearch,
    this.sectionLabel,
    this.body = const [],
    this.secondaryLabel,
    this.onSecondary,
    this.onSkip,
    this.skipLabel,
    super.key,
  });

  static const double _inset = FujinSize.textInset - FujinSize.screenMargin;

  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Widget? glyph;
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
  final String? skipLabel;

  static Future<void> show(
    BuildContext context, {
    required WidgetBuilder builder,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
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
                        if (glyph case final glyph?)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: FujinSpace.s1,
                            ),
                            child: glyph,
                          ),
                        Text(
                          title,
                          style: titleStyle.copyWith(
                            color: FujinColorRole.textPrimary,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: subtitleStyle.copyWith(
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
                              child: Text(skipLabel ?? l10n.skip),
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
        size: FujinSize.searchIcon,
        color: FujinColorRole.textSecondary,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: FujinSpace.s4),
      border: FujinTheme.searchFieldBorder,
      enabledBorder: FujinTheme.searchFieldBorder,
      focusedBorder: FujinTheme.searchFieldBorder,
    ),
    onSubmitted: (text) {
      if (text.trim().isEmpty) return;
      onSearch(text);
    },
  );
}
