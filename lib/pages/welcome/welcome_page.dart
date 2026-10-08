import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/accounts/connected_accounts.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
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
                              l10n.appName,
                              style: FujinText.hina22.copyWith(
                                color: FujinColorRole.textLink,
                              ),
                            ),
                            const SizedBox(height: FujinSpace.s5),
                            Text(
                              l10n.welcomeHeading,
                              style: FujinText.hina30.copyWith(
                                color: FujinColorRole.textPrimary,
                              ),
                            ),
                            const SizedBox(height: FujinSpace.s6),
                            Text(
                              l10n.welcomeIntro,
                              style: FujinText.inter15Regular.copyWith(
                                color: FujinColorRole.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: FujinSpace.s8),
                      _AccountCard(
                        name: l10n.sourceMyFitnessPal,
                        role: l10n.mfpAccountRole,
                        dot: FujinColorRole.sourceMfp,
                        connected: accounts?.mfp,
                        onSignIn: () => unawaited(signIn(FujinRoute.mfpSignIn)),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: FujinSpace.s4),
                        child: Center(child: GoldVolute()),
                      ),
                      _AccountCard(
                        name: l10n.sourceEkklo,
                        role: l10n.ekkloAccountRole,
                        dot: FujinColorRole.sourceEkklo,
                        connected: accounts?.ekklo,
                        onSignIn: () =>
                            unawaited(signIn(FujinRoute.ekkloSignIn)),
                      ),
                      const SizedBox(height: FujinSpace.s5),
                      Text(
                        l10n.credentialsStayOnPhone,
                        textAlign: TextAlign.center,
                        style: FujinText.inter13Regular.copyWith(
                          color: FujinColorRole.textTertiary,
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
                    onPressed: proceed,
                    child: Text(l10n.continueAction),
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
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FujinSpace.s5,
        vertical: FujinSpace.s4,
      ),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: FujinColorRole.borderCard),
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
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                  Text(
                    switch (connected) {
                      true => l10n.accountSessionActive,
                      false || null => role,
                    },
                    style: FujinText.inter13Regular.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            switch (connected) {
              true => StatusPill(
                label: l10n.accountConnected,
                tone: PillTone.validated,
                icon: Icons.check,
              ),
              false => OutlinedButton(
                onPressed: onSignIn,
                child: Text(l10n.signIn),
              ),
              null => const SizedBox.shrink(),
            },
          ],
        ),
      ),
    );
  }
}
