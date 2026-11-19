import 'package:dart_mappable/dart_mappable.dart';

part 'message_in_progress_state.mapper.dart';

@MappableEnum()
enum MessageInProgressState { processing, uploading, failed }
