enum DevChatAsset {
  plate('plate.jpg'),
  board('board.jpg'),
  shapes('shapes.png'),
  squat('squat.mp4'),
  stretch('stretch.mp4'),
  voice('voice.m4a'),
  voiceNote('voice-note.mp4');

  const DevChatAsset(this.fileName);

  static const folder = 'assets/dev_chat/';

  final String fileName;

  String get key => '$folder$fileName';

  static DevChatAsset? named(String fileName) =>
      values.where((asset) => asset.fileName == fileName).firstOrNull;
}
