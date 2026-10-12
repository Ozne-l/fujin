import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/unit_weight.dart';

enum EkkloSide {
  remembered,
  foundAutomatically,
  willBeCreated,
  toChoose,
  chosen;

  static EkkloSide of(PlannedEntry planned) => switch ((
    planned.choice,
    planned.confirmed,
  )) {
    (SendAsOwnCopy(reuse: null), _) => willBeCreated,
    (SendToEkkloFood(weight: UnitWeight.estimated), _) ||
    (SkipEntry(), _) => toChoose,
    (SendToEkkloFood() || SendAsOwnCopy(), true) => chosen,
    (SendToEkkloFood(remembered: true) || SendAsOwnCopy(), false) => remembered,
    (SendToEkkloFood(), false) => foundAutomatically,
  };
}
