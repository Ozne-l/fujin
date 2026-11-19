import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/duration_clamp.dart';
import 'package:fujin/domain/chat/edit/video_edit.dart';
import 'package:fujin/domain/chat/edit/video_passage.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';

class VideoTimeline extends HookWidget {
  const VideoTimeline({
    required this.edit,
    required this.frames,
    required this.playhead,
    required this.selection,
    required this.onEdited,
    required this.onSelected,
    required this.onSeek,
    super.key,
  });

  static const double stripHeight = 56;
  static const double _knob = 10;
  static const double _pillGap = 8;
  static const double _pillHeight = 21;
  static const double _reach = 24;
  static const double handleWidth = 14;

  final VideoEdit edit;
  final List<String?> frames;
  final Duration playhead;
  final VideoPassage? selection;
  final ValueChanged<VideoEdit> onEdited;
  final ValueChanged<VideoPassage?> onSelected;
  final ValueChanged<Duration> onSeek;

  @override
  Widget build(BuildContext context) {
    final grab = useRef<({_Grip grip, Duration offset})?>(null);
    final colors = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final duration = edit.duration;
        double x(Duration at) =>
            width * at.inMicroseconds / math.max(1, duration.inMicroseconds);
        Duration at(double dx) => duration * (dx / width).clamp(0, 1);
        return SizedBox(
          height: _knob + stripHeight + _pillGap + _pillHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: _knob,
                left: 0,
                right: 0,
                height: stripHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(FujinRadius.key),
                  child: Row(
                    children: [
                      for (final frame in frames)
                        Expanded(
                          child: switch (frame) {
                            final frame? => Image.file(
                              File(frame),
                              fit: BoxFit.cover,
                              height: stripHeight,
                              gaplessPlayback: true,
                            ),
                            null => ColoredBox(color: colors.cameraButton),
                          },
                        ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    final tapped = at(details.localPosition.dx);
                    if (tapped < edit.start || tapped > edit.end) return;
                    onSeek(tapped);
                    if (edit.removed.any(
                      (passage) => passage.contains(tapped),
                    )) {
                      return;
                    }
                    onSelected(edit.selectionAt(tapped));
                  },
                  onHorizontalDragStart: (details) {
                    final dx = details.localPosition.dx;
                    final grip = _gripAt(dx, x);
                    grab.value = (
                      grip: grip,
                      offset: at(dx) - _gripTime(grip),
                    );
                  },
                  onHorizontalDragUpdate: (details) {
                    if (grab.value case (:final grip, :final offset)) {
                      _drag(grip, at(details.localPosition.dx) - offset);
                    }
                  },
                  onHorizontalDragEnd: (details) => grab.value = null,
                  onHorizontalDragCancel: () => grab.value = null,
                  child: CustomPaint(
                    painter: _TimelinePainter(
                      edit: edit,
                      selection: selection,
                      playhead: playhead,
                      x: x,
                      colors: colors,
                      top: _knob,
                    ),
                  ),
                ),
              ),
              for (final passage in edit.removed)
                _PillAt(
                  center: x(passage.start + passage.length ~/ 2),
                  top: _knob + stripHeight + _pillGap,
                  child: _Pill(
                    label: context.intl.chatEditorRestore(
                      ChatText.clock(passage.length),
                    ),
                    icon: ChatMediaIcon.rotate,
                    onPressed: () {
                      onEdited(edit.restoring(passage));
                    },
                  ),
                ),
              if (selection case final selection?)
                _PillAt(
                  center: x(selection.start + selection.length ~/ 2),
                  top: _knob + stripHeight + _pillGap,
                  child: _Pill(
                    label: ChatText.clock(selection.length),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  _Grip _gripAt(double dx, double Function(Duration) x) {
    final candidates = [
      if (selection case final selection?) ...[
        (grip: _Grip.selectionStart, at: x(selection.start)),
        (grip: _Grip.selectionEnd, at: x(selection.end)),
      ],
      (grip: _Grip.start, at: x(edit.start) + handleWidth / 2),
      (grip: _Grip.end, at: x(edit.end) - handleWidth / 2),
    ];
    for (final candidate in candidates) {
      if ((candidate.at - dx).abs() <= _reach) return candidate.grip;
    }
    return _Grip.playhead;
  }

  Duration _gripTime(_Grip grip) => switch ((grip, selection)) {
    (_Grip.start, _) => edit.start,
    (_Grip.end, _) => edit.end,
    (_Grip.selectionStart, final selection?) => selection.start,
    (_Grip.selectionEnd, final selection?) => selection.end,
    (_Grip.selectionStart || _Grip.selectionEnd, null) => playhead,
    (_Grip.playhead, _) => playhead,
  };

  void _drag(_Grip grip, Duration to) {
    switch ((grip, selection)) {
      case (_Grip.start, _):
        _trim(edit.trimmed(start: to));
      case (_Grip.end, _):
        _trim(edit.trimmed(end: to));
      case (_Grip.selectionStart, final selection?):
        final start = to.clampedTo(
          edit.start,
          selection.end - VideoEdit.minimumPassage,
        );
        onSelected(VideoPassage(start: start, end: selection.end));
      case (_Grip.selectionEnd, final selection?):
        final end = to.clampedTo(
          selection.start + VideoEdit.minimumPassage,
          edit.end,
        );
        onSelected(VideoPassage(start: selection.start, end: end));
      case (_Grip.selectionStart || _Grip.selectionEnd, null):
        return;
      case (_Grip.playhead, _):
        onSeek(to.clampedTo(edit.start, edit.end));
    }
  }

  void _trim(VideoEdit trimmed) {
    if (identical(trimmed, edit)) return;
    onEdited(trimmed);
    if (selection case final selection?
        when selection.start < trimmed.start || selection.end > trimmed.end) {
      onSelected(null);
    }
  }
}

enum _Grip { start, end, selectionStart, selectionEnd, playhead }

class _PillAt extends StatelessWidget {
  const _PillAt({required this.center, required this.top, required this.child});

  final double center;
  final double top;
  final Widget child;

  @override
  Widget build(BuildContext context) => Positioned(
    top: top,
    left: 0,
    right: 0,
    child: CustomSingleChildLayout(
      delegate: _CenterAt(center),
      child: child,
    ),
  );
}

class _CenterAt extends SingleChildLayoutDelegate {
  const _CenterAt(this.center);

  final double center;

  @override
  Size getSize(BoxConstraints constraints) =>
      Size(constraints.maxWidth, VideoTimeline._pillHeight);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) => Offset(
    (center - childSize.width / 2).clamp(
      0,
      math.max(0, size.width - childSize.width),
    ),
    0,
  );

  @override
  bool shouldRelayout(_CenterAt oldDelegate) => oldDelegate.center != center;
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, this.icon, this.onPressed});

  static const double _iconSize = 12;
  static const double _horizontal = 6;

  final String label;
  final String? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final content = DecoratedBox(
      decoration: ShapeDecoration(
        color: colors.cameraText,
        shape: const StadiumBorder(),
      ),
      child: SizedBox(
        height: VideoTimeline._pillHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontal),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: FujinSpace.s1,
            children: [
              if (icon case final icon?)
                MediaGlyph(
                  icon,
                  size: _iconSize,
                  color: colors.cameraBackground,
                ),
              Text(
                label,
                style: FujinText.inter11Semibold.copyWith(
                  color: colors.cameraBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return switch (onPressed) {
      null => content,
      final onPressed => Semantics(
        button: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: content,
        ),
      ),
    };
  }
}

class _TimelinePainter extends CustomPainter {
  const _TimelinePainter({
    required this.edit,
    required this.selection,
    required this.playhead,
    required this.x,
    required this.colors,
    required this.top,
  });

  static const double _trimmedAlpha = 0.6;
  static const double _removedAlpha = 0.85;
  static const double _bar = 3;
  static const double _grip = 3;
  static const double _gripHeight = 18;
  static const double _outline = 2;
  static const double _selectionHandleWidth = 10;
  static const double _selectionHandleHeight = 28;
  static const double _playheadWidth = 2;
  static const double _playheadOverhang = 4;
  static const double _knob = 10;

  final VideoEdit edit;
  final VideoPassage? selection;
  final Duration playhead;
  final double Function(Duration) x;
  final FujinColors colors;
  final double top;

  @override
  void paint(Canvas canvas, Size size) {
    final bottom = top + VideoTimeline.stripHeight;
    final start = x(edit.start);
    final end = x(edit.end);
    final trimmed = Paint()
      ..color = colors.cameraBackground.withValues(alpha: _trimmedAlpha);
    final removed = Paint()
      ..color = colors.cameraBackground.withValues(alpha: _removedAlpha);
    final accent = Paint()..color = colors.cameraAccent;
    final light = Paint()..color = colors.cameraText;
    final dark = Paint()..color = colors.cameraBackground;
    const key = Radius.circular(FujinRadius.key);
    canvas
      ..drawRect(Rect.fromLTRB(0, top, start, bottom), trimmed)
      ..drawRect(Rect.fromLTRB(end, top, size.width, bottom), trimmed);
    for (final passage in edit.removed) {
      canvas.drawRect(
        Rect.fromLTRB(x(passage.start), top, x(passage.end), bottom),
        removed,
      );
    }
    canvas
      ..drawRect(Rect.fromLTRB(start, top, end, top + _bar), accent)
      ..drawRect(Rect.fromLTRB(start, bottom - _bar, end, bottom), accent);
    for (final handle in [
      Rect.fromLTWH(
        start,
        top,
        VideoTimeline.handleWidth,
        VideoTimeline.stripHeight,
      ),
      Rect.fromLTWH(
        end - VideoTimeline.handleWidth,
        top,
        VideoTimeline.handleWidth,
        VideoTimeline.stripHeight,
      ),
    ]) {
      canvas
        ..drawRRect(RRect.fromRectAndRadius(handle, key), accent)
        ..drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: handle.center,
              width: _grip,
              height: _gripHeight,
            ),
            const Radius.circular(FujinRadius.bar),
          ),
          dark,
        );
    }
    if (selection case final selection?) {
      final area = Rect.fromLTRB(
        x(selection.start),
        top,
        x(selection.end),
        bottom,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(area.deflate(_outline / 2), key),
        Paint()
          ..color = colors.cameraText
          ..style = PaintingStyle.stroke
          ..strokeWidth = _outline,
      );
      for (final edge in [area.left, area.right]) {
        canvas
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(edge, area.center.dy),
                width: _selectionHandleWidth,
                height: _selectionHandleHeight,
              ),
              const Radius.circular(FujinRadius.pill),
            ),
            light,
          )
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(edge, area.center.dy),
                width: _grip / 2,
                height: _gripHeight / 2,
              ),
              const Radius.circular(FujinRadius.bar),
            ),
            dark,
          );
      }
    }
    final head = x(playhead);
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            head - _playheadWidth / 2,
            top - _playheadOverhang,
            head + _playheadWidth / 2,
            bottom + _playheadOverhang,
          ),
          const Radius.circular(FujinRadius.bar),
        ),
        light,
      )
      ..drawCircle(
        Offset(head, top - _playheadOverhang - _knob / 2 + 1),
        _knob / 2,
        light,
      );
  }

  @override
  bool shouldRepaint(_TimelinePainter oldDelegate) =>
      oldDelegate.edit != edit ||
      oldDelegate.selection != selection ||
      oldDelegate.playhead != playhead ||
      oldDelegate.colors != colors;
}
