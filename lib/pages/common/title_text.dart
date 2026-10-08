import 'package:flutter/widgets.dart';

abstract final class TitleText {
  static String capitalized(String text) => switch (text) {
    '' => text,
    _ => '${text.characters.first.toUpperCase()}${text.characters.skip(1)}',
  };
}
