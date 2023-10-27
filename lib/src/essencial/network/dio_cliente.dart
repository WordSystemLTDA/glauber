import 'dart:async';

import 'package:dio/dio.dart';
import 'package:glauber/src/essencial/config.dart';
import 'package:glauber/src/essencial/network/http_cliente.dart';

class DioClient implements IHttpClient {
  final dio = Dio(BaseOptions(baseUrl: Config.apiUrl));

  @override
  Future? get({required String url, Map<String, String>? headers}) async {
    final response = await dio.get(
      url,
      options: Options(headers: headers),
    );

    return response;
  }

  @override
  Future? post({required String url, required body, Map<String, String>? headers}) async {
    final response = await dio.post(
      url,
      data: body,
      options: Options(headers: headers),
    );

    return response;
  }
}
