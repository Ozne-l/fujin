import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/weigh_ins/ekklo_weigh_in_link.dart';
import 'package:fujin/data/weigh_ins/logged_weigh_in.dart';
import 'package:fujin/data/weigh_ins/mfp_weigh_in_link.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/domain/weighing/weigh_in_debt.dart';

import '../../support/fixtures.dart';

final _weighIn = WeighIn(id: 'w-1', date: day, kilograms: 68.9, updatedAt: now);

EkkloWeighInLink _ekklo(double kilograms) => EkkloWeighInLink(
  id: 'e-1',
  weighInId: 'w-1',
  date: day,
  kilograms: kilograms,
  updatedAt: now,
);

MfpWeighInLink _mfp(double kilograms) => MfpWeighInLink(
  id: 'm-1',
  weighInId: 'w-1',
  measurementId: '101',
  date: day,
  kilograms: kilograms,
  updatedAt: now,
);

void main() {
  test('owes a live weigh-in to each app without a link holding its '
      'kilograms', () {
    check(
      WeighInDebt.of(LoggedWeighIn(weighIn: _weighIn)),
    ).deepEquals([Connector.ekklo, Connector.mfp]);
    check(
      WeighInDebt.of(
        LoggedWeighIn(weighIn: _weighIn, ekkloLink: _ekklo(69.4)),
      ),
    ).deepEquals([Connector.ekklo, Connector.mfp]);
    check(
      WeighInDebt.of(
        LoggedWeighIn(
          weighIn: _weighIn,
          ekkloLink: _ekklo(68.9),
          mfpLink: _mfp(68.9),
        ),
      ),
    ).isEmpty();
  });

  test('owes a deleted weigh-in to MyFitnessPal only while its link is '
      'live, never to Ekklo', () {
    final deleted = _weighIn.copyWith(deletedAt: now);

    check(
      WeighInDebt.of(
        LoggedWeighIn(
          weighIn: deleted,
          ekkloLink: _ekklo(68.9),
          mfpLink: _mfp(68.9),
        ),
      ),
    ).deepEquals([Connector.mfp]);
    check(
      WeighInDebt.of(LoggedWeighIn(weighIn: deleted, ekkloLink: _ekklo(68.9))),
    ).isEmpty();
  });
}
