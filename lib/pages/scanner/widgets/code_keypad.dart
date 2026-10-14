import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';

class CodeKeypad extends StatelessWidget {
  const CodeKeypad({required this.onDigit, required this.onErase, super.key});

  static const _rows = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];
  static const _zero = 0;

  final ValueChanged<int> onDigit;
  final VoidCallback onErase;

  @override
  Widget build(BuildContext context) {
    Widget digit(int value) => _Key(
      onTap: () => onDigit(value),
      child: Text(
        '$value',
        style: FujinText.inter22Regular.copyWith(
          color: FujinColorRole.textPrimary,
        ),
      ),
    );
    return ColoredBox(
      color: FujinColorRole.borderCard,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(FujinSpace.s2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: FujinSpace.s2,
            children: [
              for (final row in _rows)
                Row(
                  spacing: FujinSpace.s2,
                  children: [
                    for (final value in row) Expanded(child: digit(value)),
                  ],
                ),
              Row(
                spacing: FujinSpace.s2,
                children: [
                  const Spacer(),
                  Expanded(child: digit(_zero)),
                  Expanded(
                    child: _Key(
                      onTap: onErase,
                      label: context.intl.scannerErase,
                      child: const Icon(
                        Icons.backspace_outlined,
                        size: FujinSize.icon,
                        color: FujinColorRole.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.onTap, required this.child, this.label});

  final VoidCallback onTap;
  final Widget child;
  final String? label;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: Material(
      color: FujinColorRole.backgroundCard,
      borderRadius: BorderRadius.circular(FujinRadius.key),
      child: InkWell(
        borderRadius: BorderRadius.circular(FujinRadius.key),
        onTap: onTap,
        child: SizedBox(
          height: FujinSize.buttonMedium,
          child: Center(child: child),
        ),
      ),
    ),
  );
}
