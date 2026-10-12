import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/adding/widgets/side_state.dart';
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
            dimension: FujinSize.icon,
            child: switch (state) {
              SideState.waiting || SideState.notSent => const Icon(
                Icons.radio_button_unchecked,
                color: FujinColorRole.textDisabled,
              ),
              SideState.writing => const Padding(
                padding: EdgeInsets.all(FujinSpace.s1),
                child: CircularProgressIndicator(
                  strokeWidth: FujinStroke.icon,
                ),
              ),
              SideState.written => const Icon(
                Icons.check_circle,
                color: FujinColorRole.textLink,
              ),
              SideState.failed => const Icon(
                Icons.error,
                color: FujinColorRole.textAlert,
              ),
            },
          ),
        ],
      ),
    );
  }
}
