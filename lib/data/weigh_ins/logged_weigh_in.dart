import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/weigh_ins/ekklo_weigh_in_link.dart';
import 'package:fujin/data/weigh_ins/mfp_weigh_in_link.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';

part 'logged_weigh_in.mapper.dart';

@MappableClass()
final class LoggedWeighIn with LoggedWeighInMappable {
  const LoggedWeighIn({required this.weighIn, this.ekkloLink, this.mfpLink});

  final WeighIn weighIn;
  final EkkloWeighInLink? ekkloLink;
  final MfpWeighInLink? mfpLink;
}
