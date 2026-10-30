// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'logged_entry.dart';

class LoggedEntryMapper extends ClassMapperBase<LoggedEntry> {
  LoggedEntryMapper._();

  static LoggedEntryMapper? _instance;
  static LoggedEntryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoggedEntryMapper._());
      EntryMapper.ensureInitialized();
      MfpLinkMapper.ensureInitialized();
      EkkloLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LoggedEntry';

  static Entry _$entry(LoggedEntry v) => v.entry;
  static const Field<LoggedEntry, Entry> _f$entry = Field('entry', _$entry);
  static String _$mealName(LoggedEntry v) => v.mealName;
  static const Field<LoggedEntry, String> _f$mealName = Field(
    'mealName',
    _$mealName,
    key: r'meal_name',
  );
  static String? _$foodName(LoggedEntry v) => v.foodName;
  static const Field<LoggedEntry, String> _f$foodName = Field(
    'foodName',
    _$foodName,
    key: r'food_name',
    opt: true,
  );
  static String? _$brand(LoggedEntry v) => v.brand;
  static const Field<LoggedEntry, String> _f$brand = Field(
    'brand',
    _$brand,
    opt: true,
  );
  static String? _$mfpFoodId(LoggedEntry v) => v.mfpFoodId;
  static const Field<LoggedEntry, String> _f$mfpFoodId = Field(
    'mfpFoodId',
    _$mfpFoodId,
    key: r'mfp_food_id',
    opt: true,
  );
  static MfpLink? _$mfpLink(LoggedEntry v) => v.mfpLink;
  static const Field<LoggedEntry, MfpLink> _f$mfpLink = Field(
    'mfpLink',
    _$mfpLink,
    key: r'mfp_link',
    opt: true,
  );
  static EkkloLink? _$ekkloLink(LoggedEntry v) => v.ekkloLink;
  static const Field<LoggedEntry, EkkloLink> _f$ekkloLink = Field(
    'ekkloLink',
    _$ekkloLink,
    key: r'ekklo_link',
    opt: true,
  );

  @override
  final MappableFields<LoggedEntry> fields = const {
    #entry: _f$entry,
    #mealName: _f$mealName,
    #foodName: _f$foodName,
    #brand: _f$brand,
    #mfpFoodId: _f$mfpFoodId,
    #mfpLink: _f$mfpLink,
    #ekkloLink: _f$ekkloLink,
  };
  @override
  final bool ignoreNull = true;

  static LoggedEntry _instantiate(DecodingData data) {
    return LoggedEntry(
      entry: data.dec(_f$entry),
      mealName: data.dec(_f$mealName),
      foodName: data.dec(_f$foodName),
      brand: data.dec(_f$brand),
      mfpFoodId: data.dec(_f$mfpFoodId),
      mfpLink: data.dec(_f$mfpLink),
      ekkloLink: data.dec(_f$ekkloLink),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LoggedEntry fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoggedEntry>(map);
  }

  static LoggedEntry fromJson(String json) {
    return ensureInitialized().decodeJson<LoggedEntry>(json);
  }
}

mixin LoggedEntryMappable {
  String toJson() {
    return LoggedEntryMapper.ensureInitialized().encodeJson<LoggedEntry>(
      this as LoggedEntry,
    );
  }

  Map<String, dynamic> toMap() {
    return LoggedEntryMapper.ensureInitialized().encodeMap<LoggedEntry>(
      this as LoggedEntry,
    );
  }

  LoggedEntryCopyWith<LoggedEntry, LoggedEntry, LoggedEntry> get copyWith =>
      _LoggedEntryCopyWithImpl<LoggedEntry, LoggedEntry>(
        this as LoggedEntry,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return LoggedEntryMapper.ensureInitialized().stringifyValue(
      this as LoggedEntry,
    );
  }

  @override
  bool operator ==(Object other) {
    return LoggedEntryMapper.ensureInitialized().equalsValue(
      this as LoggedEntry,
      other,
    );
  }

  @override
  int get hashCode {
    return LoggedEntryMapper.ensureInitialized().hashValue(this as LoggedEntry);
  }
}

extension LoggedEntryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoggedEntry, $Out> {
  LoggedEntryCopyWith<$R, LoggedEntry, $Out> get $asLoggedEntry =>
      $base.as((v, t, t2) => _LoggedEntryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LoggedEntryCopyWith<$R, $In extends LoggedEntry, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  EntryCopyWith<$R, Entry, Entry> get entry;
  MfpLinkCopyWith<$R, MfpLink, MfpLink>? get mfpLink;
  EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>? get ekkloLink;
  $R call({
    Entry? entry,
    String? mealName,
    String? foodName,
    String? brand,
    String? mfpFoodId,
    MfpLink? mfpLink,
    EkkloLink? ekkloLink,
  });
  LoggedEntryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LoggedEntryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoggedEntry, $Out>
    implements LoggedEntryCopyWith<$R, LoggedEntry, $Out> {
  _LoggedEntryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoggedEntry> $mapper =
      LoggedEntryMapper.ensureInitialized();
  @override
  EntryCopyWith<$R, Entry, Entry> get entry =>
      $value.entry.copyWith.$chain((v) => call(entry: v));
  @override
  MfpLinkCopyWith<$R, MfpLink, MfpLink>? get mfpLink =>
      $value.mfpLink?.copyWith.$chain((v) => call(mfpLink: v));
  @override
  EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>? get ekkloLink =>
      $value.ekkloLink?.copyWith.$chain((v) => call(ekkloLink: v));
  @override
  $R call({
    Entry? entry,
    String? mealName,
    Object? foodName = $none,
    Object? brand = $none,
    Object? mfpFoodId = $none,
    Object? mfpLink = $none,
    Object? ekkloLink = $none,
  }) => $apply(
    FieldCopyWithData({
      if (entry != null) #entry: entry,
      if (mealName != null) #mealName: mealName,
      if (foodName != $none) #foodName: foodName,
      if (brand != $none) #brand: brand,
      if (mfpFoodId != $none) #mfpFoodId: mfpFoodId,
      if (mfpLink != $none) #mfpLink: mfpLink,
      if (ekkloLink != $none) #ekkloLink: ekkloLink,
    }),
  );
  @override
  LoggedEntry $make(CopyWithData data) => LoggedEntry(
    entry: data.get(#entry, or: $value.entry),
    mealName: data.get(#mealName, or: $value.mealName),
    foodName: data.get(#foodName, or: $value.foodName),
    brand: data.get(#brand, or: $value.brand),
    mfpFoodId: data.get(#mfpFoodId, or: $value.mfpFoodId),
    mfpLink: data.get(#mfpLink, or: $value.mfpLink),
    ekkloLink: data.get(#ekkloLink, or: $value.ekkloLink),
  );

  @override
  LoggedEntryCopyWith<$R2, LoggedEntry, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LoggedEntryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

