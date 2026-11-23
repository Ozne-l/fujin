import 'dart:async';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/app/theme/instant_motion.dart';
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/domain/chat/chat_service.dart';
import 'package:fujin/domain/chat/upload/message_upload.dart';
import 'package:fujin/domain/chat/upload/upload_phase.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat/conversation_view.dart';
import 'package:fujin/pages/chat/message_delivery.dart';
import 'package:fujin/pages/chat/thread_item.dart';
import 'package:fujin/pages/chat/upload/upload_bubble.dart';
import 'package:fujin/pages/chat/widgets/day_separator.dart';
import 'package:fujin/pages/chat/widgets/jump_to_bottom_button.dart';
import 'package:fujin/pages/chat/widgets/message_actions.dart';
import 'package:fujin/pages/chat/widgets/message_content.dart';
import 'package:fujin/pages/chat/widgets/message_gestures.dart';
import 'package:fujin/pages/chat/widgets/message_row.dart';
import 'package:fujin/pages/chat/widgets/message_status.dart';
import 'package:fujin/pages/chat/widgets/message_time.dart';
import 'package:fujin/pages/chat/widgets/older_messages_loader.dart';
import 'package:fujin/pages/chat/widgets/reply_quote.dart';
import 'package:fujin/pages/chat/widgets/send_flight.dart';
import 'package:go_router/go_router.dart';
import 'package:motor/motor.dart';

class ThreadList extends HookWidget {
  const ThreadList({
    required this.view,
    required this.top,
    required this.bottom,
    required this.coachName,
    required this.onOlder,
    required this.now,
    required this.flight,
    required this.onReply,
    required this.onRetry,
    required this.onRetryUpload,
    required this.onReact,
    required this.onActions,
    super.key,
  });

  final ConversationView view;
  final double top;
  final double bottom;
  final String coachName;
  final VoidCallback onOlder;
  final DateTime now;
  final SendFlight flight;
  final ValueChanged<EkkloMessage>? onReply;
  final ValueChanged<String> onRetry;
  final ValueChanged<String> onRetryUpload;
  final void Function(EkkloMessage message, String emoji) onReact;
  final void Function(ThreadMessage item, Rect bubble, Widget content)
  onActions;

  static const double _bottomSlop = FujinSpace.s2;
  static const double _glideScreens = 3;
  static const double _revealAlignment = 0.5;
  static const int _smoothReach = 25;
  static const int _seekLimit = 24;

  bool _nearTop(ScrollMetrics metrics) =>
      metrics.extentAfter < metrics.viewportDimension;

  static bool _atBottom(ScrollPosition position) =>
      position.pixels <= _bottomSlop;

  Widget? _quote(ThreadMessage item) => switch (item.message.replyTo) {
    null => null,
    final reply => ReplyQuote(
      reply: reply,
      mine: item.quotesMine,
      coachName: coachName,
      quoted: item.quoted,
    ),
  };

