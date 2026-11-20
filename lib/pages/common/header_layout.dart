import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HeaderLayout extends StatelessWidget {
  const HeaderLayout({
    required this.header,
    required this.body,
    this.footer,
    super.key,
  });

  final Widget header;
  final Widget? footer;
  final Widget Function(BuildContext context, double top, double bottom) body;

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
          builder: (context, constraints) => switch (constraints) {
            _BodyConstraints(:final top, :final bottom) => body(
              context,
              top,
              bottom,
            ),
            BoxConstraints() => body(
              context,
              _HeaderDelegate.none,
              _HeaderDelegate.none,
            ),
          },
        ),
      ),
      LayoutId(
        id: _Slot.header,
        child: _PassThrough(child: header),
      ),
      if (footer case final footer?) LayoutId(id: _Slot.footer, child: footer),
    ],
  );
}

enum _Slot { header, body, footer }

class _HeaderDelegate extends MultiChildLayoutDelegate {
  _HeaderDelegate();

  static const double none = 0;

  @override
  void performLayout(Size size) {
    final header = layoutChild(
      _Slot.header,
      BoxConstraints.tightFor(width: size.width),
    );
    final footer = switch (hasChild(_Slot.footer)) {
      true => layoutChild(
        _Slot.footer,
        BoxConstraints.tightFor(width: size.width),
      ),
      false => Size.zero,
    };
    layoutChild(
      _Slot.body,
      _BodyConstraints(size, top: header.height, bottom: footer.height),
    );
    positionChild(_Slot.header, Offset.zero);
    positionChild(_Slot.body, Offset.zero);
    if (hasChild(_Slot.footer)) {
      positionChild(_Slot.footer, Offset(none, size.height - footer.height));
    }
  }

  @override
  bool shouldRelayout(_HeaderDelegate oldDelegate) => false;
}

class _BodyConstraints extends BoxConstraints {
  _BodyConstraints(super.size, {required this.top, required this.bottom})
    : super.tight();

  final double top;
  final double bottom;

  @override
  bool operator ==(Object other) =>
      other is _BodyConstraints &&
      other.top == top &&
      other.bottom == bottom &&
      super == other;

  @override
  int get hashCode => Object.hash(super.hashCode, top, bottom);
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
