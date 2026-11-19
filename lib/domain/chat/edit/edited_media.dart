import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/chat/edit/edit_mark.dart';
import 'package:fujin/domain/chat/edit/photo_edit.dart';
import 'package:fujin/domain/chat/edit/video_edit.dart';

part 'edited_media.mapper.dart';

@MappableClass(discriminatorKey: 'kind')
sealed class EditedMedia with EditedMediaMappable {
  const EditedMedia({
    required this.path,
    required this.width,
    required this.height,
  });

  final String path;
  final int width;
  final int height;

  Size get upright => Size(width.toDouble(), height.toDouble());

  bool get isEdited;

  EditMark? get mark;
}

@MappableClass(discriminatorValue: 'photo')
final class EditedPhoto extends EditedMedia with EditedPhotoMappable {
  const EditedPhoto({
    required super.path,
    required super.width,
    required super.height,
    this.edit = const PhotoEdit(),
  });

  final PhotoEdit edit;

  @override
  bool get isEdited => edit.isEdited;

  @override
  EditMark? get mark => edit.mark;
}

@MappableClass(discriminatorValue: 'video')
final class EditedVideo extends EditedMedia with EditedVideoMappable {
  const EditedVideo({
    required super.path,
    required super.width,
    required super.height,
    required this.edit,
  });

  final VideoEdit edit;

  @override
  bool get isEdited => edit.isEdited;

  @override
  EditMark? get mark => edit.mark;
}
