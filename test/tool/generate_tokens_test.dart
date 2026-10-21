import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;

import '../../tool/generate_tokens.dart';

const Map<String, Object> _sumi = {'hex': '#1B1A17', 'alpha': 1};
const Map<String, Object> _kinu = {'hex': '#FFFCF4', 'alpha': 1};

Map<String, Object?> _color(Object? value) => {
  r'$value': value,
  r'$type': 'color',
};

final Map<String, Object?> _light = {
  'color': {'sumi': _color(_sumi)},
  'role': {
    'text': {
      'primary': _color('{color.sumi}'),
      'onDark': _color(_kinu),
    },
  },
};

Map<String, Object?> _dark(Map<String, Object?> text) => {
  'role': {'text': text},
};

void main() {
  group('the token generator', () {
    test('resolves a light alias to its final colour', () {
      final source = generateTokens(
        light: _light,
        dark: _dark({'primary': _color(_kinu), 'onDark': _color(_sumi)}),
      );

      check(source)
        ..contains('textPrimary: Color(0xFF1B1A17)')
        ..contains('textPrimary: Color(0xFFFFFCF4)');
    });

    test('names a role the dark file lacks', () {
      check(
            () => generateTokens(
              light: _light,
              dark: _dark({'primary': _color(_kinu)}),
            ),
          )
          .throws<FormatException>()
          .has((error) => error.message, 'message')
          .contains('role/text/onDark');
    });

    test('names a role only the dark file has', () {
      check(
            () => generateTokens(
              light: _light,
              dark: _dark({
                'primary': _color(_kinu),
                'onDark': _color(_sumi),
                'extra': _color(_sumi),
              }),
            ),
          )
          .throws<FormatException>()
          .has((error) => error.message, 'message')
          .contains('role/text/extra');
    });

    test('refuses a dark role without a value', () {
      check(
            () => generateTokens(
              light: _light,
              dark: _dark({'primary': _color(null), 'onDark': _color(_sumi)}),
            ),
          )
          .throws<FormatException>()
          .has((error) => error.message, 'message')
          .contains('role/text/primary');
    });

    test('refuses a dark role whose value is not a colour', () {
      check(
            () => generateTokens(
              light: _light,
              dark: _dark({
                'primary': _color('{color.sumi}'),
                'onDark': _color(_sumi),
              }),
            ),
          )
          .throws<FormatException>()
          .has((error) => error.message, 'message')
          .contains('role/text/primary');
    });
  });
}
