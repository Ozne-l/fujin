import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/domain/sending/name_match.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fixtures.dart';

MfpEntryFood _food(String description, {String? brand}) =>
    entry(null, description: description, brand: brand).food;

void main() {
  group('productName', () {
    test('drops the brand written before the product', () {
      check(
        productName(_food('Isey - Skyr nature', brand: 'Isey')),
      ).equals('Skyr nature');
    });

    test('keeps a description whose prefix is not the brand', () {
      check(
        productName(_food('Danone - Skyr', brand: 'Isey')),
      ).equals('Danone - Skyr');
    });
  });

  group('searchTerms', () {
    test('drops stop words, short words and quantities', () {
      check(
        searchTerms(_food('Fromage blanc de vache 500g')),
      ).equals('fromage blanc vache');
      check(searchTerms(_food('Riz au lait'))).equals('riz lait');
    });

    test('keeps the first three meaningful words', () {
      check(
        searchTerms(_food('Pain complet aux graines tranché')),
      ).equals('pain complet graines');
    });

    test('searches the product name without the brand', () {
      check(
        searchTerms(_food('Isey - Skyr nature', brand: 'Isey')),
      ).equals('skyr');
    });
  });

  group('nameMatchOf', () {
    test('matches the product name across accents', () {
      check(
        nameMatchOf(
          ekkloFood('creme', name: 'Creme fraiche epaisse'),
          _food('Crème fraîche'),
        ),
      ).equals(NameMatch.product);
    });

    test('matches a word sharing a prefix of four letters', () {
      check(
        nameMatchOf(ekkloFood('tomate', name: 'Tomate'), _food('Tomates')),
      ).equals(NameMatch.product);
    });

    test('falls back to the brand', () {
      check(
        nameMatchOf(fromageBlanc, _food('Yaourt', brand: 'Danone')),
      ).equals(NameMatch.brand);
    });

    test('finds nothing in common', () {
      check(
        nameMatchOf(fromageBlanc, skyrEntry.food),
      ).equals(NameMatch.none);
    });
  });
}