  Widget _message(
    BuildContext context,
    ThreadMessage item,
    GlobalKey? bubble,
    ValueChanged<String> onQuote,
  ) {
    final message = item.message;
    final content = MessageContent(
      item: item,
      coachName: coachName,
      onQuote: onQuote,
      onOpenMedia: (index) => unawaited(
        context.push(
          FujinRoute.chatMedia.forMedia(
            view.conversationId,
            message.id,
            index: index,
          ),
        ),
      ),
    );
    final sent = item.delivery == MessageDelivery.sent;
    return MessageRow(
      mine: item.mine,
      reactions: message.reactions,
      onReaction: switch (sent) {
        true => (reaction) => onReact(message, reaction.emoji),
        false => null,
      },
      footer: switch (item.delivery) {
        MessageDelivery.sent => MessageTime(
          at: message.createdAt,
          seen: item.seen,
        ),
        MessageDelivery.sending => const MessageStatus.sending(),
        MessageDelivery.deleting => const MessageStatus.deleting(),
        MessageDelivery.failed => MessageStatus.failed(
          onRetry: () => onRetry(message.id),
        ),
      },
      content: MessageGestures(
        mine: item.mine,
        onReply: switch ((sent, onReply)) {
          (true, final onReply?) => () => onReply(message),
          _ => null,
        },
        onLongPress: switch (sent) {
          true => (bubble) => onActions(item, bubble, content),
          false => null,
        },
        onDoubleTap: switch (sent) {
          true => () => onReact(message, MessageActions.heart),
          false => null,
        },
        child: KeyedSubtree(key: bubble, child: content),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    _Entry entry,
    GlobalKey? bubble,
    ValueChanged<String> onQuote,
  ) {
    final swapping = entry.key.startsWith(_Stage.uploadPrefix);
    final body = switch (entry.item) {
      ThreadDay(:final day) => DaySeparator(
        label: ChatText.day(context.intl, day, now: now),
      ),
      final ThreadMessage item => _message(
        context,
        item,
        switch (swapping) {
          true => null,
          false => bubble,
        },
        onQuote,
      ),
      final ThreadUpload item => UploadBubble(
        item: item,
        coachName: coachName,
        onRetry: () => onRetryUpload(item.upload.id),
      ),
    };
    if (!swapping) return body;
    return AnimatedSize(
      key: bubble,
      duration: switch (FujinMotion.reduced(context)) {
        true => Duration.zero,
        false => FujinMotion.grow.duration,
      },
      curve: FujinMotion.grow.curve,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: FujinMotion.dissolve.duration,
        switchInCurve: FujinMotion.dissolve.curve,
        switchOutCurve: FujinMotion.dissolve.curve,
        layoutBuilder: (current, previous) => Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [...previous, ?current],
        ),
        child: KeyedSubtree(
          key: ValueKey(entry.item is ThreadUpload),
          child: body,
        ),
      ),
    );
  }

  _Entrance _entranceOf(ThreadItem item, {required bool reduced}) =>
      switch ((item, reduced)) {
        (
          ThreadMessage(
                mine: true,
                delivery: MessageDelivery.sending,
                :final message,
              ) &&
              final ThreadMessage sending,
          false,
        ) =>
          switch (flight.takeText(message.content)) {
            final from? => _TextFlight(
              from: from,
              text: message.content,
              quote: _quote(sending),
            ),
            null => const _Rise(),
          },
        (ThreadUpload(:final upload), false) when _Stage.voice(upload) =>
          switch (flight.voiceOrigin) {
            final from? => _RowFlight(from: from),
            null => const _Rise(),
          },
        _ => const _Rise(),
      };

