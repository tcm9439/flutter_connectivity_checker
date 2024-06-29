class ApiResponse {
  final int statusCode;
  final dynamic data;

  ApiResponse(this.statusCode, this.data);
}

/// A factory class that creates a `Future<dynamic> Function() pingRequest` to be passed to `ConnectivityConfig` class.
class ConnectivityRequestFactory {
  static Future<dynamic> Function() requestWithTargetedResponseCode(
      Future<ApiResponse> Function() request,
      List<int> targettedResponseCodes) {
    return () async {
      try {
        var response = await request();
        if (targettedResponseCodes.contains(response.statusCode)) {
          // the response met the targetted response code
          return;
        } else {
          throw Exception('Invalid response code: ${response.statusCode}');
        }
      } catch (e) {
        rethrow;
      }
    };
  }

  static Future<dynamic> Function() requestWithTargetedData(
      Future<ApiResponse> Function() request,
      bool Function(dynamic) targettedDataValidator) {
    return () async {
      try {
        var response = await request();
        if (targettedDataValidator(response.data)) {
          // the response met the targetted data
          return;
        } else {
          throw Exception('Invalid response data: ${response.data}');
        }
      } catch (e) {
        rethrow;
      }
    };
  }
}
