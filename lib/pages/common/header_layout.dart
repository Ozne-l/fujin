import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HeaderLayout extends StatelessWidget {
  const HeaderLayout({required this.header, required this.body, super.key});

  final Widget header;
  final Widget Function(BuildContext context, double extent) body;

  static Widget shield(Widget child) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    excludeFromSemantics: true,
    onTap: _keep,
    child: child,
  );

  static void _keep() {}

  @override
  Widget build(BuildContext context) => CustomMultiChildLayout(
    delegate: _HeaderDelegate(),
    children: [
      LayoutId(
        id: _Slot.body,
        child: LayoutBuilder(
          builder: (context, constraints) => body(
            context,
            switch (constraints) {
              _BodyConstraints(:final extent) => extent,
              BoxConstraints() => _HeaderDelegate.none,
            },
          ),
        ),
      ),
      LayoutId(
        id: _Slot.header,
        child: _PassThrough(child: header),
      ),
    ],
  );
}

enum _Slot { header, body }

class _HeaderDelegate extends MultiChildLayoutDelegate {
  _HeaderDelegate();

  static const double none = 0;

  @override
  void performLayout(Size size) {
    final header = layoutChild(
      _Slot.header,
      BoxConstraints.tightFor(width: size.width),
    );
    layoutChild(_Slot.body, _BodyConstraints(size, extent: header.height));
    positionChild(_Slot.header, Offset.zero);
    positionChild(_Slot.body, Offset.zero);
  }

  @override
  bool shouldRelayout(_HeaderDelegate oldDelegate) => false;
}

class _BodyConstraints extends BoxConstraints {
  _BodyConstraints(super.size, {required this.extent}) : super.tight();

  final double extent;

  @override
  bool operator ==(Object other) =>
      other is _BodyConstraints && other.extent == extent && super == other;

  @override
  int get hashCode => Object.hash(super.hashCode, extent);
}

class _PassThrough extends SingleChildRenderObjectWidget {
  const _PassThrough({required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderPassThrough();
}

class _RenderPassThrough extends RenderProxyBox {
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    super.hitTest(result, position: position);
    return false;
  }
}
