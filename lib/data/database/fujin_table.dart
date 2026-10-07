enum FujinTable {
  memoryFood('memory_food'),
  memoryUnit('memory_unit'),
  memoryMeal('memory_meal'),
  sentLink('sent_link');

  const FujinTable(this.sqlName);

  final String sqlName;
}
