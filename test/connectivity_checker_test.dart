import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_connectivity_checker/connectivity_checker.dart';

void main() {
  group(ConnectivityChecker, () {
    test('stream', () async {
      final result = ConnectivityChecker.stream(ConnectivityConfig());
      expect(result, isA<Stream>());
    });

    test('ping', () async {
      final result = await ConnectivityChecker.ping(() async {
        // sleep for 100ms
        await Future.delayed(const Duration(milliseconds: 100));
      });
      expect(result, isA<Duration>());
      expect(result!.inMilliseconds, greaterThanOrEqualTo(100));
    });
  });
}
