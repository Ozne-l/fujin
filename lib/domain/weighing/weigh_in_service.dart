import 'dart:async';

import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/data/weigh_ins/weigh_in_repository.dart';
import 'package:fujin/domain/weighing/kilograms.dart';
import 'package:fujin/domain/weighing/weigh_in_writer.dart';

final class WeighInService {
  const WeighInService({required this._weighIns, required this._writer});

  final WeighInRepository _weighIns;
  final WeighInWriter _writer;

  WeighIn save({required DateTime date, required double kilograms}) {
    final saved = _weighIns.save(
      date: date,
      kilograms: Kilograms.rounded(kilograms),
    );
    unawaited(_writer.run());
    return saved;
  }

  void remove(String weighInId) {
    _weighIns.remove(weighInId);
    unawaited(_writer.run());
  }
}
