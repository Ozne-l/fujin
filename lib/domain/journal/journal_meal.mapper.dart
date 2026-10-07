// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'journal_meal.dart';

class JournalMealMapper extends ClassMapperBase<JournalMeal> {
  JournalMealMapper._();

  static JournalMealMapper? _instance;
  static JournalMealMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = JournalMealMapper._());
      ComparedEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'JournalMeal';

  static String _$name(JournalMeal v) => v.name;
  static const Field<JournalMeal, String> _f$name = Field('name', _$name);
  static List<ComparedEntry> _$entries(JournalMeal v) => v.entries;
  static const Field<JournalMeal, List<ComparedEntry>> _f$entries = Field(
    'entries',
    _$entries,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<JournalMeal> fields = const {
    #name: _f$name,
    #entries: _f$entries,
  };
  @override
  final bool ignoreNull = true;

  static JournalMeal _instantiate(DecodingData data) {
    return JournalMeal(name: data.dec(_f$name), entries: data.dec(_f$entries));
  }

  @override
  final Function instantiate = _instantiate;

  static JournalMeal fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JournalMeal>(map);
  }

  static JournalMeal fromJson(String json) {
    return ensureInitialized().decodeJson<JournalMeal>(json);
  }
}

mixin JournalMealMappable {
  String toJson() {
    return JournalMealMapper.ensureInitialized().encodeJson<JournalMeal>(
      this as JournalMeal,
    );
  }

  Map<String, dynamic> toMap() {
    return JournalMealMapper.ensureInitialized().encodeMap<JournalMeal>(
      this as JournalMeal,
    );
  }

  JournalMealCopyWith<JournalMeal, JournalMeal, JournalMeal> get copyWith =>
      _JournalMealCopyWithImpl<JournalMeal, JournalMeal>(
        this as JournalMeal,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return JournalMealMapper.ensureInitialized().stringifyValue(
      this as JournalMeal,
    );
  }

  @override
  bool operator ==(Object other) {
    return JournalMealMapper.ensureInitialized().equalsValue(
      this as JournalMeal,
      other,
    );
  }

  @override
  int get hashCode {
    return JournalMealMapper.ensureInitialized().hashValue(this as JournalMeal);
  }
}

extension JournalMealValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JournalMeal, $Out> {
  JournalMealCopyWith<$R, JournalMeal, $Out> get $asJournalMeal =>
      $base.as((v, t, t2) => _JournalMealCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class JournalMealCopyWith<$R, $In extends JournalMeal, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    ComparedEntry,
    ComparedEntryCopyWith<$R, ComparedEntry, ComparedEntry>
  >
  get entries;
  $R call({String? name, List<ComparedEntry>? entries});
  JournalMealCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _JournalMealCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JournalMeal, $Out>
    implements JournalMealCopyWith<$R, JournalMeal, $Out> {
  _JournalMealCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<JournalMeal> $mapper =
      JournalMealMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ComparedEntry,
    ComparedEntryCopyWith<$R, ComparedEntry, ComparedEntry>
  >
  get entries => ListCopyWith(
    $value.entries,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(entries: v),
  );
  @override
  $R call({String? name, List<ComparedEntry>? entries}) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (entries != null) #entries: entries,
    }),
  );
  @override
  JournalMeal $make(CopyWithData data) => JournalMeal(
    name: data.get(#name, or: $value.name),
    entries: data.get(#entries, or: $value.entries),
  );

  @override
  JournalMealCopyWith<$R2, JournalMeal, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _JournalMealCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

