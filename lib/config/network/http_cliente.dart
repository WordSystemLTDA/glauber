import 'package:dio/dio.dart';

abstract interface class IHttpClient {
  Future? get({
    required String url,
    Options? options,
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
