import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';

part 'mfp_write.mapper.dart';

@MappableClass(discriminatorKey: 'write')
sealed class MfpWrite with MfpWriteMappable {
  const MfpWrite(this.logged);

  final LoggedEntry logged;

  static MfpWrite? of(LoggedEntry logged) =>
      switch ((logged.entry.deletedAt, logged.mfpLink)) {
        (null, null) => MfpAdd(logged),
        (_?, final link?) => MfpDeletion(logged, link),
        (null, final link?) when _differs(logged, link) => MfpEdit(
          logged,
          link,
        ),
        (null, _?) || (_?, null) => null,
      };

  static bool _differs(LoggedEntry logged, MfpLink link) {
    final entry = logged.entry;
    return CalendarDateHook.format(link.date) !=
            CalendarDateHook.format(entry.date) ||
        link.mealName != logged.mealName ||
        link.foodId != logged.mfpFoodId ||
        link.servings != entry.servings ||
        link.servingValue != entry.servingValue ||
        link.servingUnit != entry.servingUnit;
  }
}

@MappableClass(discriminatorValue: 'add')
final class MfpAdd extends MfpWrite with MfpAddMappable {
  const MfpAdd(super.logged);
}

@MappableClass(discriminatorValue: 'edit')
final class MfpEdit extends MfpWrite with MfpEditMappable {
  const MfpEdit(super.logged, this.link);

  final MfpLink link;
}

@MappableClass(discriminatorValue: 'deletion')
final class MfpDeletion extends MfpWrite with MfpDeletionMappable {
  const MfpDeletion(super.logged, this.link);

  final MfpLink link;
}
