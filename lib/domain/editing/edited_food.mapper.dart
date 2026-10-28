// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'edited_food.dart';

class EditedFoodMapper extends ClassMapperBase<EditedFood> {
  EditedFoodMapper._();

  static EditedFoodMapper? _instance;
  static EditedFoodMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EditedFoodMapper._());
      MfpFoodEntryMapper.ensureInitialized();
      PlannedEntryMapper.ensureInitialized();
      SentLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EditedFood';

  static String _$originalId(EditedFood v) => v.originalId;
  static const Field<EditedFood, String> _f$originalId = Field(
    'originalId',
    _$originalId,
    key: r'original_id',
  );
  static MfpFoodEntry _$original(EditedFood v) => v.original;
  static const Field<EditedFood, MfpFoodEntry> _f$original = Field(
    'original',
    _$original,
  );
  static PlannedEntry _$planned(EditedFood v) => v.planned;
  static const Field<EditedFood, PlannedEntry> _f$planned = Field(
    'planned',
    _$planned,
  );
  static bool _$ekkloWritten(EditedFood v) => v.ekkloWritten;
  static const Field<EditedFood, bool> _f$ekkloWritten = Field(
    'ekkloWritten',
    _$ekkloWritten,
    key: r'ekklo_written',
  );
  static SentLink? _$link(EditedFood v) => v.link;
  static const Field<EditedFood, SentLink> _f$link = Field(
    'link',
    _$link,
    opt: true,
  );

  @override
  final MappableFields<EditedFood> fields = const {
    #originalId: _f$originalId,
    #original: _f$original,
    #planned: _f$planned,
    #ekkloWritten: _f$ekkloWritten,
    #link: _f$link,
  };
  @override
  final bool ignoreNull = true;

  static EditedFood _instantiate(DecodingData data) {
    return EditedFood(
      originalId: data.dec(_f$originalId),
      original: data.dec(_f$original),
      planned: data.dec(_f$planned),
      ekkloWritten: data.dec(_f$ekkloWritten),
      link: data.dec(_f$link),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EditedFood fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EditedFood>(map);
  }

  static EditedFood fromJson(String json) {
    return ensureInitialized().decodeJson<EditedFood>(json);
  }
}

mixin EditedFoodMappable {
  String toJson() {
    return EditedFoodMapper.ensureInitialized().encodeJson<EditedFood>(
      this as EditedFood,
    );
  }

  Map<String, dynamic> toMap() {
    return EditedFoodMapper.ensureInitialized().encodeMap<EditedFood>(
      this as EditedFood,
    );
  }

  EditedFoodCopyWith<EditedFood, EditedFood, EditedFood> get copyWith =>
      _EditedFoodCopyWithImpl<EditedFood, EditedFood>(
        this as EditedFood,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EditedFoodMapper.ensureInitialized().stringifyValue(
      this as EditedFood,
    );
  }

  @override
  bool operator ==(Object other) {
    return EditedFoodMapper.ensureInitialized().equalsValue(
      this as EditedFood,
      other,
    );
  }

  @override
  int get hashCode {
    return EditedFoodMapper.ensureInitialized().hashValue(this as EditedFood);
  }
}

extension EditedFoodValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EditedFood, $Out> {
  EditedFoodCopyWith<$R, EditedFood, $Out> get $asEditedFood =>
      $base.as((v, t, t2) => _EditedFoodCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EditedFoodCopyWith<$R, $In extends EditedFood, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry> get original;
  PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry> get planned;
  SentLinkCopyWith<$R, SentLink, SentLink>? get link;
  $R call({
    String? originalId,
    MfpFoodEntry? original,
    PlannedEntry? planned,
    bool? ekkloWritten,
    SentLink? link,
  });
  EditedFoodCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EditedFoodCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EditedFood, $Out>
    implements EditedFoodCopyWith<$R, EditedFood, $Out> {
  _EditedFoodCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EditedFood> $mapper =
      EditedFoodMapper.ensureInitialized();
  @override
  MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry> get original =>
      $value.original.copyWith.$chain((v) => call(original: v));
  @override
  PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry> get planned =>
      $value.planned.copyWith.$chain((v) => call(planned: v));
  @override
  SentLinkCopyWith<$R, SentLink, SentLink>? get link =>
      $value.link?.copyWith.$chain((v) => call(link: v));
  @override
  $R call({
    String? originalId,
    MfpFoodEntry? original,
    PlannedEntry? planned,
    bool? ekkloWritten,
    Object? link = $none,
  }) => $apply(
    FieldCopyWithData({
      if (originalId != null) #originalId: originalId,
      if (original != null) #original: original,
      if (planned != null) #planned: planned,
      if (ekkloWritten != null) #ekkloWritten: ekkloWritten,
      if (link != $none) #link: link,
    }),
  );
  @override
  EditedFood $make(CopyWithData data) => EditedFood(
    originalId: data.get(#originalId, or: $value.originalId),
    original: data.get(#original, or: $value.original),
    planned: data.get(#planned, or: $value.planned),
    ekkloWritten: data.get(#ekkloWritten, or: $value.ekkloWritten),
    link: data.get(#link, or: $value.link),
  );

  @override
  EditedFoodCopyWith<$R2, EditedFood, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EditedFoodCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

