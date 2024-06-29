import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_connectivity_checker/connectivity_status.dart';

class ConnectivityChecker {
  /// Check if the device has network connection
  static Future<bool> hasNetworkConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      log('has wifi');
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      log('has mobile');
      return true;
    }
    return false;
  }

  /// Ping the request & get the ping duration
  static Future<Duration> ping(Future<dynamic> Function() request) async {
    final stopwatch = Stopwatch()..start();
    await request().catchError((error) {
      log("ping has error");
      throw error;
    });
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Create a stream of [ConnectivityStatus] based on the [ConnectivityConfig]
  static Stream<ConnectivityStatus> stream(ConnectivityConfig config) async* {
    while (true) {
      try {
        Duration ping = await ConnectivityChecker.ping(config.pingRequest);
        yield ConnectivityStatus.fromPing(config, ping);
      } catch (e) {
        String errorMsg = "Error to ping the request: $e";
        log(errorMsg);
        // catch exception like TimeoutError
        // check wifi connection
        log('before hasNetworkConnection');
        var hasConnection = await ConnectivityChecker.hasNetworkConnection();
        // var hasConnection = true;
        log('after hasNetworkConnection');
        log('hasConnection: $hasConnection');

        if (hasConnection) {
          yield ConnectivityStatus.hasNetworkButNoConnection(
              errorMsg: errorMsg);
        } else {
          yield ConnectivityStatus.offline(errorMsg: errorMsg);
        }
      }

      // sleep for next round
      await Future.delayed(config.connectivityCheckInterval);
    }
  }
}
