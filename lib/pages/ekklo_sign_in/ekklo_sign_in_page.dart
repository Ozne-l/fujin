import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/alert_banner.dart';
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
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(ekkloSignInProvider);
    final notifier = ref.read(ekkloSignInProvider.notifier);
    final email = useTextEditingController();
    final password = useTextEditingController();
    final passwordRefused = useState(false);
    useListenable(Listenable.merge([email, password]));

    ref.listen(ekkloSignInProvider, (previous, next) {
      switch (next) {
        case EkkloSignInDone():
          context.pop(true);
        case EkkloSignInFailed(failure: SignInFailure.refused):
          passwordRefused.value = true;
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
            TopBar(title: l10n.ekkloSignInTitle),
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
                        l10n.ekkloSignInHeading,
                        style: FujinText.hina30.copyWith(
                          color: FujinColorRole.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: FujinSpace.s2),
                    _Inset(
                      child: Text(
                        l10n.ekkloSignInSubtitle,
                        style: FujinText.inter15Regular.copyWith(
                          color: FujinColorRole.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: FujinSpace.s6),
                    if (_banner(l10n, state) case final banner?) ...[
                      banner,
                      const SizedBox(height: FujinSpace.s6),
                    ],
                    _Label(text: l10n.emailLabel),
                    TextField(
                      controller: email,
                      readOnly: running,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.email],
                      style: _fieldStyle,
                    ),
                    const SizedBox(height: FujinSpace.s4),
                    _Label(text: l10n.passwordLabel),
                    _PasswordField(
                      controller: password,
                      readOnly: running,
                      refused: passwordRefused.value,
                      onChanged: (_) => passwordRefused.value = false,
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
                  true => const SizedBox.square(
                    dimension: FujinSize.icon,
                    child: CircularProgressIndicator(
                      strokeWidth: FujinStroke.icon,
                      color: FujinColorRole.buttonDisabledText,
                    ),
                  ),
                  false => Text(l10n.signIn),
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
    AppLocalizations l10n,
    EkkloSignInState state,
  ) => switch (state) {
    EkkloSignInFailed(failure: SignInFailure.refused, :final message) =>
      AlertBanner(
        title: l10n.ekkloSignInRefused,
        detail: switch (message) {
          final message? => l10n.ekkloSignInMessage(message),
          null => null,
        },
      ),
    EkkloSignInFailed(failure: SignInFailure.unreachable) => AlertBanner(
      title: l10n.ekkloSignInUnreachable,
      detail: l10n.ekkloSignInUnreachableDetail,
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
    required this.refused,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool readOnly;
  final bool refused;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shown = useState(false);
    final border = switch (refused) {
      true => FujinTheme.fieldErrorBorder,
      false => FujinTheme.fieldBorder,
    };
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: !shown.value,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: const [AutofillHints.password],
      style: EkkloSignInPage._fieldStyle,
      onChanged: onChanged,
      onSubmitted: (_) => onSubmitted?.call(),
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
        suffixIcon: TextButton(
          onPressed: () => shown.value = !shown.value,
          style: TextButton.styleFrom(
            foregroundColor: FujinColorRole.textLink,
            textStyle: FujinText.inter14Medium,
          ),
          child: Text(
            switch (shown.value) {
              true => l10n.passwordHide,
              false => l10n.passwordShow,
            },
          ),
        ),
      ),
    );
  }
}
