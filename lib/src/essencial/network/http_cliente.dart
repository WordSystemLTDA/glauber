abstract interface class IHttpClient {
  Future? get({
    required String url,
    Map<String, String>? headers,
  }) {
    return null;
  }

  Future? post({
    required String url,
    required dynamic body,
    Map<String, String>? headers,
  }) {
    return null;
  }
}
