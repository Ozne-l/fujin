import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

class WeekBand extends StatelessWidget {
  const WeekBand({
    required this.week,
    required this.selected,
    required this.today,
    required this.onSelect,
    super.key,
  });

  final List<DateTime> week;
  final DateTime selected;
  final DateTime today;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: FujinSize.margeEcran),
    child: Row(
      children: [
        for (final day in week)
          Expanded(
            child: _Day(
              day: day,
              state: switch ((day == selected, day.isAfter(today))) {
                (true, _) => _DayState.selected,
                (false, true) => _DayState.upcoming,
                (false, false) => _DayState.past,
              },
              onTap: switch (day.isAfter(today)) {
                true => null,
                false => () => onSelect(day),
              },
            ),
          ),
      ],
    ),
  );
}

enum _DayState { selected, past, upcoming }

class _Day extends StatelessWidget {
  const _Day({required this.day, required this.state, required this.onTap});

  final DateTime day;
  final _DayState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = switch (state) {
      _DayState.selected => FujinText.inter11Semibold.copyWith(
        color: FujinRole.textePrincipal,
      ),
      _DayState.past || _DayState.upcoming => FujinText.inter11Regular.copyWith(
        color: FujinRole.texteSecondaire,
      ),
    };
    final date = FujinText.inter13Medium.copyWith(
      color: switch (state) {
        _DayState.selected => FujinRole.fondPage,
        _DayState.past => FujinRole.textePrincipal,
        _DayState.upcoming => FujinRole.texteInactif,
      },
    );
    return InkResponse(
      onTap: onTap,
      radius: FujinSize.anneauJour / 2,
      child: Column(
        spacing: FujinSpace.s2,
        children: [
          Text(l10n.weekdayShort(day), style: label),
          Container(
            width: FujinSize.anneauJour,
            height: FujinSize.anneauJour,
            alignment: Alignment.center,
            decoration: switch (state) {
              _DayState.upcoming => null,
              _DayState.selected || _DayState.past => BoxDecoration(
                shape: BoxShape.circle,
                color: FujinRole.fondCarte,
                border: Border.all(
                  color: FujinRole.objectifPiste,
                  width: FujinStroke.anneauJour,
                ),
              ),
            },
            child: Container(
              width: FujinSize.pastilleJour,
              height: FujinSize.pastilleJour,
              alignment: Alignment.center,
              decoration: switch (state) {
                _DayState.selected => const BoxDecoration(
                  shape: BoxShape.circle,
                  color: FujinRole.objectifJourChoisi,
                ),
                _DayState.past || _DayState.upcoming => null,
              },
              child: Text(l10n.dayOfMonth(day), style: date),
            ),
          ),
        ],
      ),
    );
  }
}
