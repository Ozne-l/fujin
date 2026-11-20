import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

({T value, void Function(T Function(T value) change) settle}) useLingering<T>(
  T Function(T? held) merge,
) {
  final (value, lingering) = use(_LingeringHook(merge));
  return (value: value, settle: lingering.settle);
}

final class _LingeringHook<T> extends Hook<(T, _LingeringState<T>)> {
  const _LingeringHook(this.merge);

  final T Function(T? held) merge;

  @override
  _LingeringState<T> createState() => _LingeringState();
}

final class _LingeringState<T>
    extends HookState<(T, _LingeringState<T>), _LingeringHook<T>> {
  ({T value})? _held;

  @override
  (T, _LingeringState<T>) build(BuildContext context) {
    final value = hook.merge(_held?.value);
    _held = (value: value);
    return (value, this);
  }

  void settle(T Function(T value) change) {
    if (_held case (:final value)) {
      setState(() => _held = (value: change(value)));
    }
  }
}
