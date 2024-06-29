import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_connectivity_checker/connectivity_status.dart';

class ConnectivityConfig {
  final Duration checkInterval;
  final PingLevelConfig pingLevelConfig;
  late DisplayConfig displayConfig;
  late Future<dynamic> Function() pingRequest;

  static Future<void> pingUrl(Uri url) async {
    await http.get(url);
    return;
  }

  ConnectivityConfig({
    this.checkInterval = const Duration(seconds: 30),
    this.pingLevelConfig = const PingLevelConfig.defaultConfig(),
    DisplayConfig? displayConfig,
    String pingUrl =
        'https://google.com', // ping this url if no pingRequest is provided
    Future<dynamic> Function()? pingRequest,
  }) {
    this.pingRequest =
        pingRequest ?? (() => ConnectivityConfig.pingUrl(Uri.parse(pingUrl)));

    this.displayConfig = displayConfig ?? DisplayConfig();
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

  DisplayConfig({
    this.loadingIndicatorColor = Colors.white,
  }) : _displayConfig = {
          ConnectivityStatusType.offline:
              const DisplayConfigForStatusType.offline(),
          ConnectivityStatusType.hasNetworkButNoConnection:
              const DisplayConfigForStatusType.hasNetworkButNoConnection(),
          ConnectivityStatusType.poorConnection:
              const DisplayConfigForStatusType.poorConnection(),
          ConnectivityStatusType.okConnection:
              const DisplayConfigForStatusType.okConnection(),
          ConnectivityStatusType.goodConnection:
              const DisplayConfigForStatusType.goodConnection(),
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
  final bool
      showErrorMessage; // whether to show the error message (if any) in a SnackBar

  const DisplayConfigForStatusType({
    this.display = true,
    this.showPingValue = false,
    this.showErrorMessage = false,
    this.iconColor = Colors.white,
    required this.message,
    required this.icon,
  });

  const DisplayConfigForStatusType.offline({
    this.display = true,
    this.showPingValue = false,
    this.showErrorMessage = false,
    this.iconColor = Colors.white,
    this.message = 'No Network',
    this.icon = const Icon(Icons.signal_cellular_off),
  });

  const DisplayConfigForStatusType.hasNetworkButNoConnection({
    this.display = true,
    this.showPingValue = false,
    this.showErrorMessage = true,
    this.iconColor = Colors.white,
    this.message = 'Server Unreachable',
    this.icon = const Icon(Icons.signal_cellular_connected_no_internet_4_bar),
  });

  const DisplayConfigForStatusType.poorConnection({
    this.display = true,
    this.showPingValue = false,
    this.showErrorMessage = false,
    this.iconColor = Colors.white,
    this.message = 'High Ping',
    this.icon = const Icon(Icons.signal_cellular_alt_1_bar),
  });

  const DisplayConfigForStatusType.okConnection({
    this.display = true,
    this.showPingValue = false,
    this.showErrorMessage = false,
    this.iconColor = Colors.white,
    this.message = 'Medium Ping',
    this.icon = const Icon(Icons.signal_cellular_alt_2_bar),
  });

  const DisplayConfigForStatusType.goodConnection({
    this.display = true,
    this.showPingValue = false,
    this.showErrorMessage = false,
    this.iconColor = Colors.white,
    this.message = 'Low Ping',
    this.icon = const Icon(Icons.signal_cellular_alt),
  });
}
