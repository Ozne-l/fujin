import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';

class WeekBandHint extends StatelessWidget {
  const WeekBandHint({super.key});

  static const _arrowIcon = 'assets/icons/arrow.svg';

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.only(
          start: FujinSize.hintPointerInset,
        ),
        child: CustomPaint(
          size: const Size(
            FujinSize.hintPointerWidth,
            FujinSize.hintPointerHeight,
          ),
          painter: _Pointer(context.colors.backgroundDark),
        ),
      ),
      DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.backgroundDark,
          borderRadius: BorderRadius.circular(FujinRadius.hint),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            FujinSpace.s3,
            FujinSize.hintPaddingVertical,
            FujinSize.hintPaddingEnd,
            FujinSize.hintPaddingVertical,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: FujinSpace.s2,
            children: [
              SvgPicture.asset(
                _arrowIcon,
                width: FujinSize.hintIcon,
                height: FujinSize.hintIcon,
                theme: SvgTheme(currentColor: context.colors.textOnDark),
                excludeFromSemantics: true,
              ),
              Flexible(
                child: Text(
                  context.intl.weekBandHint,
                  style: FujinText.inter13Medium.copyWith(
                    color: context.colors.textOnDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _Pointer extends CustomPainter {
  const _Pointer(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(
    Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close(),
    Paint()..color = color,
  );

  @override
  bool shouldRepaint(_Pointer oldDelegate) => oldDelegate.color != color;
}
