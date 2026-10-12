enum FujinTable {
  memoryFood('memory_food'),
  memoryOwnCopy('memory_own_copy'),
  memoryUnit('memory_unit'),
  memoryMeal('memory_meal'),
  sentLink('sent_link'),
  goals('goals'),
  unattendedItem('unattended_item');

  const FujinTable(this.sqlName);

  final String sqlName;
}
