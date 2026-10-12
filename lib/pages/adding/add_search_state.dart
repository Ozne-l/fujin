import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'add_search_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class AddSearchState with AddSearchStateMappable {
  const AddSearchState({
    required this.query,
    required this.verifiedOnly,
    required this.recents,
  });

  final String query;
  final bool verifiedOnly;
  final List<RecentFood> recents;
}

@MappableClass(discriminatorValue: 'idle')
final class AddSearchIdle extends AddSearchState with AddSearchIdleMappable {
  const AddSearchIdle({
    required super.query,
    required super.verifiedOnly,
    required super.recents,
  });
}

@MappableClass(discriminatorValue: 'running')
final class AddSearchRunning extends AddSearchState
    with AddSearchRunningMappable {
  const AddSearchRunning({
    required super.query,
    required super.verifiedOnly,
    required super.recents,
  });
}

@MappableClass(discriminatorValue: 'results')
final class AddSearchResults extends AddSearchState
    with AddSearchResultsMappable {
  const AddSearchResults({
    required super.query,
    required super.verifiedOnly,
    required super.recents,
    required this.foods,
  });

  final List<MfpFood> foods;
}

@MappableClass(discriminatorValue: 'barcode_missing')
final class AddBarcodeMissing extends AddSearchState
    with AddBarcodeMissingMappable {
  const AddBarcodeMissing({
    required super.query,
    required super.verifiedOnly,
    required super.recents,
    required this.result,
  });

  final MfpBarcodeResult result;
}

@MappableClass(discriminatorValue: 'failed')
final class AddSearchFailed extends AddSearchState
    with AddSearchFailedMappable {
  const AddSearchFailed({
    required super.query,
    required super.verifiedOnly,
    required super.recents,
    required this.problem,
    this.statusCode,
  });

  final ReadProblem problem;
  final int? statusCode;
}
