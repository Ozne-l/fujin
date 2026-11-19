import 'dart:io';

Future<void> forgetFile(String path) async {
  try {
    await File(path).delete();
  } on FileSystemException {
    return;
  }
}
