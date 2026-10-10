import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class GoalField extends StatelessWidget {
  const GoalField({
    required this.label,
    required this.unit,
    required this.controller,
    required this.onChanged,
    this.hint,
    super.key,
  });

  final String label;
  final String unit;
  final String? hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    textInputAction: TextInputAction.next,
    textAlign: TextAlign.end,
    style: FujinText.inter16Regular.copyWith(
      color: FujinColorRole.textPrimary,
    ),
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: FujinSpace.s4,
          end: FujinSpace.s2,
        ),
        child: Text(
          label,
          style: FujinText.inter15Medium.copyWith(
            color: FujinColorRole.textPrimary,
          ),
        ),
      ),
      prefixIconConstraints: const BoxConstraints(),
      suffixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: FujinSpace.s2,
          end: FujinSpace.s4,
        ),
        child: Text(
          unit,
          style: FujinText.inter14Regular.copyWith(
            color: FujinColorRole.textSecondary,
          ),
        ),
      ),
      suffixIconConstraints: const BoxConstraints(),
    ),
  );
}
