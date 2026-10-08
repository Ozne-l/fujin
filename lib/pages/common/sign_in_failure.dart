import 'package:dart_mappable/dart_mappable.dart';

part 'sign_in_failure.mapper.dart';

@MappableEnum()
enum SignInFailure { refused, unreachable }
