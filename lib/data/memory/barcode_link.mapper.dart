// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'barcode_link.dart';

class BarcodeLinkMapper extends ClassMapperBase<BarcodeLink> {
  BarcodeLinkMapper._();

  static BarcodeLinkMapper? _instance;
  static BarcodeLinkMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BarcodeLinkMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BarcodeLink';

  static String _$barcode(BarcodeLink v) => v.barcode;
  static const Field<BarcodeLink, String> _f$barcode = Field(
    'barcode',
    _$barcode,
  );
  static String _$mfpFoodId(BarcodeLink v) => v.mfpFoodId;
  static const Field<BarcodeLink, String> _f$mfpFoodId = Field(
    'mfpFoodId',
    _$mfpFoodId,
    key: r'mfp_food_id',
  );

  @override
  final MappableFields<BarcodeLink> fields = const {
    #barcode: _f$barcode,
    #mfpFoodId: _f$mfpFoodId,
  };
  @override
  final bool ignoreNull = true;

  static BarcodeLink _instantiate(DecodingData data) {
    return BarcodeLink(
      barcode: data.dec(_f$barcode),
      mfpFoodId: data.dec(_f$mfpFoodId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BarcodeLink fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BarcodeLink>(map);
  }

  static BarcodeLink fromJson(String json) {
    return ensureInitialized().decodeJson<BarcodeLink>(json);
  }
}

mixin BarcodeLinkMappable {
  String toJson() {
    return BarcodeLinkMapper.ensureInitialized().encodeJson<BarcodeLink>(
      this as BarcodeLink,
    );
  }

  Map<String, dynamic> toMap() {
    return BarcodeLinkMapper.ensureInitialized().encodeMap<BarcodeLink>(
      this as BarcodeLink,
    );
  }

  BarcodeLinkCopyWith<BarcodeLink, BarcodeLink, BarcodeLink> get copyWith =>
      _BarcodeLinkCopyWithImpl<BarcodeLink, BarcodeLink>(
        this as BarcodeLink,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BarcodeLinkMapper.ensureInitialized().stringifyValue(
      this as BarcodeLink,
    );
  }

  @override
  bool operator ==(Object other) {
    return BarcodeLinkMapper.ensureInitialized().equalsValue(
      this as BarcodeLink,
      other,
    );
  }

  @override
  int get hashCode {
    return BarcodeLinkMapper.ensureInitialized().hashValue(this as BarcodeLink);
  }
}

extension BarcodeLinkValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BarcodeLink, $Out> {
  BarcodeLinkCopyWith<$R, BarcodeLink, $Out> get $asBarcodeLink =>
      $base.as((v, t, t2) => _BarcodeLinkCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BarcodeLinkCopyWith<$R, $In extends BarcodeLink, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? barcode, String? mfpFoodId});
  BarcodeLinkCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BarcodeLinkCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BarcodeLink, $Out>
    implements BarcodeLinkCopyWith<$R, BarcodeLink, $Out> {
  _BarcodeLinkCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BarcodeLink> $mapper =
      BarcodeLinkMapper.ensureInitialized();
  @override
  $R call({String? barcode, String? mfpFoodId}) => $apply(
    FieldCopyWithData({
      if (barcode != null) #barcode: barcode,
      if (mfpFoodId != null) #mfpFoodId: mfpFoodId,
    }),
  );
  @override
  BarcodeLink $make(CopyWithData data) => BarcodeLink(
    barcode: data.get(#barcode, or: $value.barcode),
    mfpFoodId: data.get(#mfpFoodId, or: $value.mfpFoodId),
  );

  @override
  BarcodeLinkCopyWith<$R2, BarcodeLink, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BarcodeLinkCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

