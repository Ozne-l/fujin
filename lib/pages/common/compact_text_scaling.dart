import 'package:flutter/widgets.dart';

class CompactTextScaling extends StatelessWidget {
  const CompactTextScaling({required this.child, super.key});

  static const _maxScaleFactor = 1.3;

  final Widget child;

  @override
  Widget build(BuildContext context) => MediaQuery.withClampedTextScaling(
    maxScaleFactor: _maxScaleFactor,
    child: child,
  );
}
