import 'package:dart_mappable/dart_mappable.dart';

part 'connected_accounts.mapper.dart';

@MappableClass()
final class ConnectedAccounts with ConnectedAccountsMappable {
  const ConnectedAccounts({required this.mfp, required this.ekklo});

  final bool mfp;
  final bool ekklo;

  bool get both => mfp && ekklo;
}
