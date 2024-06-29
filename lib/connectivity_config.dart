import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_connectivity_checker/connectivity_status.dart';

class ConnectivityConfig {
  /// The interval between each connectivity check
  final Duration checkInterval;

  /// The configuration for the ping levels
  final PingLevelConfig pingLevelConfig;

  /// The ping request to be used for checking the connection
  late Future<dynamic> Function() pingRequest;

  static Future<void> pingUrl(Uri url) async {
    await http.get(url);
    return;
  }

  /// Create a new [ConnectivityConfig] with the given parameters
  /// - [checkInterval] The interval between each connectivity check
  /// - [pingLevelConfig] The configuration for the ping levels
  /// - [pingRequest] The ping request to be used for checking the connection
  /// - [pingUrl] The url to ping if no pingRequest is provided
  ConnectivityConfig({
    this.checkInterval = const Duration(seconds: 30),
    this.pingLevelConfig = const PingLevelConfig.defaultConfig(),
    Future<dynamic> Function()? pingRequest,
    String pingUrl = 'https://google.com',
  }) {
    this.pingRequest =
        pingRequest ?? (() => ConnectivityConfig.pingUrl(Uri.parse(pingUrl)));
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

/// The configuration for the display if ConnectivityDisplay widget is used
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

/// The configuration for the display of each status type in ConnectivityDisplay widget is used
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
