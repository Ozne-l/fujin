const _ean13Length = 13;
const _upcALength = 12;
const _storeDigit = '2';
const _ean13StorePrefix = '0$_storeDigit';

bool isStoreCode(String barcode) => switch (barcode.length) {
  _ean13Length =>
    barcode.startsWith(_storeDigit) || barcode.startsWith(_ean13StorePrefix),
  _upcALength => barcode.startsWith(_storeDigit),
  _ => false,
};
