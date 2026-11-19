final class UploadNotice {
  const UploadNotice({
    required this.conversationId,
    required this.coach,
    required this.count,
  });

  final String conversationId;
  final String? coach;
  final int count;
}
