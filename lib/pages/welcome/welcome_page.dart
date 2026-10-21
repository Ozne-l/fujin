import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/accounts/connected_accounts.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/gold_volute.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/seigaiha_band.dart';
import 'package:fujin/pages/common/source_dot.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/welcome/connected_accounts_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = switch (ref.watch(connectedAccountsProvider)) {
      AsyncData(:final value) => value,
      AsyncLoading() || AsyncError() => null,
    };

    Future<void> signIn(FujinRoute route) async {
      await context.push<bool>(route.path);
      ref.invalidate(connectedAccountsProvider);
    }

    final proceed = switch (accounts) {
      ConnectedAccounts(both: true) => () => context.go(
        FujinRoute.journal.path,
      ),
      ConnectedAccounts() || null => null,
    };

    return Scaffold(
      body: Stack(
        children: [
          const PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: SeigaihaBand(),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      FujinSize.screenMargin,
                      FujinSpace.s1,
                      FujinSize.screenMargin,
                      FujinSpace.s6,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal:
                              FujinSize.textInset - FujinSize.screenMargin,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.intl.appName,
                              style: FujinText.hina22.copyWith(
                                color: context.colors.textLink,
                              ),
                            ),
                            const SizedBox(height: FujinSpace.s5),
                            Text(
                              context.intl.welcomeHeading,
                              style: FujinText.hina30.copyWith(
                                color: context.colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: FujinSpace.s6),
                            Text(
                              context.intl.welcomeIntro,
                              style: FujinText.inter15Regular.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: FujinSpace.s8),
                      _AccountCard(
                        name: context.intl.sourceMyFitnessPal,
                        role: context.intl.mfpAccountRole,
                        dot: context.colors.sourceMfp,
                        connected: accounts?.mfp,
                        onSignIn: () => unawaited(signIn(FujinRoute.mfpSignIn)),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: FujinSpace.s4),
                        child: Center(child: GoldVolute()),
                      ),
                      _AccountCard(
                        name: context.intl.sourceEkklo,
                        role: context.intl.ekkloAccountRole,
                        dot: context.colors.sourceEkklo,
                        connected: accounts?.ekklo,
                        onSignIn: () =>
                            unawaited(signIn(FujinRoute.ekkloSignIn)),
                      ),
                      const SizedBox(height: FujinSpace.s5),
                      Text(
                        context.intl.credentialsStayOnPhone,
                        textAlign: TextAlign.center,
                        style: FujinText.inter13Regular.copyWith(
                          color: context.colors.textTertiary,
                        ),
                      ),
                    ],
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
                    style: FujinTheme.floatingButtonStyle(context.colors),
                    onPressed: proceed,
                    child: Text(context.intl.continueAction),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.name,
    required this.role,
    required this.dot,
    required this.connected,
    required this.onSignIn,
  });

  final String name;
  final String role;
  final Color dot;
  final bool? connected;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FujinSpace.s5,
        vertical: FujinSpace.s4,
      ),
      decoration: BoxDecoration(
        color: context.colors.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: context.colors.borderCard),
      ),
      child: SizedBox(
        height: FujinSize.buttonMedium,
        child: Row(
          spacing: FujinSpace.s3,
          children: [
            SourceDot(color: dot),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: FujinSpace.s2,
                children: [
                  Text(
                    name,
                    style: FujinText.inter16Medium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                  Text(
                    switch (connected) {
                      true => context.intl.accountSessionActive,
                      false || null => role,
                    },
                    style: FujinText.inter13Regular.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            switch (connected) {
              true => StatusPill(
                label: context.intl.accountConnected,
                tone: PillTone.validated,
                icon: Icons.check,
              ),
              false => OutlinedButton(
                onPressed: onSignIn,
                child: Text(context.intl.signIn),
              ),
              null => const SizedBox.shrink(),
            },
          ],
        ),
      ),
    );
  }
}