  @override
  Widget build(BuildContext context) {
    final controller = useScrollController();
    final unread = useValueNotifier(0);
    final stage = useMemoized(_Stage.new);
    final revision = useState(0);
    final reduced = FujinMotion.reduced(context);

    useEffect(() {
      void settle() {
        if (controller.hasClients && _atBottom(controller.position)) {
          unread.value = 0;
        }
      }

      controller.addListener(settle);
      return () => controller.removeListener(settle);
    }, [controller]);

    final (atBottom, idle) = switch (controller) {
      ScrollController(hasClients: true, :final position) => (
        _atBottom(position),
        !position.isScrollingNotifier.value,
      ),
      _ => (true, true),
    };
    final arrivals = stage.update(view.newestFirst, animate: !reduced);
    var sentAway = false;
    for (final entry in arrivals) {
      switch ((atBottom, idle, entry.item)) {
        case (true, true, final item):
          stage.entrances[entry.key] = _entranceOf(item, reduced: reduced);
        case (false, _, ThreadMessage(mine: false)):
          unread.value += 1;
        case (false, _, ThreadMessage(mine: true) || ThreadUpload()):
          sentAway = true;
        case _:
          break;
      }
    }
    if (arrivals.isNotEmpty && !(atBottom && idle)) flight.drop();

    void jump() {
      if (!controller.hasClients) return;
      final position = controller.position;
      unread.value = 0;
      final screen = position.viewportDimension;
      switch (reduced) {
        case true:
          position.jumpTo(0);
        case false when position.pixels <= screen * _glideScreens:
          unawaited(
            position.animateTo(
              0,
              duration: FujinMotion.scrollGlide.duration,
              curve: FujinMotion.scrollGlide.curve,
            ),
          );
        case false:
          position.jumpTo(screen);
          unawaited(
            position.animateTo(
              0,
              duration: FujinMotion.scrollSettle.duration,
              curve: FujinMotion.scrollSettle.curve,
            ),
          );
      }
    }

    if (sentAway) {
      WidgetsBinding.instance.addPostFrameCallback((_) => jump());
    }

    Future<void> reveal(String messageId) async {
      final key = stage.messageKey(messageId);
      final index = stage.indexOf(key);
      if (index < 0 || !controller.hasClients) return;
      final far = switch (stage.nearestBuilt(index)) {
        final built? => (built - index).abs() > _smoothReach,
        null => true,
      };
      var glided = false;
      for (var seek = 0; seek < _seekLimit; seek++) {
        if (stage.built(key) != null || !controller.hasClients) break;
        final position = controller.position;
        final target = stage
            .estimate(index, position.pixels)
            .clamp(position.minScrollExtent, position.maxScrollExtent);
        switch (far || reduced || glided) {
          case true:
            position.jumpTo(target);
          case false:
            glided = true;
            await position.animateTo(
              target,
              duration: FujinMotion.scrollGlide.duration,
              curve: FujinMotion.scrollGlide.curve,
            );
        }
        await WidgetsBinding.instance.endOfFrame;
      }
      final row = stage.built(key);
      if (row == null || !row.mounted) return;
      final settle = switch (glided || far) {
        true => FujinMotion.scrollSettle,
        false => FujinMotion.scrollGlide,
      };
      await Scrollable.ensureVisible(
        row,
        alignment: _revealAlignment,
        duration: switch (reduced) {
          true => Duration.zero,
          false => settle.duration,
        },
        curve: settle.curve,
      );
      if (!context.mounted) return;
      stage.highlight(key);
      revision.value += 1;
    }

    void quote(String messageId) => unawaited(reveal(messageId));

    final entries = stage.entries;
    final indices = {
      for (final (index, entry) in entries.indexed) entry.key: index,
    };
    final count = entries.length + (view.loadingOlder ? 1 : 0);
    return Stack(
      children: [
        NotificationListener<ScrollMetricsNotification>(
          onNotification: (notification) {
            if (_nearTop(notification.metrics)) onOlder();
            return false;
          },
          child: NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              if (_nearTop(notification.metrics)) onOlder();
              return false;
            },
            child: ListView.builder(
              controller: controller,
              reverse: true,
              padding: EdgeInsets.fromLTRB(
                FujinSize.screenMargin,
                top,
                FujinSize.screenMargin,
                bottom + FujinSpace.s3,
              ),
              itemCount: count,
              findChildIndexCallback: (key) => switch (key) {
                ValueKey<String>(:final value) => indices[value],
                _ => null,
              },
              itemBuilder: (context, index) =>
                  switch (entries.elementAtOrNull(index)) {
                    null => const Padding(
                      padding: EdgeInsets.only(top: FujinSpace.s3),
                      child: OlderMessagesLoader(),
                    ),
                    final entry => _Row(
                      key: ValueKey(entry.key),
                      id: entry.key,
                      entrance: stage.entrances.remove(entry.key),
                      leaving: entry.leaving,
                      highlights: stage.highlights[entry.key] ?? 0,
                      rows: stage.rows,
                      onGone: () {
                        stage.gone(entry.key);
                        revision.value += 1;
                      },
                      child: (bubble) => IgnorePointer(
                        ignoring: entry.leaving,
                        child: _item(context, entry, bubble, quote),
                      ),
                    ),
                  },
            ),
          ),
        ),
        PositionedDirectional(
          end: FujinSize.screenMargin,
          bottom: bottom + FujinSpace.s4,
          child: JumpToBottomButton(
            controller: controller,
            unread: unread,
            onPressed: jump,
          ),
        ),
      ],
    );
  }
}

