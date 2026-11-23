import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/pages/chat/chat_files.dart';
import 'package:fujin/pages/chat/widgets/media_placeholder.dart';
import 'package:fujin/pages/chat/widgets/photo_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatMediaHero extends StatelessWidget {
  const ChatMediaHero({
    required this.messageId,
    required this.index,
    required this.url,
    required this.video,
    required this.thumb,
    required this.radius,
    required this.child,
    super.key,
  });

  final String messageId;
  final int index;
  final Uri url;
  final bool video;
  final Size thumb;
  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) => HeroMode(
    enabled: !FujinMotion.reduced(context),
    child: Hero(
      tag: (ChatMediaHero, messageId, index),
      curve: FujinMotion.flight.curve,
      transitionOnUserGestures: true,
      createRectTween: (begin, end) => RectTween(begin: begin, end: end),
      flightShuttleBuilder: (context, flight, direction, from, to) => _Shuttle(
        url: url,
        video: video,
        thumb: thumb,
        radius: radius,
        flight: flight,
      ),
      child: child,
    ),
  );
}

class _Shuttle extends HookConsumerWidget {
  const _Shuttle({
    required this.url,
    required this.video,
    required this.thumb,
    required this.radius,
    required this.flight,
  });

  final Uri url;
  final bool video;
  final Size thumb;
  final double radius;
  final Animation<double> flight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shown = useAnimation(flight).clamp(0.0, 1.0);
    final file = switch (video) {
      true => ref.watch(videoPosterProvider(url)).value?.file,
      false => ref.watch(chatFileProvider(url)).value,
    };
    final image = switch (file) {
      final file? => PhotoTile.thumbOf(
        file,
        width: thumb.width,
        ratio: MediaQuery.devicePixelRatioOf(context),
      ),
      null => null,
    };
    final aspect = useState<double?>(null);
    final configuration = createLocalImageConfiguration(context);
    useEffect(() {
      if (image == null) return null;
      final stream = image.resolve(configuration);
      final listener = ImageStreamListener((info, synchronousCall) {
        aspect.value = info.image.width / info.image.height;
        info.dispose();
      });
      stream.addListener(listener);
      return () => stream.removeListener(listener);
    }, [image]);
    return LayoutBuilder(
      builder: (context, box) {
        final bounds = Offset.zero & box.biggest;
        final shape = switch (aspect.value) {
          final aspect? => Size(aspect, 1),
          null => box.biggest,
        };
        final cover = applyBoxFit(BoxFit.cover, shape, box.biggest).destination;
        final contain = applyBoxFit(
          BoxFit.contain,
          shape,
          box.biggest,
        ).destination;
        final picture = Alignment.center.inscribe(
          Size(
            cover.width + (contain.width - cover.width) * shown,
            cover.height + (contain.height - cover.height) * shown,
          ),
          bounds,
        );
        return ClipRRect(
          clipper: _Window(
            RRect.fromRectAndRadius(
              picture.intersect(bounds),
              Radius.circular(radius * (1 - shown)),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fromRect(
                rect: picture,
                child: switch (image) {
                  final image? => Image(
                    image: image,
                    fit: BoxFit.fill,
                    gaplessPlayback: true,
                    excludeFromSemantics: true,
                  ),
                  null => const MediaPlaceholder(),
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Window extends CustomClipper<RRect> {
  const _Window(this.window);

  final RRect window;

  @override
  RRect getClip(Size size) => window;

  @override
  bool shouldReclip(_Window oldClipper) => oldClipper.window != window;
}
