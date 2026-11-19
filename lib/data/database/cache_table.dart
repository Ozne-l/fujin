import 'package:fujin/data/database/database_table.dart';

enum CacheTable implements DatabaseTable {
  conversation('chat_conversation'),
  message('chat_message'),
  messageInProgress('chat_message_in_progress'),
  fileInProgress('chat_file_in_progress'),
  foreground('chat_foreground'),
  owner('chat_owner');

  const CacheTable(this.sqlName);

  @override
  final String sqlName;
}
