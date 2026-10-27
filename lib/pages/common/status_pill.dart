import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/pill_size.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:motor/motor.dart';

typedef _Content = ({String label, IconData? icon});

typedef _Change = ({_Content leaving, int arrival});

class StatusPill extends HookWidget {
  const StatusPill({
    required this.label,
    required this.tone,
    this.icon,
    this.size = PillSize.regular,
    this.glass = false,
    super.key,
  });

  final String label;
  final PillTone tone;
  final IconData? icon;
  final PillSize size;
  final bool glass;

  static const double _arrivingScale = 0.9;

  @override
  Widget build(BuildContext context) {
    final firstTone = useValueChanged<PillTone, PillTone>(
      tone,
      (previous, first) => first ?? previous,
    );
    final content = (label: label, icon: icon);
    final change = useValueChanged<_Content, _Change>(
      content,
      (previous, last) => (
        leaving: previous,
        arrival: switch (last) {
          null => 1,
          (:final arrival, leaving: _) => arrival + 1,
        },
      ),
    );
    final arrived = useState(0);
    final leaving = switch (change) {
      (leaving: final previous, :final arrival) when arrival != arrived.value =>
        previous,
      _ => null,
    };

    Widget row(_Content content, TextStyle style) => Row(
      mainAxisSize: MainAxisSize.min,
      spacing: FujinSpace.s1,
      children: [
        if (content.icon case final icon?)
          Icon(icon, size: style.fontSize, color: style.color),
        Flexible(
          child: Text(
            content.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );

    Widget pill(Color background, Color foreground) {
      final style = size.style.copyWith(color: foreground);
      final body = Container(
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: size.inset),
        clipBehavior: switch (leaving) {
          null => Clip.none,
          _ => Clip.antiAlias,
        },
        decoration: BoxDecoration(
          color: switch (glass) {
            true => null,
            false => background,
          },
          borderRadius: BorderRadius.circular(FujinRadius.pill),
        ),
        child: switch (change) {
          null => row(content, style),
          (:final arrival, leaving: _) => SingleMotionBuilder(
            key: ValueKey(arrival),
            motion: FujinMotion.of(context, FujinMotion.pill),
            from: 0,
            value: 1,
            onAnimationStatusChanged: (status) {
              if (status.isCompleted) arrived.value = arrival;
            },
            builder: (context, progress, child) => Stack(
              alignment: Alignment.center,
              children: [
                if (leaving case final leaving?)
                  Positioned.fill(
                    child: OverflowBox(
                      minWidth: 0,
                      maxWidth: double.infinity,
                      child: Opacity(
                        opacity: (1 - progress).clamp(0, 1),
                        child: row(leaving, style),
                      ),
                    ),
                  ),
                Opacity(opacity: progress.clamp(0, 1), child: child),
              ],
            ),
            child: SingleMotionBuilder(
              motion: FujinMotion.of(context, FujinMotion.pillSettle),
              from: _arrivingScale,
              value: 1,
              builder: (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: row(content, style),
            ),
          ),
        },
      );
      return switch (glass) {
        false => body,
        true => GlassFill(finish: tone.glass, pressable: true, child: body),
      };
    }

    final colors = context.colors;
    Color textOf(PillTone tone) => switch (glass) {
      false => tone.foreground(colors),
      true => tone.glass.foreground(colors),
    };
    return switch (firstTone) {
      null => pill(tone.background(colors), textOf(tone)),
      final first => MotionBuilder<Color>(
        motion: FujinMotion.of(context, FujinMotion.pill),
        converter: MotionConverter.colorRgb,
        from: first.background(colors),
        value: tone.background(colors),
        builder: (context, background, _) => MotionBuilder<Color>(
          motion: FujinMotion.of(context, FujinMotion.pill),
          converter: MotionConverter.colorRgb,
          from: textOf(first),
          value: textOf(tone),
          builder: (context, foreground, _) => pill(background, foreground),
        ),
      ),
    };
  }
}
