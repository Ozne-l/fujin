import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/milestones/milestone.dart';
import 'package:fujin/data/milestones/milestone_repository.dart';
import 'package:fujin/data/weigh_ins/weigh_in_repository.dart';
import 'package:fujin/domain/weighing/imported_weights.dart';

final class WeighInImport {
  const WeighInImport({
    required this._ekklo,
    required this._weighIns,
    required this._milestones,
  });

  final EkkloClient _ekklo;
  final WeighInRepository _weighIns;
  final MilestoneRepository _milestones;

  Future<void> importOnce() async {
    if (_milestones.reached(Milestone.ekkloWeightsImported)) return;
    final List<EkkloWeightEntry> history;
    try {
      history = await _ekklo.measurements.weightHistory();
    } on EkkloException {
      return;
    }
    _weighIns.importLinked(importedWeights(history, taken: _weighIns.days()));
    await _milestones.markReached(Milestone.ekkloWeightsImported);
  }
}
