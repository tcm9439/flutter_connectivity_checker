import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_connectivity_checker/connectivity_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ConnectivityRequestFactory, () {
    test('requestWithTargetedResponseCode - valid', () async {
      request() async => ApiResponse(200, 'data');
      var pingRequest =
          ConnectivityRequestFactory.requestWithTargetedResponseCode(
              request, [200]);
      var config = ConnectivityConfig(pingRequest: pingRequest);
      expect(await config.pingRequest(), null);
    });

    test('requestWithTargetedResponseCode - invalid', () async {
      request() async => ApiResponse(400, 'data');
      var pingRequest =
          ConnectivityRequestFactory.requestWithTargetedResponseCode(
              request, [200]);
      var config = ConnectivityConfig(pingRequest: pingRequest);
      // expect to throw an exception
      expect(() async => await config.pingRequest(), throwsException);
    });

    test('requestWithTargetedData - valid', () async {
      request() async => ApiResponse(200, 'data');
      var pingRequest = ConnectivityRequestFactory.requestWithTargetedData(
          request, (data) => data == 'data');
      expect(await pingRequest(), null);
    });

    test('requestWithTargetedData - invalid', () async {
      request() async => ApiResponse(200, 'no :)');
      var pingRequest = ConnectivityRequestFactory.requestWithTargetedData(
          request, (data) => data == 'data');
      // expect to throw an exception
      expect(() async => await pingRequest(), throwsException);
    });
  });
}
