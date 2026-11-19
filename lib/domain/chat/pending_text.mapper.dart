// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'pending_text.dart';

class PendingTextMapper extends ClassMapperBase<PendingText> {
  PendingTextMapper._();

  static PendingTextMapper? _instance;
  static PendingTextMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PendingTextMapper._());
      EkkloMessageMapper.ensureInitialized();
      PendingTextStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PendingText';

  static EkkloMessage _$message(PendingText v) => v.message;
  static const Field<PendingText, EkkloMessage> _f$message = Field(
    'message',
    _$message,
  );
  static PendingTextState _$state(PendingText v) => v.state;
  static const Field<PendingText, PendingTextState> _f$state = Field(
    'state',
    _$state,
  );
  static String? _$after(PendingText v) => v.after;
  static const Field<PendingText, String> _f$after = Field(
    'after',
    _$after,
    opt: true,
  );

  @override
  final MappableFields<PendingText> fields = const {
    #message: _f$message,
    #state: _f$state,
    #after: _f$after,
  };
  @override
  final bool ignoreNull = true;

  static PendingText _instantiate(DecodingData data) {
    return PendingText(
      message: data.dec(_f$message),
      state: data.dec(_f$state),
      after: data.dec(_f$after),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PendingText fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PendingText>(map);
  }

  static PendingText fromJson(String json) {
    return ensureInitialized().decodeJson<PendingText>(json);
  }
}

mixin PendingTextMappable {
  String toJson() {
    return PendingTextMapper.ensureInitialized().encodeJson<PendingText>(
      this as PendingText,
    );
  }

  Map<String, dynamic> toMap() {
    return PendingTextMapper.ensureInitialized().encodeMap<PendingText>(
      this as PendingText,
    );
  }

  PendingTextCopyWith<PendingText, PendingText, PendingText> get copyWith =>
      _PendingTextCopyWithImpl<PendingText, PendingText>(
        this as PendingText,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PendingTextMapper.ensureInitialized().stringifyValue(
      this as PendingText,
    );
  }

  @override
  bool operator ==(Object other) {
    return PendingTextMapper.ensureInitialized().equalsValue(
      this as PendingText,
      other,
    );
  }

  @override
  int get hashCode {
    return PendingTextMapper.ensureInitialized().hashValue(this as PendingText);
  }
}

extension PendingTextValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PendingText, $Out> {
  PendingTextCopyWith<$R, PendingText, $Out> get $asPendingText =>
      $base.as((v, t, t2) => _PendingTextCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PendingTextCopyWith<$R, $In extends PendingText, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage> get message;
  $R call({EkkloMessage? message, PendingTextState? state, String? after});
  PendingTextCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PendingTextCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PendingText, $Out>
    implements PendingTextCopyWith<$R, PendingText, $Out> {
  _PendingTextCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PendingText> $mapper =
      PendingTextMapper.ensureInitialized();
  @override
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage> get message =>
      $value.message.copyWith.$chain((v) => call(message: v));
  @override
  $R call({
    EkkloMessage? message,
    PendingTextState? state,
    Object? after = $none,
  }) => $apply(
    FieldCopyWithData({
      if (message != null) #message: message,
      if (state != null) #state: state,
      if (after != $none) #after: after,
    }),
  );
  @override
  PendingText $make(CopyWithData data) => PendingText(
    message: data.get(#message, or: $value.message),
    state: data.get(#state, or: $value.state),
    after: data.get(#after, or: $value.after),
  );

  @override
  PendingTextCopyWith<$R2, PendingText, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PendingTextCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

