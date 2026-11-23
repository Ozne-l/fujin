import 'package:fujin/data/milestones/milestone.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class MilestoneRepository {
  const MilestoneRepository(this._preferences);

  final SharedPreferencesWithCache _preferences;

  bool reached(Milestone milestone) =>
      _preferences.getBool(milestone.preferenceKey) ?? false;

  Future<void> markReached(Milestone milestone) =>
      _preferences.setBool(milestone.preferenceKey, true);
}
