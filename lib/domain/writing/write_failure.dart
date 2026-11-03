import 'package:fujin/data/entries/logged_entry.dart';

sealed class WriteFailure {
  const WriteFailure(this.logged, this.error);

  final LoggedEntry logged;
  final Object error;

  String get entryId => logged.entry.id;
}

final class MfpNotWritten extends WriteFailure {
  const MfpNotWritten(super.logged, super.error);
}

final class EkkloNotWritten extends WriteFailure {
  const EkkloNotWritten(super.logged, super.error);
}
