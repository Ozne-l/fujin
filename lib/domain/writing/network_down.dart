import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:fujin/domain/sending/send_interruption.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

bool networkDown(Object error, {required bool readOnly}) => switch (error) {
  SendInterruption(:final cause) => networkDown(cause, readOnly: readOnly),
  MfpNetworkException(:final method) || EkkloNetworkException(:final method) =>
    !readOnly || ReadOnlyHttpClient.reads(method),
  _ => false,
};
