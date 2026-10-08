import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fujin/app/config.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/fujin_icon_button.dart';
import 'package:fujin/pages/common/sign_in_failure.dart';
import 'package:fujin/pages/mfp_sign_in/mfp_sign_in_notifier.dart';
import 'package:fujin/pages/mfp_sign_in/mfp_sign_in_state.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class MfpSignInPage extends HookConsumerWidget {
  const MfpSignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(mfpSignInProvider);
    final notifier = ref.read(mfpSignInProvider.notifier);
    final webView = useState<InAppWebViewController?>(null);

    ref.listen(mfpSignInProvider, (previous, next) {
      switch (next) {
        case MfpSignInDone():
          context.pop(true);
        case MfpSignInIdle() || MfpSignInRunning() || MfpSignInFailed():
          break;
      }
    });

    Future<void> inspect(InAppWebViewController controller) async {
      final cookies = await CookieManager.instance().getCookies(
        url: WebUri.uri(Config.mfpWebUri),
        webViewController: controller,
      );
      if (!context.mounted) return;
      await notifier.offer(
        MfpSessionCookies({
          for (final cookie in cookies) cookie.name: '${cookie.value}',
        }),
      );
    }

    final (dot, message) = switch (state) {
      MfpSignInFailed(failure: SignInFailure.refused) => (
        FujinColorRole.textAlert,
        l10n.mfpSignInRefused,
      ),
      MfpSignInFailed(failure: SignInFailure.unreachable) => (
        FujinColorRole.textAlert,
        l10n.mfpSignInUnreachable,
      ),
      MfpSignInIdle() || MfpSignInRunning() || MfpSignInDone() => (
        FujinColor.kin,
        l10n.mfpSignInHint,
      ),
    };

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: FujinColorRole.backgroundCard,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  FujinSize.screenMargin,
                  0,
                  FujinSize.screenMargin,
                  FujinSpace.s3,
                ),
                child: Row(
                  children: [
                    FujinIconButton(
                      icon: Icons.close,
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).closeButtonTooltip,
                      onPressed: () => context.pop(false),
                    ),
                    Expanded(
                      child: Column(
                        spacing: FujinSpace.s1,
                        children: [
                          Text(
                            l10n.sourceMyFitnessPal,
                            style: FujinText.inter15Medium.copyWith(
                              color: FujinColorRole.textPrimary,
                            ),
                          ),
                          Text(
                            Config.mfpWebUri.host,
                            style: FujinText.inter12Regular.copyWith(
                              color: FujinColorRole.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FujinIconButton(
                      icon: Icons.refresh,
                      tooltip: l10n.reload,
                      onPressed: () => unawaited(webView.value?.reload()),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(color: FujinColorRole.borderHairline),
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri.uri(Config.mfpSignInUri),
                  ),
                  onWebViewCreated: (controller) => webView.value = controller,
                  onLoadStop: (controller, _) => unawaited(inspect(controller)),
                  onUpdateVisitedHistory: (controller, _, _) =>
                      unawaited(inspect(controller)),
                ),
                PositionedDirectional(
                  start: FujinSize.screenMargin,
                  end: FujinSize.screenMargin,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    minimum: const EdgeInsets.only(bottom: FujinSpace.s4),
                    child: _Toast(dot: dot, message: message),
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

class _Toast extends StatelessWidget {
  const _Toast({required this.dot, required this.message});

  final Color dot;
  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: FujinSpace.s4,
      vertical: FujinSpace.s3,
    ),
    decoration: BoxDecoration(
      color: FujinColorRole.backgroundDark,
      borderRadius: BorderRadius.circular(FujinRadius.toast),
    ),
    child: Row(
      spacing: FujinSpace.s3,
      children: [
        Container(
          width: FujinSpace.s2,
          height: FujinSpace.s2,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        Expanded(
          child: Text(
            message,
            style: FujinText.inter14Medium.copyWith(
              color: FujinColorRole.textOnDark,
            ),
          ),
        ),
      ],
    ),
  );
}
