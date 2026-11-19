// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'voice_settings.dart';

class VoiceSettingsMapper extends ClassMapperBase<VoiceSettings> {
  VoiceSettingsMapper._();

  static VoiceSettingsMapper? _instance;
  static VoiceSettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VoiceSettingsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VoiceSettings';

  static int _$sampleRate(VoiceSettings v) => v.sampleRate;
  static const Field<VoiceSettings, int> _f$sampleRate = Field(
    'sampleRate',
    _$sampleRate,
    key: r'sample_rate',
  );
  static int _$channels(VoiceSettings v) => v.channels;
  static const Field<VoiceSettings, int> _f$channels = Field(
    'channels',
    _$channels,
  );
  static int _$bitRate(VoiceSettings v) => v.bitRate;
  static const Field<VoiceSettings, int> _f$bitRate = Field(
    'bitRate',
    _$bitRate,
    key: r'bit_rate',
  );

  @override
  final MappableFields<VoiceSettings> fields = const {
    #sampleRate: _f$sampleRate,
    #channels: _f$channels,
    #bitRate: _f$bitRate,
  };
  @override
  final bool ignoreNull = true;

  static VoiceSettings _instantiate(DecodingData data) {
    return VoiceSettings(
      sampleRate: data.dec(_f$sampleRate),
      channels: data.dec(_f$channels),
      bitRate: data.dec(_f$bitRate),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VoiceSettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VoiceSettings>(map);
  }

  static VoiceSettings fromJson(String json) {
    return ensureInitialized().decodeJson<VoiceSettings>(json);
  }
}

mixin VoiceSettingsMappable {
  String toJson() {
    return VoiceSettingsMapper.ensureInitialized().encodeJson<VoiceSettings>(
      this as VoiceSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return VoiceSettingsMapper.ensureInitialized().encodeMap<VoiceSettings>(
      this as VoiceSettings,
    );
  }

  VoiceSettingsCopyWith<VoiceSettings, VoiceSettings, VoiceSettings>
  get copyWith => _VoiceSettingsCopyWithImpl<VoiceSettings, VoiceSettings>(
    this as VoiceSettings,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return VoiceSettingsMapper.ensureInitialized().stringifyValue(
      this as VoiceSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return VoiceSettingsMapper.ensureInitialized().equalsValue(
      this as VoiceSettings,
      other,
    );
  }

  @override
  int get hashCode {
    return VoiceSettingsMapper.ensureInitialized().hashValue(
      this as VoiceSettings,
    );
  }
}

extension VoiceSettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VoiceSettings, $Out> {
  VoiceSettingsCopyWith<$R, VoiceSettings, $Out> get $asVoiceSettings =>
      $base.as((v, t, t2) => _VoiceSettingsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VoiceSettingsCopyWith<$R, $In extends VoiceSettings, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? sampleRate, int? channels, int? bitRate});
  VoiceSettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VoiceSettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VoiceSettings, $Out>
    implements VoiceSettingsCopyWith<$R, VoiceSettings, $Out> {
  _VoiceSettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VoiceSettings> $mapper =
      VoiceSettingsMapper.ensureInitialized();
  @override
  $R call({int? sampleRate, int? channels, int? bitRate}) => $apply(
    FieldCopyWithData({
      if (sampleRate != null) #sampleRate: sampleRate,
      if (channels != null) #channels: channels,
      if (bitRate != null) #bitRate: bitRate,
    }),
  );
  @override
  VoiceSettings $make(CopyWithData data) => VoiceSettings(
    sampleRate: data.get(#sampleRate, or: $value.sampleRate),
    channels: data.get(#channels, or: $value.channels),
    bitRate: data.get(#bitRate, or: $value.bitRate),
  );

  @override
  VoiceSettingsCopyWith<$R2, VoiceSettings, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VoiceSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

