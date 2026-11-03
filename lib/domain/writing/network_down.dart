import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:fujin/domain/sending/send_interruption.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

bool networkDown(Object error) => switch (error) {
  SendInterruption(:final cause) => networkDown(cause),
  MfpNetworkException(:final method) ||
  EkkloNetworkException(:final method) => ReadOnlyHttpClient.reads(method),
  _ => false,
};
