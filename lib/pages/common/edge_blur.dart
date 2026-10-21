import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_glass.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_blur/progressive_blur.dart';

class EdgeBlur extends ConsumerWidget {
  const EdgeBlur({super.key});

  static const double _sigma = 6;
  static const double _wash = 0;
  static const double _full = 1;
  static const double _none = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = context.colors.backgroundPage;
    final blurs =
        ui.ImageFilter.isShaderFilterSupported &&
        !FujinGlass.reduced(context, ref);
    final ratio = MediaQuery.devicePixelRatioOf(context);
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          if (size.isEmpty) return const SizedBox.shrink();
          final stops = [
            _none,
            math.max(_none, _full - FujinSize.scrollEdgeFade / size.height),
            _full,
          ];
          Widget wash(double alpha) => DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  page.withValues(alpha: alpha),
                  page.withValues(alpha: alpha),
                  page.withValues(alpha: _none),
                ],
                stops: stops,
              ),
            ),
          );
          return switch (blurs) {
            true => Stack(
              fit: StackFit.expand,
              children: [
                ProgressiveBackdropBlur(
                  sigma: _sigma * ratio,
                  backgroundColor: page,
                  linearGradientBlur: LinearGradientBlur(
                    values: const [_full, _full, _none],
                    stops: stops,
                    start: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  bands: [Offset.zero & size],
                ),
                wash(_wash),
              ],
            ),
            false => wash(_full),
          };
        },
      ),
    );
  }
}
