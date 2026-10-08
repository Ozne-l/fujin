import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/pages/common/sign_in_failure.dart';
import 'package:fujin/pages/ekklo_sign_in/ekklo_sign_in_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<EkkloSignInNotifier, EkkloSignInState>
ekkloSignInProvider =
    NotifierProvider.autoDispose<EkkloSignInNotifier, EkkloSignInState>(
      EkkloSignInNotifier.new,
    );

final class EkkloSignInNotifier extends Notifier<EkkloSignInState> {
  static const _firstServerErrorStatus = 500;

  @override
  EkkloSignInState build() => const EkkloSignInIdle();

  Future<void> signIn({required String email, required String password}) async {
    state = const EkkloSignInRunning();
    final next = await _attempt(ref.read(ekkloClientProvider), email, password);
    if (ref.mounted) state = next;
  }

  Future<EkkloSignInState> _attempt(
    EkkloClient ekklo,
    String email,
    String password,
  ) async {
    try {
      await ekklo.login(email: email.trim(), password: password);
      return const EkkloSignInDone();
    } on EkkloException catch (error) {
      return switch (error) {
        EkkloAuthException(:final errors) => EkkloSignInFailed(
          SignInFailure.refused,
          message: errors.firstOrNull,
        ),
        EkkloApiException(:final statusCode, :final errors)
            when statusCode < _firstServerErrorStatus =>
          EkkloSignInFailed(
            SignInFailure.refused,
            message: errors.firstOrNull,
          ),
        EkkloApiException() ||
        EkkloNetworkException() ||
        EkkloUnexpectedResponseException() => const EkkloSignInFailed(
          SignInFailure.unreachable,
        ),
      };
    }
  }
}
