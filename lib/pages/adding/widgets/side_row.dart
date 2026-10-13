import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/adding/widgets/side_state.dart';
import 'package:fujin/pages/common/fujin_spinner.dart';
import 'package:fujin/pages/common/progress_ring.dart';
import 'package:fujin/pages/common/source_dot.dart';

class SideRow extends StatelessWidget {
  const SideRow({
    required this.label,
    required this.dot,
    required this.state,
    required this.meal,
    super.key,
  });

  final String label;
  final Color dot;
  final SideState state;
  final String meal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (status, color) = switch (state) {
      SideState.waiting => (l10n.rowWaiting, FujinColorRole.textSecondary),
      SideState.writing => (l10n.addWriting, FujinColorRole.textPrimary),
      SideState.written => (l10n.addWrittenIn(meal), FujinColorRole.textLink),
      SideState.failed => (l10n.addNotWritten, FujinColorRole.textAlert),
      SideState.notSent => (l10n.addNotSent, FujinColorRole.textSecondary),
    };
    return SizedBox(
      height: FujinSize.touchTarget + FujinSpace.s2,
      child: Row(
        spacing: FujinSpace.s3,
        children: [
          SourceDot(color: dot),
          Expanded(
            child: Text(
              label,
              style: FujinText.inter15Medium.copyWith(
                color: FujinColorRole.textPrimary,
              ),
            ),
          ),
          Text(status, style: FujinText.inter13Medium.copyWith(color: color)),
          SizedBox.square(
            dimension: FujinSize.spinner,
            child: switch (state) {
              SideState.waiting || SideState.notSent => const ProgressRing(
                size: FujinSize.spinner,
                stroke: FujinStroke.radio,
                track: FujinColorRole.textDisabled,
                child: SizedBox.shrink(),
              ),
              SideState.writing => const FujinSpinner.card(),
              SideState.written => const _Disc(
                color: FujinColorRole.textLink,
                icon: Icons.check,
              ),
              SideState.failed => const _Disc(
                color: FujinColorRole.textAlert,
                icon: Icons.priority_high,
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _Disc extends StatelessWidget {
  const _Disc({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: Icon(
      icon,
      size: FujinSize.stepIcon,
      color: FujinColorRole.textOnDark,
    ),
  );
}
