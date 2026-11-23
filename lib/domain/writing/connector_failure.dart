import 'package:fujin/data/connectors/connector.dart';

abstract interface class ConnectorFailure {
  Connector get connector;

  Object get error;
}
