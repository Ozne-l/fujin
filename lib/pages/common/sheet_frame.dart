import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_spinner.dart';

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
    this.busy = false,
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
  final bool busy;

  static Future<void> show(
    BuildContext context, {
    required WidgetBuilder builder,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    useSafeArea: true,
    showDragHandle: false,
    sheetAnimationStyle: FujinMotion.sheet,
    builder: builder,
  );

  static Widget handled(Widget child) => _Handled(child: child);

  static Widget inset(Widget child) => Padding(
    padding: const EdgeInsetsDirectional.symmetric(horizontal: _inset),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    final query = useTextEditingController(text: initialQuery);
    return PopScope(
      canPop: !busy,
      child: GestureDetector(
        behavior: switch (busy) {
          true => HitTestBehavior.opaque,
          false => HitTestBehavior.deferToChild,
        },
        onVerticalDragStart: switch (busy) {
          true => _holdStart,
          false => null,
        },
        onVerticalDragUpdate: switch (busy) {
          true => _holdUpdate,
          false => null,
        },
        onVerticalDragEnd: switch (busy) {
          true => _holdEnd,
          false => null,
        },
        child: _Handled(
          closable: !busy,
          child: AbsorbPointer(
            absorbing: busy,
            child: _content(context, query),
          ),
        ),
      ),
    );
  }

  static void _holdStart(DragStartDetails details) {}

  static void _holdUpdate(DragUpdateDetails details) {}

  static void _holdEnd(DragEndDetails details) {}

  Widget _content(BuildContext context, TextEditingController query) => Padding(
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
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: subtitleStyle.copyWith(
                          color: context.colors.textSecondary,
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
                          color: context.colors.textSecondary,
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
                switch (busy) {
                  true => FilledButton.icon(
                    onPressed: null,
                    icon: const FujinSpinner.button(),
                    label: Text(primaryLabel),
                  ),
                  false => FilledButton(
                    onPressed: onPrimary,
                    child: Text(primaryLabel),
                  ),
                },
                if (secondaryLabel != null || onSkip != null)
                  Row(
                    spacing: FujinSpace.s2,
                    children: [
                      if (secondaryLabel case final secondaryLabel?)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: switch (busy) {
                              true => null,
                              false => onSecondary,
                            },
                            child: Text(secondaryLabel),
                          ),
                        ),
                      if (onSkip case final onSkip?)
                        Expanded(
                          child: TextButton(
                            onPressed: switch (busy) {
                              true => null,
                              false => onSkip,
                            },
                            child: Text(skipLabel ?? context.intl.skip),
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

class _Handled extends StatelessWidget {
  const _Handled({required this.child, this.closable = true});

  final Widget child;
  final bool closable;

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.topCenter,
    children: [
      Semantics(
        label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        container: true,
        button: true,
        onTap: switch (closable) {
          true => () => Navigator.of(context).maybePop(),
          false => null,
        },
        child: SizedBox.square(
          dimension: kMinInteractiveDimension,
          child: Center(
            child: Container(
              width: FujinSize.dragHandleWidth,
              height: FujinSize.dragHandleHeight,
              decoration: BoxDecoration(
                color: context.colors.borderControl,
                borderRadius: BorderRadius.circular(FujinRadius.bar),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: kMinInteractiveDimension),
        child: child,
      ),
    ],
  );
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onSearch});

  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) => TextField(
    cursorWidth: FujinTheme.cursorWidth,
    controller: controller,
    textInputAction: TextInputAction.search,
    style: FujinText.inter16Regular.copyWith(
      color: context.colors.textPrimary,
    ),
    decoration: InputDecoration(
      hintText: context.intl.searchEkklo,
      hintStyle: FujinText.inter16Regular.copyWith(
        color: context.colors.textSecondary,
      ),
      prefixIcon: Icon(
        Icons.search,
        size: FujinSize.searchIcon,
        color: context.colors.textSecondary,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: FujinSpace.s4),
      border: FujinTheme.searchFieldBorder(context.colors),
      enabledBorder: FujinTheme.searchFieldBorder(context.colors),
      focusedBorder: FujinTheme.searchFieldBorder(context.colors),
    ),
    onSubmitted: (text) {
      if (text.trim().isEmpty) return;
      onSearch(text);
    },
  );
}
