import 'package:dart_mappable/dart_mappable.dart';

part 'role.mapper.dart';

@MappableEnum()
enum Role {
  twoWay,
  receiveOnly;

  bool get copiesIn => switch (this) {
    Role.twoWay => true,
    Role.receiveOnly => false,
  };
}
