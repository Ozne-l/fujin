import 'package:ekklo_client/ekklo_client.dart';

String? personName(EkkloPerson? person) => switch (person) {
  EkkloPerson(fullName: final name?) => name,
  EkkloPerson(:final firstName, :final lastName) => switch ([
    ?firstName,
    ?lastName,
  ].join(' ')) {
    '' => null,
    final name => name,
  },
  null => null,
};
