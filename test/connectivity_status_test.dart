import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_connectivity_checker/connectivity_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ConnectivityStatusType, () {
    test('fromPing', () {
      var config = ConnectivityConfig(
          pingLevelConfig: PingLevelConfig(
              goodPingThreshold: const Duration(milliseconds: 300),
              okPingThreshold: const Duration(milliseconds: 800)));

      var result = ConnectivityStatusType.fromPing(
          config, const Duration(milliseconds: 150));
      expect(result, ConnectivityStatusType.goodConnection);

      result = ConnectivityStatusType.fromPing(
          config, const Duration(milliseconds: 500));
      expect(result, ConnectivityStatusType.okConnection);

      result = ConnectivityStatusType.fromPing(
          config, const Duration(milliseconds: 1000));
      expect(result, ConnectivityStatusType.poorConnection);
    });
  });

  group(ConnectivityStatus, () {
    test('fromPing', () {
      var config = ConnectivityConfig(
          pingLevelConfig: PingLevelConfig(
              goodPingThreshold: const Duration(milliseconds: 300),
              okPingThreshold: const Duration(milliseconds: 800)));

      var result = ConnectivityStatus.fromPing(
          config, const Duration(milliseconds: 150));
      expect(result.type, ConnectivityStatusType.goodConnection);
      expect(result.ping, const Duration(milliseconds: 150));
    });

    test('offline', () {
      var result = ConnectivityStatus.offline();
      expect(result.type, ConnectivityStatusType.offline);
      expect(result.ping, null);
    });

    test('hasWifiButNoConnection', () {
      var result = ConnectivityStatus.hasWifiButNoConnection();
      expect(result.type, ConnectivityStatusType.hasNetworkButNoConnection);
      expect(result.ping, null);
    });
  });
}
