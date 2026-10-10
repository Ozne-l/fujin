import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/memory/memory_segment.dart';

class MemorySegments extends StatelessWidget {
  const MemorySegments({
    required this.selected,
    required this.labelOf,
    required this.onSelect,
    super.key,
  });

  final MemorySegment selected;
  final String Function(MemorySegment segment) labelOf;
  final ValueChanged<MemorySegment> onSelect;

  static const double _segmentRadius =
      FujinSize.controlHeight / 2 - FujinSpace.s1;

  @override
  Widget build(BuildContext context) => Container(
    height: FujinSize.controlHeight,
    padding: const EdgeInsets.all(FujinSpace.s1),
    decoration: BoxDecoration(
      color: FujinColorRole.borderCard,
      borderRadius: BorderRadius.circular(FujinSize.controlHeight / 2),
    ),
    child: Row(
      children: [
        for (final segment in MemorySegment.values)
          Expanded(
            child: _Segment(
              label: labelOf(segment),
              active: segment == selected,
              onTap: () => onSelect(segment),
            ),
          ),
      ],
    ),
  );
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: active,
    child: Material(
      color: active ? FujinColorRole.backgroundCard : Colors.transparent,
      borderRadius: BorderRadius.circular(MemorySegments._segmentRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(MemorySegments._segmentRadius),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: FujinText.inter14Medium.copyWith(
              color: active
                  ? FujinColorRole.textPrimary
                  : FujinColorRole.textSecondary,
            ),
          ),
        ),
      ),
    ),
  );
}
