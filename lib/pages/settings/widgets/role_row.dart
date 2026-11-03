import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/connectors/role.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_segments.dart';
import 'package:fujin/pages/common/source_dot.dart';

class RoleRow extends StatelessWidget {
  const RoleRow({
    required this.dot,
    required this.name,
    required this.offered,
    required this.role,
    required this.onChoose,
    this.detail,
    super.key,
  });

  final Color dot;
  final String name;
  final List<Role> offered;
  final Role role;
  final ValueChanged<Role> onChoose;
  final String? detail;

  static const _nameFlex = 2;
  static const _choiceFlex = 3;

  static String _label(AppLocalizations intl, Role role) => switch (role) {
    Role.twoWay => intl.roleTwoWay,
    Role.receiveOnly => intl.roleReceiveOnly,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        FujinSpace.s5,
        FujinSpace.s3 - FujinSegments.outset,
        FujinSpace.s5,
        FujinSpace.s3 - FujinSegments.outset,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSize.controlNoteGap - FujinSegments.outset,
        children: [
          Row(
            spacing: FujinSpace.s3,
            children: [
              SourceDot(color: dot),
              Expanded(
                flex: _nameFlex,
                child: Text(
                  name,
                  style: FujinText.inter15Medium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                flex: _choiceFlex,
                child: IgnorePointer(
                  ignoring: offered.length == 1,
                  child: FujinSegments(
                    position: offered.indexOf(role).toDouble(),
                    motion: FujinMotion.tabSlide,
                    labels: [
                      for (final choice in offered)
                        _label(context.intl, choice),
                    ],
                    onSelect: (index, _) => onChoose(offered[index]),
                  ),
                ),
              ),
            ],
          ),
          if (detail case final detail?)
            Padding(
              padding: const EdgeInsets.only(bottom: FujinSegments.outset),
              child: Text(
                detail,
                style: FujinText.inter13Regular.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
