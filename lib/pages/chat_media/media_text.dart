import 'package:fujin/domain/chat/edit/crop_aspect.dart';
import 'package:fujin/domain/chat/edit/edit_mark.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';

abstract final class MediaText {
  static String mark(AppLocalizations intl, EditMark mark) => switch (mark) {
    EditMark.cropped => intl.chatTrayCropped,
    EditMark.trimmed => intl.chatTrayTrimmed,
  };

  static String markIcon(EditMark mark) => switch (mark) {
    EditMark.cropped => ChatMediaIcon.crop,
    EditMark.trimmed => ChatMediaIcon.scissors,
  };

  static String aspect(AppLocalizations intl, CropAspect aspect) =>
      switch (aspect) {
        CropAspect.free => intl.chatEditorFree,
        CropAspect.original => intl.chatEditorOriginal,
        CropAspect.square ||
        CropAspect.fourFive ||
        CropAspect.sixteenNine ||
        CropAspect.nineSixteen => switch ((aspect.width, aspect.height)) {
          (final width?, final height?) => intl.chatEditorRatio(width, height),
          (_, _) => intl.chatEditorFree,
        },
      };
}
