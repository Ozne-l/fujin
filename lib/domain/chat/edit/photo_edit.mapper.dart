// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'photo_edit.dart';

class PhotoEditMapper extends ClassMapperBase<PhotoEdit> {
  PhotoEditMapper._();

  static PhotoEditMapper? _instance;
  static PhotoEditMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhotoEditMapper._());
      CropAspectMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhotoEdit';

  static Rect? _$crop(PhotoEdit v) => v.crop;
  static const Field<PhotoEdit, Rect> _f$crop = Field(
    'crop',
    _$crop,
    opt: true,
    hook: RectHook(),
  );
  static CropAspect _$aspect(PhotoEdit v) => v.aspect;
  static const Field<PhotoEdit, CropAspect> _f$aspect = Field(
    'aspect',
    _$aspect,
    opt: true,
    def: CropAspect.free,
  );
  static int _$quarterTurns(PhotoEdit v) => v.quarterTurns;
  static const Field<PhotoEdit, int> _f$quarterTurns = Field(
    'quarterTurns',
    _$quarterTurns,
    key: r'quarter_turns',
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<PhotoEdit> fields = const {
    #crop: _f$crop,
    #aspect: _f$aspect,
    #quarterTurns: _f$quarterTurns,
  };
  @override
  final bool ignoreNull = true;

  static PhotoEdit _instantiate(DecodingData data) {
    return PhotoEdit(
      crop: data.dec(_f$crop),
      aspect: data.dec(_f$aspect),
      quarterTurns: data.dec(_f$quarterTurns),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhotoEdit fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhotoEdit>(map);
  }

  static PhotoEdit fromJson(String json) {
    return ensureInitialized().decodeJson<PhotoEdit>(json);
  }
}

mixin PhotoEditMappable {
  String toJson() {
    return PhotoEditMapper.ensureInitialized().encodeJson<PhotoEdit>(
      this as PhotoEdit,
    );
  }

  Map<String, dynamic> toMap() {
    return PhotoEditMapper.ensureInitialized().encodeMap<PhotoEdit>(
      this as PhotoEdit,
    );
  }

  PhotoEditCopyWith<PhotoEdit, PhotoEdit, PhotoEdit> get copyWith =>
      _PhotoEditCopyWithImpl<PhotoEdit, PhotoEdit>(
        this as PhotoEdit,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PhotoEditMapper.ensureInitialized().stringifyValue(
      this as PhotoEdit,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhotoEditMapper.ensureInitialized().equalsValue(
      this as PhotoEdit,
      other,
    );
  }

  @override
  int get hashCode {
    return PhotoEditMapper.ensureInitialized().hashValue(this as PhotoEdit);
  }
}

extension PhotoEditValueCopy<$R, $Out> on ObjectCopyWith<$R, PhotoEdit, $Out> {
  PhotoEditCopyWith<$R, PhotoEdit, $Out> get $asPhotoEdit =>
      $base.as((v, t, t2) => _PhotoEditCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PhotoEditCopyWith<$R, $In extends PhotoEdit, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Rect? crop, CropAspect? aspect, int? quarterTurns});
  PhotoEditCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PhotoEditCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhotoEdit, $Out>
    implements PhotoEditCopyWith<$R, PhotoEdit, $Out> {
  _PhotoEditCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhotoEdit> $mapper =
      PhotoEditMapper.ensureInitialized();
  @override
  $R call({Object? crop = $none, CropAspect? aspect, int? quarterTurns}) =>
      $apply(
        FieldCopyWithData({
          if (crop != $none) #crop: crop,
          if (aspect != null) #aspect: aspect,
          if (quarterTurns != null) #quarterTurns: quarterTurns,
        }),
      );
  @override
  PhotoEdit $make(CopyWithData data) => PhotoEdit(
    crop: data.get(#crop, or: $value.crop),
    aspect: data.get(#aspect, or: $value.aspect),
    quarterTurns: data.get(#quarterTurns, or: $value.quarterTurns),
  );

  @override
  PhotoEditCopyWith<$R2, PhotoEdit, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhotoEditCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

