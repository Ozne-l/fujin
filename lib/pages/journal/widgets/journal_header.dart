import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/appearance_corner.dart';
import 'package:fujin/pages/common/edge_blur.dart';
import 'package:fujin/pages/common/header_layout.dart';
import 'package:fujin/pages/common/text_inset.dart';
import 'package:fujin/pages/common/title_text.dart';
import 'package:fujin/pages/journal/widgets/journal_brand.dart';

class JournalHeader extends StatelessWidget {
  const JournalHeader({
    required this.day,
    required this.today,
    required this.scrolled,
    required this.band,
    this.link,
    super.key,
  });

  final DateTime day;
  final DateTime today;
  final ValueListenable<double> scrolled;
  final Widget band;
  final (String, VoidCallback)? link;

  static const double _edge = 0;
  static const double _rest = 0;
  static const double _hidden = 0;
  static const double _shown = 1;

  @override
  Widget build(BuildContext context) {
    final brand = JournalBrand.extent(context);
    final title = switch (day == today) {
      true => context.intl.journalToday,
      false => TitleText.capitalized(context.intl.journalMonth(day)),
    };
    final statusBar = MediaQuery.paddingOf(context).top;
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: scrolled,
          builder: (context, scrolled, _) {
            if (scrolled <= _rest) return const SizedBox.shrink();
            final (height, bottom) = switch (scrolled < brand) {
              true => (
                statusBar + math.min(scrolled, FujinSize.scrollEdgeFade),
                null,
              ),
              false => (
                null,
                brand - math.min(scrolled - brand, FujinSize.scrollEdgeFade),
              ),
            };
            return Positioned(
              top: _edge,
              left: _edge,
              right: _edge,
              height: height,
              bottom: bottom,
              child: const EdgeBlur(),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: scrolled,
          builder: (context, scrolled, header) => Transform.translate(
            offset: Offset(_edge, -math.min(scrolled, brand)),
            child: header,
          ),
          child: HeaderLayout.shield(
            Padding(
              padding: EdgeInsets.only(
                top: statusBar + brand + AppearanceCorner.top,
                bottom: FujinSpace.s3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: FujinSpace.s3,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FujinSize.screenMargin,
                    ),
                    child: TextInset(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: FujinSize.touchTarget,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: OverflowBar(
                            alignment: MainAxisAlignment.spaceBetween,
                            overflowAlignment: OverflowBarAlignment.end,
                            spacing: FujinSpace.s3,
                            children: [
                              Text(
                                title,
                                style: FujinText.hina30.copyWith(
                                  color: context.colors.textPrimary,
                                ),
                              ),
                              if (link case (final label, final onTap))
                                ValueListenableBuilder(
                                  valueListenable: scrolled,
                                  builder: (context, scrolled, child) {
                                    final hidden = (scrolled / brand).clamp(
                                      _hidden,
                                      _shown,
                                    );
                                    return Visibility(
                                      visible: hidden < _shown,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Opacity(
                                        opacity: _shown - hidden,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: TextButton(
                                    onPressed: onTap,
                                    style: TextButton.styleFrom(
                                      textStyle: FujinText.inter13Medium,
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Text(label),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  band,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
