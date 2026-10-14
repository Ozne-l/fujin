import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/memory/memory_segment.dart';

class MemorySegments extends StatelessWidget {
  const MemorySegments({
    required this.pages,
    required this.labelOf,
    super.key,
  });

  final PageController pages;
  final String Function(MemorySegment segment) labelOf;

  static const double _segmentRadius =
      FujinSize.controlHeight / 2 - FujinSpace.s1;
  static final int _lastIndex = MemorySegment.values.length - 1;

  double get _page => switch (pages.hasClients) {
    true when pages.position.hasContentDimensions =>
      pages.page ?? pages.initialPage.toDouble(),
    _ => pages.initialPage.toDouble(),
  };

  void _select(BuildContext context, MemorySegment segment) {
    if (_page == segment.index) return;
    unawaited(HapticFeedback.selectionClick());
    unawaited(FujinMotion.turnPage(context, pages, segment.index));
  }

  @override
  Widget build(BuildContext context) => Container(
    height: FujinSize.controlHeight,
    padding: const EdgeInsets.all(FujinSpace.s1),
    decoration: BoxDecoration(
      color: FujinColorRole.borderCard,
      borderRadius: BorderRadius.circular(FujinSize.controlHeight / 2),
    ),
    child: ListenableBuilder(
      listenable: pages,
      builder: (context, _) {
        final page = _page.clamp(0, _lastIndex).toDouble();
        return Stack(
          children: [
            Align(
              alignment: Alignment(page / _lastIndex * 2 - 1, 0),
              child: FractionallySizedBox(
                widthFactor: 1 / MemorySegment.values.length,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: FujinColorRole.backgroundCard,
                    borderRadius: BorderRadius.circular(_segmentRadius),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                for (final segment in MemorySegment.values)
                  Expanded(
                    child: _Segment(
                      label: labelOf(segment),
                      active: (1 - (page - segment.index).abs()).clamp(0, 1),
                      onTap: () => _select(context, segment),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
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
  final double active;
  final VoidCallback onTap;

  static const double _selectedFrom = 0.5;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: active >= _selectedFrom,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Text(
          label,
          style: FujinText.inter14Medium.copyWith(
            color: Color.alphaBlend(
              FujinColorRole.textPrimary.withValues(alpha: active),
              FujinColorRole.textSecondary,
            ),
          ),
        ),
      ),
    ),
  );
}
