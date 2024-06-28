import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_connectivity_checker/connectivity_status.dart';

class ConnectivityConfig {
  final Duration connectivityCheckInterval;
  final PingLevelConfig pingLevelConfig;
  final DisplayConfig displayConfig;
  late Future<dynamic> Function() pingRequest;

  static Future<void> pingUrl(Uri url) async {
    await http.get(url);
    return;
  }

  ConnectivityConfig({
    this.connectivityCheckInterval = const Duration(seconds: 30),
    this.pingLevelConfig = const PingLevelConfig.defaultConfig(),
    this.displayConfig = const DisplayConfig(),
    String pingUrl = 'http://google.com',
    Future<dynamic> Function()? customPingRequest,
  }) {
    pingRequest = customPingRequest ??
        (() => ConnectivityConfig.pingUrl(Uri.parse(pingUrl)));
  }
}

class PingLevelConfig {
  final Duration
      goodPingThreshold; // ping <= goodPingThreshold -> goodConnection
  final Duration okPingThreshold; // ping <= okPingThreshold -> okConnection

  PingLevelConfig({
    required this.goodPingThreshold,
    required this.okPingThreshold,
  });

  const PingLevelConfig.defaultConfig()
      : goodPingThreshold = const Duration(milliseconds: 300),
        okPingThreshold = const Duration(milliseconds: 800);
}

class DisplayConfig {
  final Map<ConnectivityStatusType, DisplayConfigForStatusType> _displayConfig;
  final Color loadingIndicatorColor;

  const DisplayConfig({
    this.loadingIndicatorColor = Colors.white,
  }) : _displayConfig = const {
          ConnectivityStatusType.offline: DisplayConfigForStatusType(
            message: 'No Network',
            icon: Icon(Icons.signal_cellular_off),
          ),
          ConnectivityStatusType.hasNetworkButNoConnection:
              DisplayConfigForStatusType(
            message: 'Server Unreachable',
            icon: Icon(Icons.signal_cellular_connected_no_internet_4_bar),
          ),
          ConnectivityStatusType.poorConnection: DisplayConfigForStatusType(
            message: 'High Ping',
            icon: Icon(Icons.signal_cellular_alt_1_bar),
          ),
          ConnectivityStatusType.okConnection: DisplayConfigForStatusType(
            message: 'Medium Ping',
            icon: Icon(Icons.signal_cellular_alt_2_bar),
          ),
          ConnectivityStatusType.goodConnection: DisplayConfigForStatusType(
            message: 'Low Ping',
            icon: Icon(Icons.signal_cellular_alt),
          ),
        };

  set(ConnectivityStatusType statusType, DisplayConfigForStatusType config) {
    _displayConfig[statusType] = config;
  }

  DisplayConfigForStatusType get(ConnectivityStatusType statusType) {
    return _displayConfig[statusType]!;
  }
}

class DisplayConfigForStatusType {
  final bool display;
  final bool showPingValue;
  final Color iconColor;
  final String message;
  final Icon icon;

  const DisplayConfigForStatusType({
    this.display = true,
    this.showPingValue = false,
    this.iconColor = Colors.white,
    required this.message,
    required this.icon,
  });
}
