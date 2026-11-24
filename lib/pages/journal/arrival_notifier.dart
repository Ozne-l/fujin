import 'package:fujin/data/entries/logged_entry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final arrivalProvider = NotifierProvider<ArrivalNotifier, String?>(
  ArrivalNotifier.new,
);

final class ArrivalNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void arrive(LoggedEntry logged) => state = logged.entry.id;

  void settle(String entryId) {
    if (state == entryId) state = null;
  }
}
