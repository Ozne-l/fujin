import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/pages/tabs/fujin_tab.dart';
import 'package:fujin/pages/tabs/messages_item.dart';

part 'tab_slot.mapper.dart';

@MappableClass(discriminatorKey: 'slot')
sealed class TabSlot with TabSlotMappable {
  const TabSlot();

  static List<TabSlot> of({required MessagesItem? messages}) => [
    for (final tab in FujinTab.values) ...[
      if ((messages, tab) case (final item?, FujinTab.settings))
        MessagesSlot(item),
      BranchSlot(tab),
    ],
  ];
}

@MappableClass(discriminatorValue: 'branch')
final class BranchSlot extends TabSlot with BranchSlotMappable {
  const BranchSlot(this.tab);

  final FujinTab tab;
}

@MappableClass(discriminatorValue: 'messages')
final class MessagesSlot extends TabSlot with MessagesSlotMappable {
  const MessagesSlot(this.item);

  final MessagesItem item;
}
