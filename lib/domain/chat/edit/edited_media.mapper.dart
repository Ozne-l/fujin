// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'edited_media.dart';

class EditedMediaMapper extends ClassMapperBase<EditedMedia> {
  EditedMediaMapper._();

  static EditedMediaMapper? _instance;
  static EditedMediaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EditedMediaMapper._());
      EditedPhotoMapper.ensureInitialized();
      EditedVideoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EditedMedia';

  static String _$path(EditedMedia v) => v.path;
  static const Field<EditedMedia, String> _f$path = Field('path', _$path);
  static int _$width(EditedMedia v) => v.width;
  static const Field<EditedMedia, int> _f$width = Field('width', _$width);
  static int _$height(EditedMedia v) => v.height;
  static const Field<EditedMedia, int> _f$height = Field('height', _$height);

  @override
  final MappableFields<EditedMedia> fields = const {
    #path: _f$path,
    #width: _f$width,
    #height: _f$height,
  };
  @override
  final bool ignoreNull = true;

  static EditedMedia _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'EditedMedia',
      'kind',
      '${data.value['kind']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EditedMedia fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EditedMedia>(map);
  }

  static EditedMedia fromJson(String json) {
    return ensureInitialized().decodeJson<EditedMedia>(json);
  }
}

mixin EditedMediaMappable {
  String toJson();
  Map<String, dynamic> toMap();
  EditedMediaCopyWith<EditedMedia, EditedMedia, EditedMedia> get copyWith;
}

