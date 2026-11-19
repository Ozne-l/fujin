import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/media/kept_passage.dart';
import 'package:fujin/data/media/milliseconds_hook.dart';
import 'package:fujin/data/media/rect_hook.dart';
import 'package:fujin/data/media/video_export_request.dart';
import 'package:fujin/domain/chat/edit/crop_aspect.dart';
import 'package:fujin/domain/chat/edit/crop_geometry.dart';
import 'package:fujin/domain/chat/edit/crop_handle.dart';
import 'package:fujin/domain/chat/edit/duration_clamp.dart';
import 'package:fujin/domain/chat/edit/edit_mark.dart';
import 'package:fujin/domain/chat/edit/video_passage.dart';

part 'video_edit.mapper.dart';

@MappableClass()
final class VideoEdit with VideoEditMappable {
  const VideoEdit({
    required this.duration,
    required this.start,
    required this.end,
    this.removed = const [],
    this.crop,
    this.aspect = CropAspect.free,
    this.muted = false,
  });

  const VideoEdit.untouched(Duration duration)
    : this(duration: duration, start: Duration.zero, end: duration);

  static const minimumKept = Duration(seconds: 1);
  static const minimumPassage = Duration(milliseconds: 500);
  static const _selectionShare = 6;

  @MappableField(key: 'duration_ms', hook: MillisecondsHook())
  final Duration duration;

  @MappableField(key: 'start_ms', hook: MillisecondsHook())
  final Duration start;

  @MappableField(key: 'end_ms', hook: MillisecondsHook())
  final Duration end;

  final List<VideoPassage> removed;

  @MappableField(hook: RectHook())
  final Rect? crop;

  final CropAspect aspect;
  final bool muted;

  bool get isCut =>
      start > Duration.zero || end < duration || removed.isNotEmpty;

  bool get isEdited => isCut || crop != null || muted;

  EditMark? get mark => switch ((isCut, crop)) {
    (true, _) => EditMark.trimmed,
    (false, _?) => EditMark.cropped,
    (false, null) => null,
  };

  List<VideoPassage> get keptRanges {
    if (!isCut) return [VideoPassage(start: Duration.zero, end: duration)];
    final kept = <VideoPassage>[];
    var from = start;
    for (final passage in removed) {
      if (passage.start - from >= minimumPassage) {
        kept.add(VideoPassage(start: from, end: passage.start));
      }
      if (passage.end > from) from = passage.end;
    }
    if (end - from >= minimumPassage) {
      kept.add(VideoPassage(start: from, end: end));
    }
    return kept;
  }

  List<KeptPassage> get keptPassages => switch (isCut) {
    true => [for (final range in keptRanges) range.kept],
    false => const [],
  };

  Duration get keptDuration => keptRanges.fold(
    Duration.zero,
    (total, range) => total + range.length,
  );

  Duration get firstKeptStart => switch (keptRanges) {
    [final first, ...] => first.start,
    [] => start,
  };

  bool keeps(Duration position) =>
      keptRanges.any((range) => range.contains(position));

  Duration? nextKeptStart(Duration position) {
    for (final range in keptRanges) {
      if (position < range.start) return range.start;
    }
    return null;
  }

  Duration finalPosition(Duration position) => keptRanges.fold(
    Duration.zero,
    (total, range) => switch ((position <= range.start, position < range.end)) {
      (true, _) => total,
      (false, true) => total + (position - range.start),
      (false, false) => total + range.length,
    },
  );

  VideoEdit trimmed({Duration? start, Duration? end}) {
    if (duration < minimumKept) return this;
    final from = switch (start) {
      null => this.start,
      final start => start.clampedTo(Duration.zero, this.end - minimumKept),
    };
    final to = switch (end) {
      null => this.end,
      final end => end.clampedTo(from + minimumKept, duration),
    };
    final trimmed = copyWith(
      start: from,
      end: to,
      removed: [
        for (final passage in removed)
          if (VideoPassage(
                start: _later(passage.start, from),
                end: _earlier(passage.end, to),
              )
              case final clipped when clipped.length >= minimumPassage)
            clipped,
      ],
    );
    return switch (trimmed.keptDuration >= minimumKept) {
      true => trimmed,
      false => this,
    };
  }

  VideoPassage? selectionAt(Duration position) {
    final window = end - start;
    final length = _later(window ~/ _selectionShare, minimumPassage);
    if (window - length < minimumKept) return null;
    final from = (position - length ~/ 2).clampedTo(start, end - length);
    return VideoPassage(start: from, end: from + length);
  }

  bool canRemove(VideoPassage passage) => !identical(removing(passage), this);

  VideoEdit removing(VideoPassage passage) {
    if (passage.start < start ||
        passage.end > end ||
        passage.length < minimumPassage) {
      return this;
    }
    var merged = passage;
    final others = <VideoPassage>[];
    for (final other in removed) {
      switch (other.overlaps(merged)) {
        case true:
          merged = VideoPassage(
            start: _earlier(other.start, merged.start),
            end: _later(other.end, merged.end),
          );
        case false:
          others.add(other);
      }
    }
    final removing = copyWith(
      removed: [...others, merged]..sort((a, b) => a.start.compareTo(b.start)),
    );
    return switch (removing.keptDuration >= minimumKept) {
      true => removing,
      false => this,
    };
  }

  VideoEdit restoring(VideoPassage passage) => copyWith(
    removed: [
      for (final other in removed)
        if (other != passage) other,
    ],
  );

  VideoEdit toggledSound() => copyWith(muted: !muted);

  VideoEdit withAspect(CropAspect aspect, Size upright) =>
      switch (aspect.ratioIn(upright)) {
        null => copyWith(aspect: aspect),
        final ratio => copyWith(
          aspect: aspect,
          crop: CropGeometry.normalized(CropGeometry.fitted(ratio, upright)),
        ),
      };

  VideoEdit dragged(CropHandle handle, Offset delta, Size upright) => copyWith(
    crop: CropGeometry.normalized(
      CropGeometry.dragged(
        crop ?? CropGeometry.whole,
        handle,
        delta,
        picture: upright,
        ratio: aspect.ratioIn(upright),
      ),
    ),
  );

  VideoExportRequest request({
    required String source,
    required String output,
    required String poster,
    String? recipient,
    int position = 1,
    int count = 1,
  }) => VideoExportRequest(
    source: source,
    output: output,
    poster: poster,
    passages: keptPassages,
    crop: crop,
    muted: muted,
    recipient: recipient,
    position: position,
    count: count,
  );

  static Duration _earlier(Duration a, Duration b) => switch (a < b) {
    true => a,
    false => b,
  };

  static Duration _later(Duration a, Duration b) => switch (a > b) {
    true => a,
    false => b,
  };
}
