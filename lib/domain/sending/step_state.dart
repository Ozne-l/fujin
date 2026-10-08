import 'package:dart_mappable/dart_mappable.dart';

part 'step_state.mapper.dart';

@MappableEnum()
enum StepState { pending, running, done, failed }
