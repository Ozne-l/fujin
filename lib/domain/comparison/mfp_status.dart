import 'package:dart_mappable/dart_mappable.dart';

part 'mfp_status.mapper.dart';

@MappableClass(discriminatorKey: 'mfp')
sealed class MfpStatus with MfpStatusMappable {
  const MfpStatus();
}

@MappableClass(discriminatorValue: 'pending')
final class MfpPending extends MfpStatus with MfpPendingMappable {
  const MfpPending();
}
