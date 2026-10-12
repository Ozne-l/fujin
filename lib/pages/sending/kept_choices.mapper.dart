// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'kept_choices.dart';

class KeptChoicesMapper extends ClassMapperBase<KeptChoices> {
  KeptChoicesMapper._();

  static KeptChoicesMapper? _instance;
  static KeptChoicesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = KeptChoicesMapper._());
      PlannedEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'KeptChoices';

  static Map<String, PlannedEntry> _$kept(KeptChoices v) => v.kept;
  static const Field<KeptChoices, Map<String, PlannedEntry>> _f$kept = Field(
    'kept',
    _$kept,
    opt: true,
    def: const {},
  );
  static Set<String> _$keeping(KeptChoices v) => v.keeping;
  static const Field<KeptChoices, Set<String>> _f$keeping = Field(
    'keeping',
    _$keeping,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<KeptChoices> fields = const {
    #kept: _f$kept,
    #keeping: _f$keeping,
  };
  @override
  final bool ignoreNull = true;

  static KeptChoices _instantiate(DecodingData data) {
    return KeptChoices(kept: data.dec(_f$kept), keeping: data.dec(_f$keeping));
  }

  @override
  final Function instantiate = _instantiate;

  static KeptChoices fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<KeptChoices>(map);
  }

  static KeptChoices fromJson(String json) {
    return ensureInitialized().decodeJson<KeptChoices>(json);
  }
}

mixin KeptChoicesMappable {
  String toJson() {
    return KeptChoicesMapper.ensureInitialized().encodeJson<KeptChoices>(
      this as KeptChoices,
    );
  }

  Map<String, dynamic> toMap() {
    return KeptChoicesMapper.ensureInitialized().encodeMap<KeptChoices>(
      this as KeptChoices,
    );
  }

  KeptChoicesCopyWith<KeptChoices, KeptChoices, KeptChoices> get copyWith =>
      _KeptChoicesCopyWithImpl<KeptChoices, KeptChoices>(
        this as KeptChoices,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return KeptChoicesMapper.ensureInitialized().stringifyValue(
      this as KeptChoices,
    );
  }

  @override
  bool operator ==(Object other) {
    return KeptChoicesMapper.ensureInitialized().equalsValue(
      this as KeptChoices,
      other,
    );
  }

  @override
  int get hashCode {
    return KeptChoicesMapper.ensureInitialized().hashValue(this as KeptChoices);
  }
}

extension KeptChoicesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, KeptChoices, $Out> {
  KeptChoicesCopyWith<$R, KeptChoices, $Out> get $asKeptChoices =>
      $base.as((v, t, t2) => _KeptChoicesCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class KeptChoicesCopyWith<$R, $In extends KeptChoices, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<
    $R,
    String,
    PlannedEntry,
    PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry>
  >
  get kept;
  $R call({Map<String, PlannedEntry>? kept, Set<String>? keeping});
  KeptChoicesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _KeptChoicesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, KeptChoices, $Out>
    implements KeptChoicesCopyWith<$R, KeptChoices, $Out> {
  _KeptChoicesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<KeptChoices> $mapper =
      KeptChoicesMapper.ensureInitialized();
  @override
  MapCopyWith<
    $R,
    String,
    PlannedEntry,
    PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry>
  >
  get kept => MapCopyWith(
    $value.kept,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(kept: v),
  );
  @override
  $R call({Map<String, PlannedEntry>? kept, Set<String>? keeping}) => $apply(
    FieldCopyWithData({
      if (kept != null) #kept: kept,
      if (keeping != null) #keeping: keeping,
    }),
  );
  @override
  KeptChoices $make(CopyWithData data) => KeptChoices(
    kept: data.get(#kept, or: $value.kept),
    keeping: data.get(#keeping, or: $value.keeping),
  );

  @override
  KeptChoicesCopyWith<$R2, KeptChoices, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _KeptChoicesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

