import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/chat/chat_files.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhotoTile extends ConsumerWidget {
  const PhotoTile({required this.url, required this.size, super.key});

  final Uri url;
  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratio = MediaQuery.devicePixelRatioOf(context);
    return switch (ref.watch(chatFileProvider(url))) {
      AsyncValue(value: final file?) => Image.file(
        file,
        width: size.width,
        height: size.height,
        fit: BoxFit.cover,
        cacheWidth: (size.width * ratio).round(),
        excludeFromSemantics: true,
        errorBuilder: (context, error, stackTrace) => _Blank(size: size),
      ),
      AsyncValue() => _Blank(size: size),
    };
  }
}

class _Blank extends StatelessWidget {
  const _Blank({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: size,
    child: ColoredBox(color: context.colors.backgroundNeutral),
  );
}
