// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tab_slot.dart';

class TabSlotMapper extends ClassMapperBase<TabSlot> {
  TabSlotMapper._();

  static TabSlotMapper? _instance;
  static TabSlotMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TabSlotMapper._());
      BranchSlotMapper.ensureInitialized();
      MessagesSlotMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TabSlot';

  @override
  final MappableFields<TabSlot> fields = const {};
  @override
  final bool ignoreNull = true;

  static TabSlot _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'TabSlot',
      'slot',
      '${data.value['slot']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TabSlot fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TabSlot>(map);
  }

  static TabSlot fromJson(String json) {
    return ensureInitialized().decodeJson<TabSlot>(json);
  }
}

mixin TabSlotMappable {
  String toJson();
  Map<String, dynamic> toMap();
  TabSlotCopyWith<TabSlot, TabSlot, TabSlot> get copyWith;
}

abstract class TabSlotCopyWith<$R, $In extends TabSlot, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  TabSlotCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class BranchSlotMapper extends SubClassMapperBase<BranchSlot> {
  BranchSlotMapper._();

  static BranchSlotMapper? _instance;
  static BranchSlotMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BranchSlotMapper._());
      TabSlotMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'BranchSlot';

  static FujinTab _$tab(BranchSlot v) => v.tab;
  static const Field<BranchSlot, FujinTab> _f$tab = Field('tab', _$tab);

  @override
  final MappableFields<BranchSlot> fields = const {#tab: _f$tab};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'slot';
  @override
  final dynamic discriminatorValue = 'branch';
  @override
  late final ClassMapperBase superMapper = TabSlotMapper.ensureInitialized();

  static BranchSlot _instantiate(DecodingData data) {
    return BranchSlot(data.dec(_f$tab));
  }

  @override
  final Function instantiate = _instantiate;

  static BranchSlot fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BranchSlot>(map);
  }

  static BranchSlot fromJson(String json) {
    return ensureInitialized().decodeJson<BranchSlot>(json);
  }
}

mixin BranchSlotMappable {
  String toJson() {
    return BranchSlotMapper.ensureInitialized().encodeJson<BranchSlot>(
      this as BranchSlot,
    );
  }

  Map<String, dynamic> toMap() {
    return BranchSlotMapper.ensureInitialized().encodeMap<BranchSlot>(
      this as BranchSlot,
    );
  }

  BranchSlotCopyWith<BranchSlot, BranchSlot, BranchSlot> get copyWith =>
      _BranchSlotCopyWithImpl<BranchSlot, BranchSlot>(
        this as BranchSlot,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BranchSlotMapper.ensureInitialized().stringifyValue(
      this as BranchSlot,
    );
  }

  @override
  bool operator ==(Object other) {
    return BranchSlotMapper.ensureInitialized().equalsValue(
      this as BranchSlot,
      other,
    );
  }

  @override
  int get hashCode {
    return BranchSlotMapper.ensureInitialized().hashValue(this as BranchSlot);
  }
}

extension BranchSlotValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BranchSlot, $Out> {
  BranchSlotCopyWith<$R, BranchSlot, $Out> get $asBranchSlot =>
      $base.as((v, t, t2) => _BranchSlotCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BranchSlotCopyWith<$R, $In extends BranchSlot, $Out>
    implements TabSlotCopyWith<$R, $In, $Out> {
  @override
  $R call({FujinTab? tab});
  BranchSlotCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BranchSlotCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BranchSlot, $Out>
    implements BranchSlotCopyWith<$R, BranchSlot, $Out> {
  _BranchSlotCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BranchSlot> $mapper =
      BranchSlotMapper.ensureInitialized();
  @override
  $R call({FujinTab? tab}) =>
      $apply(FieldCopyWithData({if (tab != null) #tab: tab}));
  @override
  BranchSlot $make(CopyWithData data) =>
      BranchSlot(data.get(#tab, or: $value.tab));

  @override
  BranchSlotCopyWith<$R2, BranchSlot, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BranchSlotCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessagesSlotMapper extends SubClassMapperBase<MessagesSlot> {
  MessagesSlotMapper._();

  static MessagesSlotMapper? _instance;
  static MessagesSlotMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessagesSlotMapper._());
      TabSlotMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MessagesSlot';

  static MessagesItem _$item(MessagesSlot v) => v.item;
  static const Field<MessagesSlot, MessagesItem> _f$item = Field(
    'item',
    _$item,
  );

  @override
  final MappableFields<MessagesSlot> fields = const {#item: _f$item};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'slot';
  @override
  final dynamic discriminatorValue = 'messages';
  @override
  late final ClassMapperBase superMapper = TabSlotMapper.ensureInitialized();

  static MessagesSlot _instantiate(DecodingData data) {
    return MessagesSlot(data.dec(_f$item));
  }

  @override
  final Function instantiate = _instantiate;

  static MessagesSlot fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessagesSlot>(map);
  }

  static MessagesSlot fromJson(String json) {
    return ensureInitialized().decodeJson<MessagesSlot>(json);
  }
}

mixin MessagesSlotMappable {
  String toJson() {
    return MessagesSlotMapper.ensureInitialized().encodeJson<MessagesSlot>(
      this as MessagesSlot,
    );
  }

  Map<String, dynamic> toMap() {
    return MessagesSlotMapper.ensureInitialized().encodeMap<MessagesSlot>(
      this as MessagesSlot,
    );
  }

  MessagesSlotCopyWith<MessagesSlot, MessagesSlot, MessagesSlot> get copyWith =>
      _MessagesSlotCopyWithImpl<MessagesSlot, MessagesSlot>(
        this as MessagesSlot,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessagesSlotMapper.ensureInitialized().stringifyValue(
      this as MessagesSlot,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessagesSlotMapper.ensureInitialized().equalsValue(
      this as MessagesSlot,
      other,
    );
  }

  @override
  int get hashCode {
    return MessagesSlotMapper.ensureInitialized().hashValue(
      this as MessagesSlot,
    );
  }
}

extension MessagesSlotValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessagesSlot, $Out> {
  MessagesSlotCopyWith<$R, MessagesSlot, $Out> get $asMessagesSlot =>
      $base.as((v, t, t2) => _MessagesSlotCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessagesSlotCopyWith<$R, $In extends MessagesSlot, $Out>
    implements TabSlotCopyWith<$R, $In, $Out> {
  @override
  $R call({MessagesItem? item});
  MessagesSlotCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessagesSlotCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessagesSlot, $Out>
    implements MessagesSlotCopyWith<$R, MessagesSlot, $Out> {
  _MessagesSlotCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessagesSlot> $mapper =
      MessagesSlotMapper.ensureInitialized();
  @override
  $R call({MessagesItem? item}) =>
      $apply(FieldCopyWithData({if (item != null) #item: item}));
  @override
  MessagesSlot $make(CopyWithData data) =>
      MessagesSlot(data.get(#item, or: $value.item));

  @override
  MessagesSlotCopyWith<$R2, MessagesSlot, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessagesSlotCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