final class _Entry {
  const _Entry(this.key, this.item, {this.leaving = false});

  final String key;
  final ThreadItem item;
  final bool leaving;
}

sealed class _Entrance {
  const _Entrance();
}

final class _Rise extends _Entrance {
  const _Rise();
}

final class _TextFlight extends _Entrance {
  const _TextFlight({
    required this.from,
    required this.text,
    required this.quote,
  });

  final Rect from;
  final String text;
  final Widget? quote;
}

final class _RowFlight extends _Entrance {
  const _RowFlight({required this.from});

  final Rect from;
}

final class _Stage {
  static const String dayPrefix = 'day:';
  static const String messagePrefix = 'message:';
  static const String uploadPrefix = 'upload:';

  List<ThreadItem>? _items;
  List<_Entry> entries = const [];
  final Map<String, String> _aliases = {};
  final Map<String, String> _held = {};
  final Map<String, _Entrance> entrances = {};
  final Map<String, int> highlights = {};
  final Map<String, BuildContext> rows = {};

  static bool voice(MessageUpload upload) => upload.media.every(
    (media) => media.kind == ChatMediaKind.voice,
  );

  String messageKey(String id) => _aliases[id] ?? '$messagePrefix$id';

  String keyOf(ThreadItem item) => switch (item) {
    ThreadDay(:final day) => '$dayPrefix${day.toIso8601String()}',
    ThreadMessage(:final message) => messageKey(message.id),
    ThreadUpload(:final upload) => '$uploadPrefix${upload.id}',
  };

  int indexOf(String key) =>
      entries.indexWhere((entry) => entry.key == key && !entry.leaving);

  BuildContext? built(String key) => switch (rows[key]) {
    final row? when row.mounted => row,
    _ => null,
  };

  int? nearestBuilt(int index) {
    int? nearest;
    for (final (at, entry) in entries.indexed) {
      if (built(entry.key) == null) continue;
      if (nearest == null || (at - index).abs() < (nearest - index).abs()) {
        nearest = at;
      }
    }
    return nearest;
  }

  double estimate(int index, double pixels) {
    var low = entries.length;
    var high = -1;
    var extent = 0.0;
    var measured = 0;
    for (final (at, entry) in entries.indexed) {
      final box = built(entry.key)?.findRenderObject();
      if (box is! RenderBox || !box.hasSize) continue;
      low = at < low ? at : low;
      high = at > high ? at : high;
      extent += box.size.height;
      measured += 1;
    }
    if (measured == 0) return pixels;
    final average = extent / measured;
    return switch (index) {
      _ when index > high => pixels + (index - high) * average,
      _ when index < low => pixels - (low - index) * average,
      _ => pixels,
    };
  }

  void highlight(String key) =>
      highlights.update(key, (count) => count + 1, ifAbsent: () => 1);

  void gone(String key) {
    entries = [
      for (final entry in entries)
        if (!(entry.leaving && entry.key == key)) entry,
    ];
    highlights.remove(key);
  }

  List<_Entry> update(List<ThreadItem> items, {required bool animate}) {
    if (identical(items, _items)) return const [];
    final first = _items == null;
    _items = items;
    final before = entries;
    final known = {for (final entry in before) entry.key};
    final uploads = {
      for (final item in items)
        if (item case ThreadUpload(:final upload))
          '$uploadPrefix${upload.id}': upload,
    };
    if (!first) _link(items, before, known, uploads);
    final next = [
      for (final item in items)
        if (!_isHeld(item)) _Entry(keyOf(item), item),
    ];
    final present = {for (final entry in next) entry.key};
    if (first) {
      entries = next;
      return const [];
    }
    final anchor = switch (next.indexWhere(
      (entry) => known.contains(entry.key),
    )) {
      -1 => next.length,
      final index => index,
    };
    final arrivals = [
      for (final entry in next.take(anchor))
        if (!known.contains(entry.key)) entry,
    ];
    entries = switch (animate) {
      true => _withLeaving(before, next, present),
      false => next,
    };
    return arrivals;
  }

