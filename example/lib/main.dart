import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_connectivity_checker/connectivity_display.dart';
import 'package:flutter_connectivity_checker/connectivity_status.dart';
import 'package:flutter_connectivity_checker/connectivity_request.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  _requestWithDelay(int milliseconds, {bool success = false}) {
    return () async {
      await Future.delayed(Duration(milliseconds: milliseconds));
      if (!success) {
        throw Exception('Request timeout');
      }
    };
  }

  _requestWithResponse() {
    return () async {
      await Future.delayed(const Duration(milliseconds: 10));
      return ApiResponse(200, 'data');
    };
  }

  _requestRandom() {
    var random = Random();
    const possibleValues = [100, 400, 600, 1000];
    return () async {
      await Future.delayed(
          Duration(milliseconds: possibleValues[random.nextInt(4)]));
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
      pingRequest: _requestWithDelay(300, success: false),
      // pingUrl: 'https://google.com', // may blocked by CORS in browser
      // pingUrl: 'http://localhost:59104/',
    );

    var connectivityConfig2 = ConnectivityConfig(
      pingRequest: _requestRandom(),
      checkInterval: const Duration(seconds: 3),
    );

    var connectivityConfig3 = ConnectivityConfig(
      pingRequest: ConnectivityRequestFactory.requestWithTargetedData(
          _requestWithResponse(), (data) => data == 'data'),
    );

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('ConnectivityDisplay'),
              ConnectivityDisplay(
                  config: connectivityConfig1, displayConfig: displayConfig),
              const Text('ConnectivityDisplay With Changing Status'),
              ConnectivityDisplay(
                  config: connectivityConfig2, displayConfig: displayConfig),
              const Text('ConnectivityDisplay With Targeted Data'),
              ConnectivityDisplay(
                  config: connectivityConfig3, displayConfig: displayConfig),
              const Text('ConnectivityIcon According to Display Config'),
              ConnectivityIcon(
                  displayConfig,
                  ConnectivityStatus.fromPing(
                      connectivityConfig1, const Duration(milliseconds: 301))),
              ConnectivityIcon(
                  displayConfig,
                  ConnectivityStatus.fromPing(
                      connectivityConfig1, const Duration(milliseconds: 901))),
              ConnectivityIcon(displayConfig,
                  ConnectivityStatus.hasNetworkButNoConnection()),
              ConnectivityIcon(displayConfig, ConnectivityStatus.offline()),
              const Text('ConnectivityIcon with error'),
              ConnectivityIcon(
                  displayConfig,
                  ConnectivityStatus.hasNetworkButNoConnection(
                      errorMsg: "Request timeout")),
            ],
          ),
        ),
      ),
    );
  }
}
