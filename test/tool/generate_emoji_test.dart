import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show test;

import '../../tool/generate_emoji.dart';

const _emojiTest = '''
# emoji-test.txt
# group: Smileys & Emotion
# subgroup: face-smiling
1F600                                      ; fully-qualified     # 😀 E1.0 grinning face
263A FE0F                                  ; fully-qualified     # ☺️ E0.6 smiling face
263A                                       ; unqualified         # ☺ E0.6 smiling face
# group: People & Body
1F44B                                      ; fully-qualified     # 👋 E0.6 waving hand
1F44B 1F3FB                                ; fully-qualified     # 👋🏻 E1.0 waving hand: light skin tone
# group: Component
1F3FB                                      ; component           # 🏻 E1.0 light skin tone
1F9B0                                      ; fully-qualified     # 🦰 E11.0 red hair
# group: Flags
1F1EB 1F1F7                                ; fully-qualified     # 🇫🇷 E2.0 flag: France
''';

void main() {
  test('keeps fully-qualified emoji without skin tones, by group', () {
    final generated = generateEmoji(_emojiTest);

    check(generated).contains(
      "[\n      '😀',\n      '☺️',\n    ],\n"
      "    [\n      '👋',\n    ],\n"
      "    [\n      '🇫🇷',\n    ],\n",
    );
    check(generated).not((it) => it.contains('👋🏻'));
    check(generated).not((it) => it.contains('🦰'));
    check(generated).not((it) => it.contains("'☺'"));
  });
}
