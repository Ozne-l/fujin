import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fujin/pages/chat/chat_files.dart';
import 'package:fujin/pages/chat/widgets/image_arrival.dart';
import 'package:fujin/pages/chat/widgets/media_placeholder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhotoTile extends ConsumerWidget {
  const PhotoTile({required this.url, required this.size, super.key});

  final Uri url;
  final Size size;

  static ImageProvider thumbOf(
    File file, {
    required double width,
    required double ratio,
  }) => ResizeImage.resizeIfNeeded(
    (width * ratio).round(),
    null,
    FileImage(file),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratio = MediaQuery.devicePixelRatioOf(context);
    return switch (ref.watch(chatFileProvider(url))) {
      AsyncValue(value: final file?) => Image(
        image: thumbOf(file, width: size.width, ratio: ratio),
        width: size.width,
        height: size.height,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
        frameBuilder: ImageArrival.frameBuilder,
        errorBuilder: (context, error, stackTrace) =>
            MediaPlaceholder(size: size),
      ),
      AsyncValue() => MediaPlaceholder(size: size),
    };
  }
}
