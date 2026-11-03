import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/clock_icon.dart';
import 'package:fujin/pages/common/pill_size.dart';
import 'package:motor/motor.dart';

class ConnectorPill extends StatelessWidget {
  const ConnectorPill({
    required this.connector,
    required this.failed,
    super.key,
  });

  static const PillSize _size = PillSize.small;

  final Connector connector;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final intl = context.intl;
    final (color, label, semantics) = switch (connector) {
      Connector.mfp => (
        context.colors.sourceMfp,
        intl.pillMfp,
        intl.mfpPendingSemantics,
      ),
      Connector.ekklo => (
        context.colors.sourceEkklo,
        intl.sourceEkklo,
        intl.ekkloPendingSemantics,
      ),
    };
    final theme = SvgTheme(currentColor: color);
    final hand = SvgPicture.asset(
      ClockIcon.hand,
      width: FujinSize.pillSmallIcon,
      height: FujinSize.pillSmallIcon,
      theme: theme,
    );
    return Semantics(
      label: semantics,
      child: ExcludeSemantics(
        child: Container(
          height: _size.height,
          padding: EdgeInsets.symmetric(horizontal: _size.inset),
          decoration: BoxDecoration(
            color: context.colors.backgroundCard,
            borderRadius: BorderRadius.circular(FujinRadius.pill),
            border: Border.all(color: color),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: FujinSpace.s1,
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    ClockIcon.face,
                    width: FujinSize.pillSmallIcon,
                    height: FujinSize.pillSmallIcon,
                    theme: theme,
                  ),
                  switch (failed || FujinMotion.reduced(context)) {
                    true => hand,
                    false => SequenceMotionBuilder<int, double>(
                      sequence: FujinMotion.clockTurns,
                      converter: MotionConverter.single,
                      builder: (context, turns, _, child) =>
                          Transform.rotate(angle: turns * 2 * pi, child: child),
                      child: hand,
                    ),
                  },
                ],
              ),
              Text(label, style: _size.style.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
