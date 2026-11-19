import 'package:dart_mappable/dart_mappable.dart';

part 'upload_phase.mapper.dart';

@MappableClass(discriminatorKey: 'phase')
sealed class UploadPhase with UploadPhaseMappable {
  const UploadPhase();
}

@MappableClass(discriminatorValue: 'preparing')
final class UploadPreparing extends UploadPhase with UploadPreparingMappable {
  const UploadPreparing({required this.videos, required this.percent});

  final int videos;
  final int percent;
}

@MappableClass(discriminatorValue: 'sending')
final class UploadSending extends UploadPhase with UploadSendingMappable {
  const UploadSending({required this.percent, this.waiting = false});

  final int percent;
  final bool waiting;
}

@MappableClass(discriminatorValue: 'not_sent')
final class UploadNotSent extends UploadPhase with UploadNotSentMappable {
  const UploadNotSent();
}
