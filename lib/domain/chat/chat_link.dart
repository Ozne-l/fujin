import 'package:dart_mappable/dart_mappable.dart';

part 'chat_link.mapper.dart';

@MappableEnum()
enum ChatLink { connecting, online, offline, expired }
