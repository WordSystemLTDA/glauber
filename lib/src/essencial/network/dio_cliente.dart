import 'dart:async';

import 'package:dio/dio.dart';
import 'package:glauber/src/compartilhado/constantes/constantes_global.dart';
import 'package:glauber/src/essencial/network/http_cliente.dart';

class DioClient implements IHttpClient {
  final dio = Dio(BaseOptions(baseUrl: ConstantesGlobal.apiUrl));

  @override
  Future? get({required String url, Options? options}) async {
    final response = await dio.get(
      url,
      options: options,
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
