// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'kept_passage.dart';

class KeptPassageMapper extends ClassMapperBase<KeptPassage> {
  KeptPassageMapper._();

  static KeptPassageMapper? _instance;
  static KeptPassageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = KeptPassageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'KeptPassage';

  static Duration _$start(KeptPassage v) => v.start;
  static const Field<KeptPassage, Duration> _f$start = Field(
    'start',
    _$start,
    key: r'start_ms',
    hook: MillisecondsHook(),
  );
  static Duration _$end(KeptPassage v) => v.end;
  static const Field<KeptPassage, Duration> _f$end = Field(
    'end',
    _$end,
    key: r'end_ms',
    hook: MillisecondsHook(),
  );

  @override
  final MappableFields<KeptPassage> fields = const {
    #start: _f$start,
    #end: _f$end,
  };
  @override
  final bool ignoreNull = true;

  static KeptPassage _instantiate(DecodingData data) {
    return KeptPassage(start: data.dec(_f$start), end: data.dec(_f$end));
  }

  @override
  final Function instantiate = _instantiate;

  static KeptPassage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<KeptPassage>(map);
  }

  static KeptPassage fromJson(String json) {
    return ensureInitialized().decodeJson<KeptPassage>(json);
  }
}

mixin KeptPassageMappable {
  String toJson() {
    return KeptPassageMapper.ensureInitialized().encodeJson<KeptPassage>(
      this as KeptPassage,
    );
  }

  Map<String, dynamic> toMap() {
    return KeptPassageMapper.ensureInitialized().encodeMap<KeptPassage>(
      this as KeptPassage,
    );
  }

  KeptPassageCopyWith<KeptPassage, KeptPassage, KeptPassage> get copyWith =>
      _KeptPassageCopyWithImpl<KeptPassage, KeptPassage>(
        this as KeptPassage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return KeptPassageMapper.ensureInitialized().stringifyValue(
      this as KeptPassage,
    );
  }

  @override
  bool operator ==(Object other) {
    return KeptPassageMapper.ensureInitialized().equalsValue(
      this as KeptPassage,
      other,
    );
  }

  @override
  int get hashCode {
    return KeptPassageMapper.ensureInitialized().hashValue(this as KeptPassage);
  }
}

extension KeptPassageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, KeptPassage, $Out> {
  KeptPassageCopyWith<$R, KeptPassage, $Out> get $asKeptPassage =>
      $base.as((v, t, t2) => _KeptPassageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class KeptPassageCopyWith<$R, $In extends KeptPassage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Duration? start, Duration? end});
  KeptPassageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _KeptPassageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, KeptPassage, $Out>
    implements KeptPassageCopyWith<$R, KeptPassage, $Out> {
  _KeptPassageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<KeptPassage> $mapper =
      KeptPassageMapper.ensureInitialized();
  @override
  $R call({Duration? start, Duration? end}) => $apply(
    FieldCopyWithData({
      if (start != null) #start: start,
      if (end != null) #end: end,
    }),
  );
  @override
  KeptPassage $make(CopyWithData data) => KeptPassage(
    start: data.get(#start, or: $value.start),
    end: data.get(#end, or: $value.end),
  );

  @override
  KeptPassageCopyWith<$R2, KeptPassage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _KeptPassageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

