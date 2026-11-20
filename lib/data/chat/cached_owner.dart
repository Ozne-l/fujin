import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/json_text_hook.dart';

part 'cached_owner.mapper.dart';

@MappableClass()
final class CachedOwner with CachedOwnerMappable {
  const CachedOwner({required this.json, this.id = onlyRow});

  static const onlyRow = 1;

  final int id;
  @MappableField(hook: JsonTextHook())
  final Map<String, Object?> json;
}
