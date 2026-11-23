import 'dart:async';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/weigh_ins/logged_weigh_in.dart';
import 'package:fujin/data/weigh_ins/mfp_weigh_in_link.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/data/weigh_ins/weigh_in_repository.dart';
import 'package:fujin/domain/weighing/mfp_weight_step.dart';
import 'package:fujin/domain/weighing/weigh_in_debt.dart';
import 'package:fujin/domain/weighing/weigh_in_failure.dart';
import 'package:fujin/domain/weighing/weigh_in_import.dart';
import 'package:fujin/domain/weighing/weigh_in_writer_state.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class WeighInWriter {
  WeighInWriter({
    required this._ekklo,
    required this._mfp,
    required this._weighIns,
    required this._import,
  });

  static const _maxReadsPerDay = 10;
  static const _notFound = 404;

  final EkkloClient _ekklo;
  final MyFitnessPalClient _mfp;
  final WeighInRepository _weighIns;
  final WeighInImport _import;

  final _states = StreamController<WeighInWriterState>.broadcast();
  WeighInWriterState _state = const WeighInWriterIdle();
  Future<void>? _running;
  bool _again = false;

  WeighInWriterState get state => _state;

  Stream<WeighInWriterState> get states => _states.stream;

  Future<void> run() {
    if (_running case final running?) {
      _again = true;
      return running;
    }
    return _running = _runs().whenComplete(() => _running = null);
  }

  Future<void> _runs() async {
    do {
      _again = false;
      await _once();
    } while (_again);
  }

  Future<void> _once() async {
    final failures = {
      for (final failure in _state.failures)
        (failure.connector, failure.weighIn.id): failure,
    };
    _emit(WeighInWriterRunning(current: null, failures: [...failures.values]));
    try {
      await _import.importOnce();
      final owed = [
        for (final logged in _weighIns.pending())
          for (final connector in WeighInDebt.of(logged))
            (connector: connector, logged: logged),
      ];
      final keys = {
        for (final (:connector, :logged) in owed)
          (connector, logged.weighIn.id),
      };
      failures.removeWhere((key, _) => !keys.contains(key));
      final stopped = <Connector>{};
      for (final (:connector, :logged) in owed) {
        if (stopped.contains(connector)) continue;
        final key = (connector, logged.weighIn.id);
        _emit(
          WeighInWriterRunning(
            current: logged.weighIn,
            failures: [...failures.values],
          ),
        );
        switch (await _write(connector, logged)) {
          case final failure?:
            failures[key] = failure;
            stopped.add(connector);
          case null:
            failures.remove(key);
        }
      }
    } finally {
      _emit(WeighInWriterIdle(failures: [...failures.values]));
    }
  }

  void _emit(WeighInWriterState state) {
    _state = state;
    _states.add(state);
  }

  Future<WeighInFailure?> _write(
    Connector connector,
    LoggedWeighIn logged,
  ) async {
    final weighIn = logged.weighIn;
    try {
      switch ((connector, logged)) {
        case (Connector.ekklo, _):
          await _ekklo.measurements.logWeight(
            kilograms: weighIn.kilograms,
            date: weighIn.date,
          );
          _weighIns.linkEkklo(weighIn);
        case (
          Connector.mfp,
          LoggedWeighIn(weighIn: WeighIn(deletedAt: _?), mfpLink: final link?),
        ):
          await _removeFromMfp(link);
        case (Connector.mfp, _):
          await _writeToMfp(weighIn);
      }
      return null;
    } on Object catch (error) {
      return switch (connector) {
        Connector.ekklo => EkkloWeightNotWritten(weighIn, error),
        Connector.mfp => MfpWeightNotWritten(weighIn, error),
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