  bool _isHeld(ThreadItem item) => switch (item) {
    ThreadMessage(:final message) => _held.containsKey(message.id),
    _ => false,
  };

  void _link(
    List<ThreadItem> items,
    List<_Entry> before,
    Set<String> known,
    Map<String, MessageUpload> uploads,
  ) {
    final ids = {
      for (final item in items)
        if (item case ThreadMessage(:final message)) message.id,
    };
    for (final MapEntry<String, String>(key: id, value: upload)
        in _held.entries.toList()) {
      final present = ids.contains(id);
      final state = uploads[upload];
      if (state case MessageUpload(
        phase: UploadPreparing() || UploadSending(),
      ) when present) {
        continue;
      }
      _held.remove(id);
      if (present && state == null) _aliases[id] = upload;
    }
    final current = {for (final item in items) keyOf(item)};
    final claimed = {..._held.values, ..._aliases.values};
    for (final item in items.reversed) {
      if (item case ThreadMessage(
        mine: true,
        :final message,
        :final postedFrom,
      )) {
        final id = message.id;
        if (_aliases.containsKey(id) ||
            _held.containsKey(id) ||
            known.contains('$messagePrefix$id')) {
          continue;
        }
        final vanished = before.where(
          (entry) =>
              !entry.leaving &&
              !current.contains(entry.key) &&
              !claimed.contains(entry.key),
        );
        final pending = vanished.where(
          (entry) => switch (entry.item) {
            ThreadMessage(
              mine: true,
              delivery: MessageDelivery.sending || MessageDelivery.failed,
              message: final draft,
            ) =>
              draft.id.startsWith(ChatService.pendingPrefix) &&
                  draft.content.trim() == message.content.trim(),
            _ => false,
          },
        );
        if (pending.firstOrNull case final pending?) {
          _aliases[id] = pending.key;
          claimed.add(pending.key);
          continue;
        }
        final upload = before.where(
          (entry) =>
              !entry.leaving &&
              !claimed.contains(entry.key) &&
              postedFrom != null &&
              entry.key == '$uploadPrefix$postedFrom' &&
              switch (entry.item) {
                ThreadUpload(:final upload) => upload.phase is! UploadNotSent,
                _ => false,
              },
        );
        if (upload.firstOrNull case final upload?) {
          claimed.add(upload.key);
          switch (uploads.containsKey(upload.key)) {
            case true:
              _held[id] = upload.key;
            case false:
              _aliases[id] = upload.key;
          }
        }
      }
    }
  }

  List<_Entry> _withLeaving(
    List<_Entry> before,
    List<_Entry> next,
    Set<String> present,
  ) {
    final after = <String?, List<_Entry>>{};
    String? anchor;
    for (final entry in before) {
      switch (present.contains(entry.key)) {
        case true:
          anchor = entry.key;
        case false:
          (after[anchor] ??= []).add(
            _Entry(entry.key, entry.item, leaving: true),
          );
      }
    }
    return [
      ...?after[null],
      for (final entry in next) ...[entry, ...?after[entry.key]],
    ];
  }
}

class _Row extends HookWidget {
  const _Row({
    required this.id,
    required this.entrance,
    required this.leaving,
    required this.highlights,
    required this.rows,
    required this.onGone,
    required this.child,
    super.key,
  });

  final String id;
  final _Entrance? entrance;
  final bool leaving;
  final int highlights;
  final Map<String, BuildContext> rows;
  final VoidCallback onGone;
  final Widget Function(GlobalKey? bubble) child;

  static const Key _content = ValueKey('content');

