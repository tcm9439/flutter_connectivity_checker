import 'package:flutter/material.dart';
import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_connectivity_checker/connectivity_display.dart';
import 'package:flutter_connectivity_checker/connectivity_status.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  _requestWithDelay(int milliseconds) {
    return () async {
      await Future.delayed(Duration(milliseconds: milliseconds));
      throw Exception('Request timeout');
    };
  }

  @override
  Widget build(BuildContext context) {
    var displayConfig = DisplayConfig(loadingIndicatorColor: Colors.black)
      ..set(
          ConnectivityStatusType.goodConnection,
          const DisplayConfigForStatusType.goodConnection(
              iconColor: Colors.green))
      ..set(
          ConnectivityStatusType.okConnection,
          const DisplayConfigForStatusType.okConnection(
              showPingValue: true, iconColor: Colors.yellow))
      ..set(
          ConnectivityStatusType.poorConnection,
          const DisplayConfigForStatusType.poorConnection(
              iconColor: Colors.orange))
      ..set(
          ConnectivityStatusType.hasNetworkButNoConnection,
          const DisplayConfigForStatusType.hasNetworkButNoConnection(
              iconColor: Colors.red))
      ..set(ConnectivityStatusType.offline,
          const DisplayConfigForStatusType.offline(iconColor: Colors.grey));

    var connectivityConfig1 = ConnectivityConfig(
      pingRequest: _requestWithDelay(500),
      // pingUrl: 'https://google.com', // may blocked by CORS in browser
      // pingUrl: 'http://localhost:59104/',
      displayConfig: displayConfig,
    );

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('ConnectivityDisplay'),
              ConnectivityDisplay(connectivityConfig1),
              const Text('ConnectivityIcon'),
              ConnectivityIcon(
                  connectivityConfig1,
                  ConnectivityStatus.fromPing(
                      connectivityConfig1, const Duration(milliseconds: 301))),
              ConnectivityIcon(
                  connectivityConfig1,
                  ConnectivityStatus.fromPing(
                      connectivityConfig1, const Duration(milliseconds: 901))),
              ConnectivityIcon(connectivityConfig1,
                  ConnectivityStatus.hasNetworkButNoConnection()),
              ConnectivityIcon(
                  connectivityConfig1, ConnectivityStatus.offline()),
              const Text('ConnectivityIcon with error'),
              ConnectivityIcon(
                  connectivityConfig1,
                  ConnectivityStatus.hasNetworkButNoConnection(
                      errorMsg: "Request timeout")),
            ],
          ),
        ),
      ),
    );
  }
}
