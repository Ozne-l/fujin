final _gramUnit = RegExp(r'^g(r|ram|ramm|ramme)?(s|\(s\))?$');

bool isGramUnit(String unit) => _gramUnit.hasMatch(unit.toLowerCase().trim());