  void _fly(
    BuildContext context,
    _Entrance? entrance,
    GlobalKey bubble,
    ValueNotifier<bool?> flown,
    ObjectRef<OverlayEntry?> ghost,
  ) {
    if (!context.mounted) return;
    final to = SendFlight.rectOf(bubble);
    final viewport = switch (context
        .findAncestorStateOfType<ScrollableState>()) {
      final scrollable? => SendFlight.rectIn(scrollable.context),
      null => null,
    };
    void land() {
      ghost.value
        ?..remove()
        ..dispose();
      ghost.value = null;
      if (context.mounted) flown.value = true;
    }

    ghost.value = switch ((to, viewport, entrance)) {
      (
        final to?,
        final viewport?,
        _TextFlight(:final from, :final text, :final quote),
      )
          when viewport.contains(to.center) =>
        SendFlight.flyText(
          context,
          from: from,
          to: to,
          text: text,
          quote: quote,
          onLanded: land,
        ),
      (final to?, final viewport?, _RowFlight(:final from))
          when viewport.contains(to.center) =>
        SendFlight.flyRow(
          context,
          from: from,
          to: to,
          row: child(null),
          onLanded: land,
        ),
      _ => null,
    };
    if (ghost.value == null) flown.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final entrance = useMemoized(() => this.entrance);
    final bubble = useMemoized(
      () => switch (entrance) {
        _TextFlight() || _RowFlight() => GlobalKey(),
        _Rise() || null => null,
      },
    );
    final flown = useState<bool?>(switch (bubble) {
      null => true,
      GlobalKey() => null,
    });
    final ghost = useRef<OverlayEntry?>(null);
    final reduced = FujinMotion.reduced(context);

    useEffect(() {
      rows[id] = context;
      return () {
        if (identical(rows[id], context)) rows.remove(id);
      };
    }, [id]);

    useEffect(() {
      if (bubble case final bubble?) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _fly(context, entrance, bubble, flown, ghost),
        );
      }
      return () {
        ghost.value
          ?..remove()
          ..dispose();
        ghost.value = null;
      };
    }, const []);

    useEffect(() {
      if (leaving) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) onGone();
        });
      }
      return null;
    }, const []);

    final rise = entrance is _Rise;
    return SingleMotionBuilder(
      motion: switch ((leaving, entrance, flown.value)) {
        (true, _, _) => FujinMotion.of(context, FujinMotion.rowRemoval),
        (false, _Rise(), _) => FujinMotion.dissolveOf(
          context,
          FujinMotion.messageIn,
        ),
        (false, _, false) => FujinMotion.dissolve,
        _ => const InstantMotion(),
      },
      from: switch (entrance) {
        null => null,
        _ => 0,
      },
      value: switch ((leaving, flown.value)) {
        (true, _) || (false, null) => 0,
        (false, _) => 1,
      },
      onAnimationStatusChanged: (status) {
        if (leaving && !status.isAnimating) onGone();
      },
      builder: (context, shown, child) {
        final presence = shown.clamp(0.0, 1.0);
        return ClipRect(
          clipBehavior: switch (leaving) {
            true => Clip.hardEdge,
            false => Clip.none,
          },
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: switch (leaving) {
              true => presence,
              false => 1,
            },
            child: SizedBox(
              width: double.infinity,
              child: Opacity(
                opacity: presence,
                child: Transform.translate(
                  offset: Offset(0, switch (rise && !reduced) {
                    true => (1 - shown) * FujinMotion.messageRise,
                    false => 0,
                  }),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: FujinSpace.s3),
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.passthrough,
          children: [
            if (highlights > 0)
              Positioned(
                left: -FujinSize.screenMargin,
                right: -FujinSize.screenMargin,
                top: 0,
                bottom: 0,
                child: _Highlight(key: ValueKey(highlights)),
              ),
            KeyedSubtree(key: _content, child: child(bubble)),
          ],
        ),
      ),
    );
  }
}

class _Highlight extends StatelessWidget {
  const _Highlight({super.key});

  @override
  Widget build(BuildContext context) {
    final colour = context.colors.backgroundHighlight;
    return SingleMotionBuilder(
      motion: FujinMotion.highlight,
      from: 1,
      value: 0,
      builder: (context, glow, _) => ColoredBox(
        color: colour.withValues(alpha: colour.a * glow.clamp(0.0, 1.0)),
      ),
    );
  }
}
