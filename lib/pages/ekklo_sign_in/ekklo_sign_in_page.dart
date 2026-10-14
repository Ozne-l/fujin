import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/alert_banner.dart';
import 'package:fujin/pages/common/fujin_spinner.dart';
import 'package:fujin/pages/common/sign_in_failure.dart';
import 'package:fujin/pages/common/top_bar.dart';
import 'package:fujin/pages/ekklo_sign_in/ekklo_sign_in_notifier.dart';
import 'package:fujin/pages/ekklo_sign_in/ekklo_sign_in_state.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EkkloSignInPage extends HookConsumerWidget {
  const EkkloSignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ekkloSignInProvider);
    final notifier = ref.read(ekkloSignInProvider.notifier);
    final email = useTextEditingController();
    final password = useTextEditingController();
    final refused = useState(false);
    final fieldBorder = switch (refused.value) {
      true => FujinTheme.fieldErrorBorder,
      false => FujinTheme.fieldBorder,
    };
    useListenable(Listenable.merge([email, password]));

    ref.listen(ekkloSignInProvider, (previous, next) {
      switch (next) {
        case EkkloSignInDone():
          context.pop(true);
        case EkkloSignInFailed(failure: SignInFailure.refused):
          refused.value = true;
        case EkkloSignInFailed(failure: SignInFailure.unreachable) ||
            EkkloSignInIdle() ||
            EkkloSignInRunning():
          break;
      }
    });

    final running = state is EkkloSignInRunning;
    final filled = email.text.trim().isNotEmpty && password.text.isNotEmpty;
    final submit = switch (filled && !running) {
      true => () => unawaited(
        notifier.signIn(email: email.text, password: password.text),
      ),
      false => null,
    };

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopBar(title: context.intl.ekkloSignInTitle),
            Expanded(
              child: AutofillGroup(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    FujinSize.screenMargin,
                    FujinSpace.s6,
                    FujinSize.screenMargin,
                    FujinSpace.s6,
                  ),
                  children: [
                    _Inset(
                      child: Text(
                        context.intl.ekkloSignInHeading,
                        style: FujinText.hina30.copyWith(
                          color: FujinColorRole.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: FujinSpace.s2),
                    _Inset(
                      child: Text(
                        context.intl.ekkloSignInSubtitle,
                        style: FujinText.inter15Regular.copyWith(
                          color: FujinColorRole.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: FujinSpace.s6),
                    if (_banner(context.intl, state) case final banner?) ...[
                      banner,
                      const SizedBox(height: FujinSpace.s6),
                    ],
                    _Label(text: context.intl.emailLabel),
                    TextField(
                      controller: email,
                      readOnly: running,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.email],
                      cursorWidth: FujinTheme.cursorWidth,
                      style: _fieldStyle,
                      onChanged: (_) => refused.value = false,
                      decoration: InputDecoration(
                        enabledBorder: fieldBorder,
                        focusedBorder: fieldBorder,
                      ),
                    ),
                    const SizedBox(height: FujinSpace.s4),
                    _Label(text: context.intl.passwordLabel),
                    _PasswordField(
                      controller: password,
                      readOnly: running,
                      border: fieldBorder,
                      onChanged: (_) => refused.value = false,
                      onSubmitted: submit,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                FujinSize.screenMargin,
                FujinSpace.s3,
                FujinSize.screenMargin,
                FujinSpace.s4,
              ),
              child: FilledButton(
                onPressed: submit,
                child: switch (running) {
                  true => const FujinSpinner.button(),
                  false => Text(context.intl.signIn),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final TextStyle _fieldStyle = FujinText.inter16Regular.copyWith(
    color: FujinColorRole.textPrimary,
  );

  static AlertBanner? _banner(
    AppLocalizations intl,
    EkkloSignInState state,
  ) => switch (state) {
    EkkloSignInFailed(failure: SignInFailure.refused, :final message) =>
      AlertBanner(
        title: intl.ekkloSignInRefused,
        detail: switch (message) {
          final message? => intl.ekkloSignInMessage(message),
          null => intl.ekkloSignInRefusedDetail,
        },
      ),
    EkkloSignInFailed(failure: SignInFailure.unreachable) => AlertBanner(
      title: intl.ekkloSignInUnreachable,
      detail: intl.ekkloSignInUnreachableDetail,
    ),
    EkkloSignInIdle() || EkkloSignInRunning() || EkkloSignInDone() => null,
  };
}

class _Inset extends StatelessWidget {
  const _Inset({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.symmetric(
      horizontal: FujinSize.textInset - FujinSize.screenMargin,
    ),
    child: child,
  );
}

class _Label extends StatelessWidget {
  const _Label({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: FujinSpace.s2),
    child: _Inset(
      child: Text(
        text,
        style: FujinText.inter13Medium.copyWith(
          color: FujinColorRole.textPrimary,
        ),
      ),
    ),
  );
}

class _PasswordField extends HookWidget {
  const _PasswordField({
    required this.controller,
    required this.readOnly,
    required this.border,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool readOnly;
  final InputBorder border;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final shown = useState(false);
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: !shown.value,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: const [AutofillHints.password],
      cursorWidth: FujinTheme.cursorWidth,
      style: EkkloSignInPage._fieldStyle,
      onChanged: onChanged,
      onSubmitted: (_) => onSubmitted?.call(),
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
        suffixIcon: TextButton(
          onPressed: () => shown.value = !shown.value,
          style: TextButton.styleFrom(
            textStyle: FujinText.inter14Medium,
          ),
          child: Text(
            switch (shown.value) {
              true => context.intl.passwordHide,
              false => context.intl.passwordShow,
            },
          ),
        ),
      ),
    );
  }
}
