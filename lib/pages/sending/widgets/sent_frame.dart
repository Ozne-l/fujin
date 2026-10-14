import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/send_report.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_weather.dart';
import 'package:fujin/pages/common/fujin_weather_glyph.dart';
import 'package:fujin/pages/common/gold_separator.dart';
import 'package:fujin/pages/common/seigaiha_band.dart';
import 'package:fujin/pages/sending/widgets/send_footer.dart';
import 'package:go_router/go_router.dart';

class SentFrame extends StatelessWidget {
  const SentFrame({
    required this.report,
    required this.note,
    required this.children,
    super.key,
  });

  final SendReport report;
  final String note;
  final List<Widget> children;

  static Widget card(List<Widget> rows, {double dividerIndent = 0}) =>
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: FujinSpace.s4,
          vertical: FujinSpace.s1,
        ),
        decoration: BoxDecoration(
          color: FujinColorRole.backgroundCard,
          borderRadius: BorderRadius.circular(FujinRadius.card),
          border: Border.all(color: FujinColorRole.borderCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, row) in rows.indexed) ...[
              if (index > 0)
                Padding(
                  padding: EdgeInsetsDirectional.only(start: dividerIndent),
                  child: const Divider(),
                ),
              row,
            ],
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const PositionedDirectional(
          start: 0,
          end: 0,
          bottom: 0,
          child: SeigaihaBand(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  FujinSize.screenMargin,
                  FujinSpace.s8 + FujinSpace.s3,
                  FujinSize.screenMargin,
                  FujinSpace.s6,
                ),
                children: [
                  const Center(
                    child: FujinWeatherGlyph(
                      weather: FujinWeather.calm,
                      side: FujinSize.glyphHero,
                    ),
                  ),
                  const SizedBox(height: FujinSpace.s4),
                  Text(
                    context.intl.sentTitle,
                    textAlign: TextAlign.center,
                    style: FujinText.hina44.copyWith(
                      color: FujinColorRole.textLink,
                    ),
                  ),
                  const SizedBox(height: FujinSpace.s5),
                  Text(
                    context.intl.sentDetail(report.sent),
                    textAlign: TextAlign.center,
                    style: FujinText.inter15Medium.copyWith(
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                  const SizedBox(height: FujinSpace.s1),
                  Text(
                    note,
                    textAlign: TextAlign.center,
                    style: FujinText.inter13Regular.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
                  const SizedBox(height: FujinSpace.s5),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: FujinSize.textInset - FujinSize.screenMargin,
                    ),
                    child: GoldSeparator(volute: true),
                  ),
                  ...children,
                ],
              ),
            ),
            SendFooter(
              child: FilledButton(
                onPressed: context.pop,
                child: Text(context.intl.backToJournal),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