abstract class EditedMediaCopyWith<$R, $In extends EditedMedia, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? path, int? width, int? height});
  EditedMediaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class EditedPhotoMapper extends SubClassMapperBase<EditedPhoto> {
  EditedPhotoMapper._();

  static EditedPhotoMapper? _instance;
  static EditedPhotoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EditedPhotoMapper._());
      EditedMediaMapper.ensureInitialized().addSubMapper(_instance!);
      PhotoEditMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EditedPhoto';

  static String _$path(EditedPhoto v) => v.path;
  static const Field<EditedPhoto, String> _f$path = Field('path', _$path);
  static int _$width(EditedPhoto v) => v.width;
  static const Field<EditedPhoto, int> _f$width = Field('width', _$width);
  static int _$height(EditedPhoto v) => v.height;
  static const Field<EditedPhoto, int> _f$height = Field('height', _$height);
  static PhotoEdit _$edit(EditedPhoto v) => v.edit;
  static const Field<EditedPhoto, PhotoEdit> _f$edit = Field(
    'edit',
    _$edit,
    opt: true,
    def: const PhotoEdit(),
  );

  @override
  final MappableFields<EditedPhoto> fields = const {
    #path: _f$path,
    #width: _f$width,
    #height: _f$height,
    #edit: _f$edit,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'photo';
  @override
  late final ClassMapperBase superMapper =
      EditedMediaMapper.ensureInitialized();

  static EditedPhoto _instantiate(DecodingData data) {
    return EditedPhoto(
      path: data.dec(_f$path),
      width: data.dec(_f$width),
      height: data.dec(_f$height),
      edit: data.dec(_f$edit),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EditedPhoto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EditedPhoto>(map);
  }

  static EditedPhoto fromJson(String json) {
    return ensureInitialized().decodeJson<EditedPhoto>(json);
  }
}

mixin EditedPhotoMappable {
  String toJson() {
    return EditedPhotoMapper.ensureInitialized().encodeJson<EditedPhoto>(
      this as EditedPhoto,
    );
  }

  Map<String, dynamic> toMap() {
    return EditedPhotoMapper.ensureInitialized().encodeMap<EditedPhoto>(
      this as EditedPhoto,
    );
  }

  EditedPhotoCopyWith<EditedPhoto, EditedPhoto, EditedPhoto> get copyWith =>
      _EditedPhotoCopyWithImpl<EditedPhoto, EditedPhoto>(
        this as EditedPhoto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EditedPhotoMapper.ensureInitialized().stringifyValue(
      this as EditedPhoto,
    );
  }

  @override
  bool operator ==(Object other) {
    return EditedPhotoMapper.ensureInitialized().equalsValue(
      this as EditedPhoto,
      other,
    );
  }

  @override
  int get hashCode {
    return EditedPhotoMapper.ensureInitialized().hashValue(this as EditedPhoto);
  }
}

extension EditedPhotoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EditedPhoto, $Out> {
  EditedPhotoCopyWith<$R, EditedPhoto, $Out> get $asEditedPhoto =>
      $base.as((v, t, t2) => _EditedPhotoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EditedPhotoCopyWith<$R, $In extends EditedPhoto, $Out>
    implements EditedMediaCopyWith<$R, $In, $Out> {
  PhotoEditCopyWith<$R, PhotoEdit, PhotoEdit> get edit;
  @override
  $R call({String? path, int? width, int? height, PhotoEdit? edit});
  EditedPhotoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EditedPhotoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EditedPhoto, $Out>
    implements EditedPhotoCopyWith<$R, EditedPhoto, $Out> {
  _EditedPhotoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EditedPhoto> $mapper =
      EditedPhotoMapper.ensureInitialized();
  @override
  PhotoEditCopyWith<$R, PhotoEdit, PhotoEdit> get edit =>
      $value.edit.copyWith.$chain((v) => call(edit: v));
  @override
  $R call({String? path, int? width, int? height, PhotoEdit? edit}) => $apply(
    FieldCopyWithData({
      if (path != null) #path: path,
      if (width != null) #width: width,
      if (height != null) #height: height,
      if (edit != null) #edit: edit,
    }),
  );
  @override
  EditedPhoto $make(CopyWithData data) => EditedPhoto(
    path: data.get(#path, or: $value.path),
    width: data.get(#width, or: $value.width),
    height: data.get(#height, or: $value.height),
    edit: data.get(#edit, or: $value.edit),
  );

  @override
  EditedPhotoCopyWith<$R2, EditedPhoto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EditedPhotoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EditedVideoMapper extends SubClassMapperBase<EditedVideo> {
  EditedVideoMapper._();

  static EditedVideoMapper? _instance;
  static EditedVideoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EditedVideoMapper._());
      EditedMediaMapper.ensureInitialized().addSubMapper(_instance!);
      VideoEditMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EditedVideo';

  static String _$path(EditedVideo v) => v.path;
  static const Field<EditedVideo, String> _f$path = Field('path', _$path);
  static int _$width(EditedVideo v) => v.width;
  static const Field<EditedVideo, int> _f$width = Field('width', _$width);
  static int _$height(EditedVideo v) => v.height;
  static const Field<EditedVideo, int> _f$height = Field('height', _$height);
  static VideoEdit _$edit(EditedVideo v) => v.edit;
  static const Field<EditedVideo, VideoEdit> _f$edit = Field('edit', _$edit);

  @override
  final MappableFields<EditedVideo> fields = const {
    #path: _f$path,
    #width: _f$width,
    #height: _f$height,
    #edit: _f$edit,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'video';
  @override
  late final ClassMapperBase superMapper =
      EditedMediaMapper.ensureInitialized();

  static EditedVideo _instantiate(DecodingData data) {
    return EditedVideo(
      path: data.dec(_f$path),
      width: data.dec(_f$width),
      height: data.dec(_f$height),
      edit: data.dec(_f$edit),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EditedVideo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EditedVideo>(map);
  }

  static EditedVideo fromJson(String json) {
    return ensureInitialized().decodeJson<EditedVideo>(json);
  }
}

mixin EditedVideoMappable {
  String toJson() {
    return EditedVideoMapper.ensureInitialized().encodeJson<EditedVideo>(
      this as EditedVideo,
    );
  }

  Map<String, dynamic> toMap() {
    return EditedVideoMapper.ensureInitialized().encodeMap<EditedVideo>(
      this as EditedVideo,
    );
  }

  EditedVideoCopyWith<EditedVideo, EditedVideo, EditedVideo> get copyWith =>
      _EditedVideoCopyWithImpl<EditedVideo, EditedVideo>(
        this as EditedVideo,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EditedVideoMapper.ensureInitialized().stringifyValue(
      this as EditedVideo,
    );
  }

  @override
  bool operator ==(Object other) {
    return EditedVideoMapper.ensureInitialized().equalsValue(
      this as EditedVideo,
      other,
    );
  }

  @override
  int get hashCode {
    return EditedVideoMapper.ensureInitialized().hashValue(this as EditedVideo);
  }
}

extension EditedVideoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EditedVideo, $Out> {
  EditedVideoCopyWith<$R, EditedVideo, $Out> get $asEditedVideo =>
      $base.as((v, t, t2) => _EditedVideoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EditedVideoCopyWith<$R, $In extends EditedVideo, $Out>
    implements EditedMediaCopyWith<$R, $In, $Out> {
  VideoEditCopyWith<$R, VideoEdit, VideoEdit> get edit;
  @override
  $R call({String? path, int? width, int? height, VideoEdit? edit});
  EditedVideoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EditedVideoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EditedVideo, $Out>
    implements EditedVideoCopyWith<$R, EditedVideo, $Out> {
  _EditedVideoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EditedVideo> $mapper =
      EditedVideoMapper.ensureInitialized();
  @override
  VideoEditCopyWith<$R, VideoEdit, VideoEdit> get edit =>
      $value.edit.copyWith.$chain((v) => call(edit: v));
  @override
  $R call({String? path, int? width, int? height, VideoEdit? edit}) => $apply(
    FieldCopyWithData({
      if (path != null) #path: path,
      if (width != null) #width: width,
      if (height != null) #height: height,
      if (edit != null) #edit: edit,
    }),
  );
  @override
  EditedVideo $make(CopyWithData data) => EditedVideo(
    path: data.get(#path, or: $value.path),
    width: data.get(#width, or: $value.width),
    height: data.get(#height, or: $value.height),
    edit: data.get(#edit, or: $value.edit),
  );

  @override
  EditedVideoCopyWith<$R2, EditedVideo, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EditedVideoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

