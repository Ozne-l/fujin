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
      LoggedEntryMapper.ensureInitialized();
      AddDraftMapper.ensureInitialized();
      PlannedEntryMapper.ensureInitialized();
      EkkloLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EditedFood';

  static LoggedEntry _$original(EditedFood v) => v.original;
  static const Field<EditedFood, LoggedEntry> _f$original = Field(
    'original',
    _$original,
  );
  static AddDraft _$draft(EditedFood v) => v.draft;
  static const Field<EditedFood, AddDraft> _f$draft = Field('draft', _$draft);
  static PlannedEntry _$planned(EditedFood v) => v.planned;
  static const Field<EditedFood, PlannedEntry> _f$planned = Field(
    'planned',
    _$planned,
  );
  static EkkloLink? _$link(EditedFood v) => v.link;
  static const Field<EditedFood, EkkloLink> _f$link = Field(
    'link',
    _$link,
    opt: true,
  );

  @override
  final MappableFields<EditedFood> fields = const {
    #original: _f$original,
    #draft: _f$draft,
    #planned: _f$planned,
    #link: _f$link,
  };
  @override
  final bool ignoreNull = true;

  static EditedFood _instantiate(DecodingData data) {
    return EditedFood(
      original: data.dec(_f$original),
      draft: data.dec(_f$draft),
      planned: data.dec(_f$planned),
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
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get original;
  AddDraftCopyWith<$R, AddDraft, AddDraft> get draft;
  PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry> get planned;
  EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>? get link;
  $R call({
    LoggedEntry? original,
    AddDraft? draft,
    PlannedEntry? planned,
    EkkloLink? link,
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
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get original =>
      $value.original.copyWith.$chain((v) => call(original: v));
  @override
  AddDraftCopyWith<$R, AddDraft, AddDraft> get draft =>
      $value.draft.copyWith.$chain((v) => call(draft: v));
  @override
  PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry> get planned =>
      $value.planned.copyWith.$chain((v) => call(planned: v));
  @override
  EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>? get link =>
      $value.link?.copyWith.$chain((v) => call(link: v));
  @override
  $R call({
    LoggedEntry? original,
    AddDraft? draft,
    PlannedEntry? planned,
    Object? link = $none,
  }) => $apply(
    FieldCopyWithData({
      if (original != null) #original: original,
      if (draft != null) #draft: draft,
      if (planned != null) #planned: planned,
      if (link != $none) #link: link,
    }),
  );
  @override
  EditedFood $make(CopyWithData data) => EditedFood(
    original: data.get(#original, or: $value.original),
    draft: data.get(#draft, or: $value.draft),
    planned: data.get(#planned, or: $value.planned),
    link: data.get(#link, or: $value.link),
  );

  @override
  EditedFoodCopyWith<$R2, EditedFood, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EditedFoodCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

