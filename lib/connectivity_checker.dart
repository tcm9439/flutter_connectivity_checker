import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_connectivity_checker/connectivity_status.dart';

class ConnectivityChecker {
  static String? errorMessage;

  /// Check if the device has network connection
  static Future<bool> hasNetworkConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    }
    return false;
  }

  /// Ping the request & get the ping duration
  static Future<Duration?> ping(Future<dynamic> Function() request) async {
    final stopwatch = Stopwatch()..start();
    try {
      await request();
    } catch (e) {
      errorMessage = "ConnectivityChecker: Error to ping the request.\n$e";
      log(errorMessage!);
      return null;
    }
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Create a stream of [ConnectivityStatus] based on the [ConnectivityConfig]
  static Stream<ConnectivityStatus> stream(ConnectivityConfig config) async* {
    while (true) {
      Duration? ping = await ConnectivityChecker.ping(config.pingRequest);
      if (ping == null) {
        // catch exception like TimeoutError
        // check wifi connection
        var hasConnection = await ConnectivityChecker.hasNetworkConnection();

        if (hasConnection) {
          yield ConnectivityStatus.hasNetworkButNoConnection(
              errorMsg: errorMessage);
        } else {
          yield ConnectivityStatus.offline(errorMsg: errorMessage);
        }
      } else {
        yield ConnectivityStatus.fromPing(config, ping);
      }

      // sleep for next round
      await Future.delayed(config.checkInterval);
    }
  }
}
