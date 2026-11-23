import 'dart:async';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/weigh_ins/mfp_weigh_in_link.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/data/weigh_ins/weigh_in_repository.dart';
import 'package:fujin/domain/weighing/mfp_weight_step.dart';
import 'package:fujin/domain/weighing/weigh_in_debt.dart';
import 'package:fujin/domain/weighing/weigh_in_failure.dart';
import 'package:fujin/domain/weighing/weigh_in_import.dart';
import 'package:fujin/domain/weighing/weigh_in_writer_state.dart';
import 'package:fujin/domain/writing/network_down.dart';
import 'package:fujin/domain/writing/single_flight.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class WeighInWriter {
  WeighInWriter({
    required this._ekklo,
    required this._mfp,
    required this._weighIns,
    required this._import,
    required this._readOnly,
  });

  static const _maxReadsPerDay = 10;
  static const _notFound = 404;

  final EkkloClient _ekklo;
  final MyFitnessPalClient _mfp;
  final WeighInRepository _weighIns;
  final WeighInImport _import;
  final bool _readOnly;

  final _states = StreamController<WeighInWriterState>.broadcast();
  late final _flight = SingleFlight(_once);
  WeighInWriterState _state = const WeighInWriterIdle();

  WeighInWriterState get state => _state;

  Stream<WeighInWriterState> get states => _states.stream;

  Future<void> run() => _flight.run();

  Future<void> _once() async {
    final failures = {
      for (final failure in _state.failures) failure.key: failure,
    };
    _emit(WeighInWriterRunning(current: null, failures: [...failures.values]));
    try {
      await _import.importOnce();
      final owed = [
        for (final logged in _weighIns.pending()) ...WeighInDebt.of(logged),
      ];
      final keys = {for (final debt in owed) debt.key};
      failures.removeWhere((key, _) => !keys.contains(key));
      final stopped = <Connector>{};
      for (final planned in owed) {
        if (stopped.contains(planned.connector)) continue;
        final key = planned.key;
        switch (_stillOwed(planned)) {
          case final debt?:
            _emit(
              WeighInWriterRunning(
                current: debt.weighIn,
                failures: [...failures.values],
              ),
            );
            switch (await _write(debt)) {
              case final failure?
                  when networkDown(failure.error, readOnly: _readOnly):
                failures.remove(key);
                stopped.add(debt.connector);
              case final failure?:
                failures[key] = failure;
                stopped.add(debt.connector);
              case null:
                failures.remove(key);
            }
          case null:
            failures.remove(key);
        }
      }
    } finally {
      _emit(WeighInWriterIdle(failures: [...failures.values]));
    }
  }

  WeighInDebt? _stillOwed(WeighInDebt planned) =>
      switch (_weighIns.find(planned.weighIn.id)) {
        final logged? => WeighInDebt.of(
          logged,
        ).where((debt) => debt.connector == planned.connector).firstOrNull,
        null => null,
      };

  void _emit(WeighInWriterState state) {
    _state = state;
    _states.add(state);
  }

  Future<WeighInFailure?> _write(WeighInDebt debt) async {
    try {
      switch (debt) {
        case EkkloWeighInWrite(:final weighIn):
          await _ekklo.measurements.logWeight(
            kilograms: weighIn.kilograms,
            date: weighIn.date,
          );
          _weighIns.linkEkklo(weighIn);
        case MfpWeighInDeletion(:final link):
          await _removeFromMfp(link);
        case MfpWeighInWrite(:final weighIn):
          await _writeToMfp(weighIn);
      }
      return null;
    } on Object catch (error) {
      return switch (debt.connector) {
        Connector.ekklo => EkkloWeightNotWritten(debt.weighIn, error),
        Connector.mfp => MfpWeightNotWritten(debt.weighIn, error),
      };
    }
  }

  Future<void> _writeToMfp(WeighIn weighIn) async {
    for (var read = 0; read < _maxReadsPerDay; read++) {
      final day = await _mfp.measurements.forDate(weighIn.date);
      switch (MfpWeightStep.next(weighIn.kilograms, day)) {
        case AdoptMeasurement(:final measurementId):
          _weighIns.linkMfp(weighIn, measurementId: measurementId);
          return;
        case RemoveMeasurement(:final measurementId):
          await _mfp.measurements.remove(measurementId);
        case PostWeight():
          final posted =
              await _mfp.measurements.logWeight(
                value: weighIn.kilograms,
                unit: MfpWeightUnit.kilograms,
                date: weighIn.date,
              ) ??
              (throw StateError('MyFitnessPal returned no measurement'));
          _weighIns.linkMfp(weighIn, measurementId: posted.id);
          return;
      }
    }
    throw StateError('MyFitnessPal kept other weights on ${weighIn.date}');
  }

  Future<void> _removeFromMfp(MfpWeighInLink link) async {
    try {
      await _mfp.measurements.remove(link.measurementId);
    } on MfpApiException catch (error) {
      if (error.statusCode != _notFound) rethrow;
    }
    _weighIns.unlinkMfp(link.weighInId);
  }
}
