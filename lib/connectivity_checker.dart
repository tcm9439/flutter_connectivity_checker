import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_connectivity_checker/connectivity_status.dart';

class ConnectivityChecker {
  static Future<bool> hasWifiConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    }
    return false;
  }

  static Future<Duration> ping(Future<dynamic> Function() request) async {
    final stopwatch = Stopwatch()..start();
    await request();
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  static Stream<ConnectivityStatus> stream(ConnectivityConfig config) async* {
    while (true) {
      try {
        Duration ping = await ConnectivityChecker.ping(config.pingRequest);
        yield ConnectivityStatus.fromPing(config, ping);
      } catch (e) {
        // catch exception like TimeoutError
        // check wifi connection
        yield await hasWifiConnection()
            ? ConnectivityStatus.hasWifiButNoConnection()
            : ConnectivityStatus.offline();
      }

      // sleep for next round
      await Future.delayed(config.connectivityCheckInterval);
    }
  }
}
