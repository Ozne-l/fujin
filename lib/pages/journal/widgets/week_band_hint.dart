import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

class WeekBandHint extends StatelessWidget {
  const WeekBandHint({super.key});

  static const _arrowIcon = 'assets/icons/arrow.svg';

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsetsDirectional.only(start: FujinSize.hintPointerInset),
        child: CustomPaint(
          size: Size(FujinSize.hintPointerWidth, FujinSize.hintPointerHeight),
          painter: _Pointer(),
        ),
      ),
      DecoratedBox(
        decoration: BoxDecoration(
          color: FujinColorRole.backgroundDark,
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
                theme: const SvgTheme(currentColor: FujinColorRole.textOnDark),
                excludeFromSemantics: true,
              ),
              Flexible(
                child: Text(
                  AppLocalizations.of(context).weekBandHint,
                  style: FujinText.inter13Medium.copyWith(
                    color: FujinColorRole.textOnDark,
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
  const _Pointer();

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(
    Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close(),
    Paint()..color = FujinColorRole.backgroundDark,
  );

  @override
  bool shouldRepaint(_Pointer oldDelegate) => false;
}
