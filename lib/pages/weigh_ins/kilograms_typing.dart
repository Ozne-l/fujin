import 'package:fujin/domain/weighing/kilograms.dart';

final class KilogramsTyping {
  const KilogramsTyping({required this.separator, this.text = ''});

  KilogramsTyping.of(double kilograms, {required String separator})
    : this(
        separator: separator,
        text: kilograms
            .toStringAsFixed(_decimals)
            .replaceFirst(_pointSeparator, separator),
      );

  static const _wholeDigits = 3;
  static const _decimals = 1;
  static const _pointSeparator = '.';
  static const _zero = '0';

  final String separator;
  final String text;

  KilogramsTyping pressed(int digit) => switch (text.split(separator)) {
    [final whole] when whole.length >= _wholeDigits => this,
    [_, final decimals] when decimals.length >= _decimals => this,
    _ => _typed('$text$digit'),
  };

  KilogramsTyping separated() => switch ((text.contains(separator), text)) {
    (true, _) => this,
    (false, '') => _typed('$_zero$separator'),
    (false, _) => _typed('$text$separator'),
  };

  KilogramsTyping erased() => switch (text) {
    '' => this,
    _ => _typed(text.substring(0, text.length - 1)),
  };

  double? get kilograms => switch (double.tryParse(
    text.replaceFirst(separator, _pointSeparator),
  )) {
    final kilograms? when Kilograms.plausible(kilograms) => kilograms,
    _ => null,
  };

  bool get outOfRange => text.isNotEmpty && kilograms == null && !_growing;

  bool get _growing =>
      !text.contains(separator) &&
      text.length < _wholeDigits &&
      !text.startsWith(_zero);

  KilogramsTyping _typed(String typed) =>
      KilogramsTyping(separator: separator, text: typed);
}
