import 'package:fujin/app/providers.dart';
import 'package:fujin/pages/common/sign_in_failure.dart';
import 'package:fujin/pages/mfp_sign_in/mfp_sign_in_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final NotifierProvider<MfpSignInNotifier, MfpSignInState> mfpSignInProvider =
    NotifierProvider.autoDispose<MfpSignInNotifier, MfpSignInState>(
      MfpSignInNotifier.new,
    );

final class MfpSignInNotifier extends Notifier<MfpSignInState> {
  static const _firstServerErrorStatus = 500;

  MfpSessionCookies? _tried;
  MfpSessionCookies? _waiting;

  @override
  MfpSignInState build() => const MfpSignInIdle();

  Future<void> offer(MfpSessionCookies cookies) async {
    if (!cookies.hasSession || cookies == _tried) return;
    switch (state) {
      case MfpSignInRunning():
        _waiting = cookies;
        return;
      case MfpSignInDone():
        return;
      case MfpSignInIdle() || MfpSignInFailed():
        break;
    }
    _tried = cookies;
    state = const MfpSignInRunning();
    final next = await _attempt(ref.read(mfpClientProvider), cookies);
    if (!ref.mounted) return;
    state = next;
    _tried = switch (next) {
      MfpSignInFailed(failure: SignInFailure.unreachable) => null,
      MfpSignInIdle() || MfpSignInRunning() || MfpSignInDone() => cookies,
      MfpSignInFailed(failure: SignInFailure.refused) => cookies,
    };
    final waiting = _waiting;
    _waiting = null;
    switch ((next, waiting)) {
      case (MfpSignInFailed(), final waiting?):
        await offer(waiting);
      case _:
        break;
    }
  }

  Future<MfpSignInState> _attempt(
    MyFitnessPalClient mfp,
    MfpSessionCookies cookies,
  ) async {
    try {
      await mfp.signIn(cookies);
      return const MfpSignInDone();
    } on MfpException catch (error) {
      return switch (error) {
        MfpAuthException() => const MfpSignInFailed(SignInFailure.refused),
        MfpApiException(:final statusCode)
            when statusCode < _firstServerErrorStatus =>
          const MfpSignInFailed(SignInFailure.refused),
        MfpApiException() ||
        MfpNetworkException() ||
        MfpUnexpectedResponseException() ||
        MfpBarcodeException() => const MfpSignInFailed(
          SignInFailure.unreachable,
        ),
      };
    }
  }
}
