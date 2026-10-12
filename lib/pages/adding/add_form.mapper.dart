// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'add_form.dart';

class AddFormMapper extends ClassMapperBase<AddForm> {
  AddFormMapper._();

  static AddFormMapper? _instance;
  static AddFormMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddFormMapper._());
      AddDraftMapper.ensureInitialized();
      PlannedEntryMapper.ensureInitialized();
      ReadProblemMapper.ensureInitialized();
      MfpFoodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddForm';

  static AddDraft _$draft(AddForm v) => v.draft;
  static const Field<AddForm, AddDraft> _f$draft = Field('draft', _$draft);
  static PlannedEntry? _$planned(AddForm v) => v.planned;
  static const Field<AddForm, PlannedEntry> _f$planned = Field(
    'planned',
    _$planned,
    opt: true,
  );
  static ReadProblem? _$planProblem(AddForm v) => v.planProblem;
  static const Field<AddForm, ReadProblem> _f$planProblem = Field(
    'planProblem',
    _$planProblem,
    key: r'plan_problem',
    opt: true,
  );
  static MfpFood? _$changedFrom(AddForm v) => v.changedFrom;
  static const Field<AddForm, MfpFood> _f$changedFrom = Field(
    'changedFrom',
    _$changedFrom,
    key: r'changed_from',
    opt: true,
  );

  @override
  final MappableFields<AddForm> fields = const {
    #draft: _f$draft,
    #planned: _f$planned,
    #planProblem: _f$planProblem,
    #changedFrom: _f$changedFrom,
  };
  @override
  final bool ignoreNull = true;

  static AddForm _instantiate(DecodingData data) {
    return AddForm(
      draft: data.dec(_f$draft),
      planned: data.dec(_f$planned),
      planProblem: data.dec(_f$planProblem),
      changedFrom: data.dec(_f$changedFrom),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddForm fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddForm>(map);
  }

  static AddForm fromJson(String json) {
    return ensureInitialized().decodeJson<AddForm>(json);
  }
}

mixin AddFormMappable {
  String toJson() {
    return AddFormMapper.ensureInitialized().encodeJson<AddForm>(
      this as AddForm,
    );
  }

  Map<String, dynamic> toMap() {
    return AddFormMapper.ensureInitialized().encodeMap<AddForm>(
      this as AddForm,
    );
  }

  AddFormCopyWith<AddForm, AddForm, AddForm> get copyWith =>
      _AddFormCopyWithImpl<AddForm, AddForm>(
        this as AddForm,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddFormMapper.ensureInitialized().stringifyValue(this as AddForm);
  }

  @override
  bool operator ==(Object other) {
    return AddFormMapper.ensureInitialized().equalsValue(
      this as AddForm,
      other,
    );
  }

  @override
  int get hashCode {
    return AddFormMapper.ensureInitialized().hashValue(this as AddForm);
  }
}

extension AddFormValueCopy<$R, $Out> on ObjectCopyWith<$R, AddForm, $Out> {
  AddFormCopyWith<$R, AddForm, $Out> get $asAddForm =>
      $base.as((v, t, t2) => _AddFormCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddFormCopyWith<$R, $In extends AddForm, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  AddDraftCopyWith<$R, AddDraft, AddDraft> get draft;
  PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry>? get planned;
  MfpFoodCopyWith<$R, MfpFood, MfpFood>? get changedFrom;
  $R call({
    AddDraft? draft,
    PlannedEntry? planned,
    ReadProblem? planProblem,
    MfpFood? changedFrom,
  });
  AddFormCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AddFormCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddForm, $Out>
    implements AddFormCopyWith<$R, AddForm, $Out> {
  _AddFormCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddForm> $mapper =
      AddFormMapper.ensureInitialized();
  @override
  AddDraftCopyWith<$R, AddDraft, AddDraft> get draft =>
      $value.draft.copyWith.$chain((v) => call(draft: v));
  @override
  PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry>? get planned =>
      $value.planned?.copyWith.$chain((v) => call(planned: v));
  @override
  MfpFoodCopyWith<$R, MfpFood, MfpFood>? get changedFrom =>
      $value.changedFrom?.copyWith.$chain((v) => call(changedFrom: v));
  @override
  $R call({
    AddDraft? draft,
    Object? planned = $none,
    Object? planProblem = $none,
    Object? changedFrom = $none,
  }) => $apply(
    FieldCopyWithData({
      if (draft != null) #draft: draft,
      if (planned != $none) #planned: planned,
      if (planProblem != $none) #planProblem: planProblem,
      if (changedFrom != $none) #changedFrom: changedFrom,
    }),
  );
  @override
  AddForm $make(CopyWithData data) => AddForm(
    draft: data.get(#draft, or: $value.draft),
    planned: data.get(#planned, or: $value.planned),
    planProblem: data.get(#planProblem, or: $value.planProblem),
    changedFrom: data.get(#changedFrom, or: $value.changedFrom),
  );

  @override
  AddFormCopyWith<$R2, AddForm, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AddFormCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

