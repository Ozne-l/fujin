import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/source_dot.dart';

class AddSectionLabel extends StatelessWidget {
  const AddSectionLabel({
    required this.label,
    this.trailing,
    this.dot,
    super.key,
  });

  final String label;
  final String? trailing;
  final Color? dot;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: FujinSize.textInset),
    child: Row(
      spacing: FujinSpace.s2,
      children: [
        if (dot case final dot?) SourceDot(color: dot),
        Expanded(
          child: Text(
            label,
            style: FujinText.inter12Medium.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
        if (trailing case final trailing?)
          Text(
            trailing,
            style: FujinText.inter12Regular.copyWith(
              color: context.colors.textTertiary,
            ),
          ),
      ],
    ),
  );
}
