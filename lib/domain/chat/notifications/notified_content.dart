import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/chat/notifications/media_label.dart';

part 'notified_content.mapper.dart';

@MappableClass(discriminatorKey: 'kind')
sealed class NotifiedContent with NotifiedContentMappable {
  const NotifiedContent();
}

@MappableClass(discriminatorValue: 'text')
final class NotifiedText extends NotifiedContent with NotifiedTextMappable {
  const NotifiedText(this.text);

  final String text;
}

@MappableClass(discriminatorValue: 'media')
final class NotifiedMedia extends NotifiedContent with NotifiedMediaMappable {
  const NotifiedMedia(this.label, {this.caption});

  final MediaLabel label;
  final String? caption;
}

@MappableClass(discriminatorValue: 'unsupported')
final class NotifiedUnsupported extends NotifiedContent
    with NotifiedUnsupportedMappable {
  const NotifiedUnsupported();
}
