import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/sending/name_match.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

const _brandSeparator = ' - ';
const _searchWords = 3;
const _minimumWordLength = 3;
const _minimumPrefixLength = 4;
final _wordBreak = RegExp(r'[^\p{L}\p{N}%]+', unicode: true);
final _quantityWord = RegExp(r'^[\d.,]+(kg|g|ml|cl|l|%)?$');
const _stopWords = {
  'de',
  'des',
  'du',
  'la',
  'le',
  'les',
  'un',
  'une',
  'et',
  'au',
  'aux',
  'en',
  'the',
  'and',
  'with',
  'generic',
  'bio',
  'nature',
  'natural',
  'original',
};
const _accents = {
  'à': 'a',
  'â': 'a',
  'ä': 'a',
  'é': 'e',
  'è': 'e',
  'ê': 'e',
  'ë': 'e',
  'î': 'i',
  'ï': 'i',
  'ô': 'o',
  'ö': 'o',
  'ù': 'u',
  'û': 'u',
  'ü': 'u',
  'ç': 'c',
};

String productName(MfpEntryFood food) {
  final description = food.description.trim();
  final separator = description.indexOf(_brandSeparator);
  return switch ((food.brandName?.trim().toLowerCase(), separator)) {
    (null, _) || (_, < 0) => description,
    (final brand?, _) => switch ((
      description.substring(0, separator).trim().toLowerCase() == brand,
      description.substring(separator + _brandSeparator.length).trim(),
    )) {
      (true, final product) when product.isNotEmpty => product,
      _ => description,
    },
  };
}

String searchTerms(MfpEntryFood food) =>
    _words(productName(food)).take(_searchWords).join(' ');

NameMatch nameMatchOf(EkkloFood candidate, MfpEntryFood food) {
  final candidateWords = [
    ..._words(candidate.name),
    ..._words(candidate.brands ?? ''),
  ].map(_normalize).toList();
  bool shares(String text) => _words(
    text,
  ).map(_normalize).any((word) => candidateWords.any((c) => _similar(word, c)));
  return switch ((shares(productName(food)), shares(food.brandName ?? ''))) {
    (true, _) => NameMatch.product,
    (false, true) => NameMatch.brand,
    (false, false) => NameMatch.none,
  };
}

List<String> _words(String text) => text
    .toLowerCase()
    .split(_wordBreak)
    .where(
      (word) =>
          word.length >= _minimumWordLength &&
          !_stopWords.contains(word) &&
          !_quantityWord.hasMatch(word),
    )
    .toList();

String _normalize(String word) =>
    word.split('').map((letter) => _accents[letter] ?? letter).join();

bool _similar(String a, String b) =>
    a == b ||
    (a.length >= _minimumPrefixLength &&
        b.length >= _minimumPrefixLength &&
        (a.startsWith(b) || b.startsWith(a)));
