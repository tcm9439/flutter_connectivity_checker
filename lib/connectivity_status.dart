import 'package:flutter_connectivity_checker/connectivity_config.dart';

enum ConnectivityStatusType {
  offline, // no network
  hasNetworkButNoConnection, // has network but cannot connect to the server
  poorConnection, // can connect to the server but ping is high
  okConnection, // can connect to the server and ping is ok
  goodConnection; // can connect to the server and ping is low

  static ConnectivityStatusType fromPing(
      ConnectivityConfig config, Duration ping) {
    if (ping <= config.pingLevelConfig.goodPingThreshold) {
      return ConnectivityStatusType.goodConnection;
    } else if (ping <= config.pingLevelConfig.okPingThreshold) {
      return ConnectivityStatusType.okConnection;
    } else {
      return ConnectivityStatusType.poorConnection;
    }
  }
}

class ConnectivityStatus {
  ConnectivityStatusType type;
  Duration? ping;
  String? errorMsg;

  ConnectivityStatus.offline({this.errorMsg})
      : type = ConnectivityStatusType.offline,
        ping = null;

  ConnectivityStatus.hasNetworkButNoConnection({this.errorMsg})
      : type = ConnectivityStatusType.hasNetworkButNoConnection,
        ping = null;

  ConnectivityStatus.fromPing(ConnectivityConfig config, Duration this.ping)
      : type = ConnectivityStatusType.fromPing(config, ping);
}
