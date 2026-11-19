import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/media/photo_request.dart';
import 'package:fujin/data/media/rect_hook.dart';
import 'package:fujin/domain/chat/edit/crop_aspect.dart';
import 'package:fujin/domain/chat/edit/crop_geometry.dart';
import 'package:fujin/domain/chat/edit/crop_handle.dart';
import 'package:fujin/domain/chat/edit/edit_mark.dart';

part 'photo_edit.mapper.dart';

@MappableClass()
final class PhotoEdit with PhotoEditMappable {
  const PhotoEdit({
    this.crop,
    this.aspect = CropAspect.free,
    this.quarterTurns = 0,
  });

  static const _turns = 4;

  @MappableField(hook: RectHook())
  final Rect? crop;

  final CropAspect aspect;
  final int quarterTurns;

  bool get isEdited => crop != null || quarterTurns != 0;

  EditMark? get mark => switch (isEdited) {
    true => EditMark.cropped,
    false => null,
  };

  Rect get shownCrop =>
      CropGeometry.turned(crop ?? CropGeometry.whole, quarterTurns);

  Size shownSize(Size upright) => switch (quarterTurns.isOdd) {
    true => upright.flipped,
    false => upright,
  };

  PhotoEdit rotated(Size upright) {
    final turned = copyWith(quarterTurns: (quarterTurns - 1) % _turns);
    return switch (aspect) {
      CropAspect.free => turned,
      _ => turned.withAspect(aspect, upright),
    };
  }

  PhotoEdit withAspect(CropAspect aspect, Size upright) =>
      switch (aspect.ratioIn(shownSize(upright))) {
        null => copyWith(aspect: aspect),
        final ratio => _withShownCrop(
          CropGeometry.fitted(ratio, shownSize(upright)),
          aspect,
        ),
      };

  PhotoEdit dragged(CropHandle handle, Offset delta, Size upright) {
    final shown = shownSize(upright);
    return _withShownCrop(
      CropGeometry.dragged(
        shownCrop,
        handle,
        delta,
        picture: shown,
        ratio: aspect.ratioIn(shown),
      ),
      aspect,
    );
  }

  PhotoRequest request({required String source, required String output}) =>
      PhotoRequest(
        source: source,
        output: output,
        crop: crop,
        quarterTurns: quarterTurns,
      );

  PhotoEdit _withShownCrop(Rect shown, CropAspect aspect) => PhotoEdit(
    crop: CropGeometry.normalized(CropGeometry.unturned(shown, quarterTurns)),
    aspect: aspect,
    quarterTurns: quarterTurns,
  );
}
