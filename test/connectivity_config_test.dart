import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ConnectivityConfig, () {
    test('pingUrl', () async {
      await ConnectivityConfig.pingUrl(Uri.parse('https://google.com'));
      expect(true, true);
    });

    test('constructor', () {
      final config = ConnectivityConfig();
      expect(config.checkInterval, const Duration(seconds: 30));
      expect(config.pingLevelConfig, const PingLevelConfig.defaultConfig());
      expect(config.pingRequest, isA<Future<dynamic> Function()>());
    });

    test(
        'constructor - pingRequest',
        () => () async {
              final config = ConnectivityConfig(pingUrl: 'https://google.com');
              expect(config.pingRequest, isA<Future<dynamic> Function()>());
              await config.pingRequest();
              expect(true, true);
            });
  });
}
