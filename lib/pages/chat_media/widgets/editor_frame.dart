import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fujin/app/theme/fujin_system_bars.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/chat_media/widgets/editor_header.dart';

class EditorFrame extends StatelessWidget {
  const EditorFrame({
    required this.title,
    required this.position,
    required this.count,
    required this.onDone,
    required this.children,
    super.key,
  });

  final String title;
  final int position;
  final int count;
  final VoidCallback onDone;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FujinSystemBars.camera(colors),
      child: Scaffold(
        backgroundColor: colors.cameraBackground,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: FujinSpace.s1),
              EditorHeader(
                title: title,
                position: position,
                count: count,
                onCancel: () => Navigator.of(context).pop(),
                onDone: onDone,
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
