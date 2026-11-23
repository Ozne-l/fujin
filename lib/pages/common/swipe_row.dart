import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/row_action.dart';
import 'package:fujin/pages/common/trash_icon.dart';

class SwipeRow extends HookWidget {
  const SwipeRow({
    required this.groupTag,
    required this.enabled,
    required this.label,
    required this.onRemove,
    required this.child,
    required Key super.key,
  });

  static const double _openShare = 0.35;
  static const double _closed = 0;

  final Object groupTag;
  final bool enabled;
  final String label;
  final VoidCallback onRemove;
  final Widget child;

  static Widget group({required Widget child}) =>
      SlidableAutoCloseBehavior(child: child);

  @override
  Widget build(BuildContext context) {
    final vsync = useSingleTickerProvider();
    final controller = useMemoized(() => SlidableController(vsync), [vsync]);
    useEffect(() => controller.dispose, [controller]);
    final reveal = useMemoized(
      () => controller.animation.drive(
        Animatable<double>.fromCallback(
          (ratio) => (ratio / _openShare).clamp(0, 1),
        ),
      ),
      [controller],
    );

    void close() {
      if (controller.ratio != _closed) unawaited(controller.close());
    }

    void remove() {
      close();
      onRemove();
    }

    return Semantics(
      customSemanticsActions: switch (enabled) {
        true => {CustomSemanticsAction(label: label): onRemove},
        false => null,
      },
      child: TapRegion(
        onTapOutside: (_) => close(),
        child: ClipRect(
          child: Slidable(
            key: key,
            controller: controller,
            groupTag: groupTag,
            enabled: enabled,
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              extentRatio: _openShare,
              dismissible: DismissiblePane(
                onDismissed: () {},
                closeOnCancel: true,
                confirmDismiss: () async {
                  onRemove();
                  return false;
                },
              ),
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: FujinSpace.s4,
                    ),
                    child: RowAction(
                      label: label,
                      icon: TrashIcon.asset,
                      reveal: reveal,
                      onPressed: remove,
                    ),
                  ),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
