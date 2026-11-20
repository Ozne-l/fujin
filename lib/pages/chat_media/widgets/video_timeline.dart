import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_haptics.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/duration_clamp.dart';
import 'package:fujin/domain/chat/edit/video_edit.dart';
import 'package:fujin/domain/chat/edit/video_passage.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/use_lingering.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:motor/motor.dart';

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

  static const double _reach = 24;

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
    final touching = useRef(false);
    final limited = switch (grab.value) {
      (:final grip, offset: _) => _atLimit(grip),
      null => false,
    };
    useEffect(() {
      if (limited && !touching.value) FujinHaptics.select();
      touching.value = limited;
      return null;
    }, [limited]);
    final (
      value: restorable,
      settle: settleRestorable,
    ) = useLingering<List<VideoPassage>>(
      (held) => [
        ...?held?.where((passage) => !edit.removed.contains(passage)),
        ...edit.removed,
      ],
    );
    final (value: measured, settle: settleMeasured) =
        useLingering<VideoPassage?>((held) => selection ?? held);
    final colors = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final duration = edit.duration;
        double x(Duration at) =>
            width * at.inMicroseconds / math.max(1, duration.inMicroseconds);
        Duration at(double dx) => duration * (dx / width).clamp(0, 1);
        return SizedBox(
          height:
              FujinSize.playheadKnob +
              FujinSize.timelineStripHeight +
              FujinSpace.s2 +
              FujinSize.timelinePillHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: FujinSize.playheadKnob,
                left: 0,
                right: 0,
                height: FujinSize.timelineStripHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(FujinRadius.key),
                  child: ColoredBox(
                    color: colors.cameraButton,
                    child: Row(
                      children: [
                        for (final frame in frames)
                          Expanded(
                            child: switch (frame) {
                              final frame? => Image.file(
                                File(frame),
                                fit: BoxFit.cover,
                                height: FujinSize.timelineStripHeight,
                                gaplessPlayback: true,
                                frameBuilder:
                                    (context, child, painted, synchronous) =>
                                        SingleMotionBuilder(
                                          value: switch ((
                                            synchronous,
                                            painted,
                                          )) {
                                            (true, _) || (_, _?) => 1,
                                            (false, null) => 0,
                                          },
                                          motion: FujinMotion.dissolve,
                                          builder: (context, opacity, child) =>
                                              Opacity(
                                                opacity: opacity.clamp(0, 1),
                                                child: child,
                                              ),
                                          child: child,
                                        ),
                              ),
                              null => const SizedBox.shrink(),
                            },
                          ),
                      ],
                    ),
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
                    touching.value = _atLimit(grip);
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
                      top: FujinSize.playheadKnob,
                    ),
                  ),
                ),
              ),
              for (final passage in restorable)
                _PillAt(
                  key: ValueKey(passage),
                  center: x(passage.start + passage.length ~/ 2),
                  top:
                      FujinSize.playheadKnob +
                      FujinSize.timelineStripHeight +
                      FujinSpace.s2,
                  shown: edit.removed.contains(passage),
                  onGone: () => settleRestorable(
                    (held) => [
                      for (final kept in held)
                        if (kept != passage) kept,
                    ],
                  ),
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
              if (measured case final shownSelection?)
                _PillAt(
                  key: const ValueKey(#selection),
                  center: x(shownSelection.start + shownSelection.length ~/ 2),
                  top:
                      FujinSize.playheadKnob +
                      FujinSize.timelineStripHeight +
                      FujinSpace.s2,
                  shown: selection != null,
                  onGone: () => settleMeasured((_) => null),
                  child: _Pill(
                    label: ChatText.clock(shownSelection.length),
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
      (grip: _Grip.start, at: x(edit.start) + FujinSize.trimHandleWidth / 2),
      (grip: _Grip.end, at: x(edit.end) - FujinSize.trimHandleWidth / 2),
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

  bool _atLimit(_Grip grip) => switch ((grip, selection)) {
    (_Grip.start, _) =>
      edit.start == Duration.zero ||
          edit.end - edit.start <= VideoEdit.minimumKept,
    (_Grip.end, _) =>
      edit.end == edit.duration ||
          edit.end - edit.start <= VideoEdit.minimumKept,
    (_Grip.selectionStart, final selection?) =>
      selection.start == edit.start ||
          selection.length <= VideoEdit.minimumPassage,
    (_Grip.selectionEnd, final selection?) =>
      selection.end == edit.end || selection.length <= VideoEdit.minimumPassage,
    (_Grip.selectionStart || _Grip.selectionEnd, null) => false,
    (_Grip.playhead, _) => false,
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
  const _PillAt({
    required this.center,
    required this.top,
    required this.shown,
    required this.onGone,
    required this.child,
    super.key,
  });

  final double center;
  final double top;
  final bool shown;
  final VoidCallback onGone;
  final Widget child;

  @override
  Widget build(BuildContext context) => Positioned(
    top: top,
    left: 0,
    right: 0,
    child: CustomSingleChildLayout(
      delegate: _CenterAt(center),
      child: IgnorePointer(
        ignoring: !shown,
        child: SingleMotionBuilder(
          value: switch (shown) {
            true => 1,
            false => 0,
          },
          from: 0,
          motion: FujinMotion.dissolve,
          onAnimationStatusChanged: (status) {
            if (!shown && !status.isAnimating) onGone();
          },
          builder: (context, opacity, child) =>
              Opacity(opacity: opacity.clamp(0, 1), child: child),
          child: child,
        ),
      ),
    ),
  );
}

class _CenterAt extends SingleChildLayoutDelegate {
  const _CenterAt(this.center);

  final double center;

  @override
  Size getSize(BoxConstraints constraints) =>
      Size(constraints.maxWidth, FujinSize.timelinePillHeight);

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
        height: FujinSize.timelinePillHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FujinSize.mediaPillPaddingHorizontal,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: FujinSpace.s1,
            children: [
              if (icon case final icon?)
                MediaGlyph(
                  icon,
                  size: FujinSize.mediaPillIcon,
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

  final VideoEdit edit;
  final VideoPassage? selection;
  final Duration playhead;
  final double Function(Duration) x;
  final FujinColors colors;
  final double top;

  @override
  void paint(Canvas canvas, Size size) {
    final bottom = top + FujinSize.timelineStripHeight;
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
      ..drawRect(
        Rect.fromLTRB(start, top, end, top + FujinStroke.trimFrame),
        accent,
      )
      ..drawRect(
        Rect.fromLTRB(start, bottom - FujinStroke.trimFrame, end, bottom),
        accent,
      );
    for (final handle in [
      Rect.fromLTWH(
        start,
        top,
        FujinSize.trimHandleWidth,
        FujinSize.timelineStripHeight,
      ),
      Rect.fromLTWH(
        end - FujinSize.trimHandleWidth,
        top,
        FujinSize.trimHandleWidth,
        FujinSize.timelineStripHeight,
      ),
    ]) {
      canvas
        ..drawRRect(RRect.fromRectAndRadius(handle, key), accent)
        ..drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: handle.center,
              width: FujinSize.trimGripWidth,
              height: FujinSize.trimGripHeight,
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
        RRect.fromRectAndRadius(
          area.deflate(FujinStroke.timelineSelection / 2),
          key,
        ),
        Paint()
          ..color = colors.cameraText
          ..style = PaintingStyle.stroke
          ..strokeWidth = FujinStroke.timelineSelection,
      );
      for (final edge in [area.left, area.right]) {
        canvas
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(edge, area.center.dy),
                width: FujinSize.selectionHandleWidth,
                height: FujinSize.selectionHandleHeight,
              ),
              const Radius.circular(FujinRadius.pill),
            ),
            light,
          )
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(edge, area.center.dy),
                width: FujinSize.trimGripWidth / 2,
                height: FujinSize.trimGripHeight / 2,
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
            head - FujinStroke.playhead / 2,
            top - FujinSize.playheadOverhang,
            head + FujinStroke.playhead / 2,
            bottom + FujinSize.playheadOverhang,
          ),
          const Radius.circular(FujinRadius.bar),
        ),
        light,
      )
      ..drawCircle(
        Offset(
          head,
          top -
              FujinSize.playheadOverhang -
              FujinSize.playheadKnob / 2 +
              FujinSize.playheadKnobOverlap,
        ),
        FujinSize.playheadKnob / 2,
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
