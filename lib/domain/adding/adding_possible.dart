import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/read_problem.dart';

bool addingPossible({JournalRead? read, Object? error}) =>
    switch ((error, read)) {
      (final error?, _) => _allows(ReadProblem.of(error)),
      (null, MfpOnly(:final ekkloProblem)) => _allows(ekkloProblem),
      (null, EkkloOnly(:final mfpProblem)) => _allows(mfpProblem),
      (null, BothSides() || null) => true,
    };

bool _allows(ReadProblem problem) => switch (problem) {
  ReadProblem.offline ||
  ReadProblem.mfpSessionExpired ||
  ReadProblem.ekkloSessionExpired => false,
  ReadProblem.mfpUnavailable ||
  ReadProblem.ekkloUnavailable ||
  ReadProblem.unknown => true,
};
