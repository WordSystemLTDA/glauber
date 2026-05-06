import 'dart:convert';

import 'package:dio/dio.dart';

/// Interceptor que intercepta chamadas HTTP e retorna respostas pré-definidas.
/// Utilizado nos testes de integração para simular o comportamento da API.
class FakeInterceptor extends Interceptor {
  final Map<String, dynamic Function(RequestOptions)> _handlers = {};

  /// Registra um handler para uma rota específica.
  /// [path] pode ser o caminho exato ou uma substring do caminho.
  void mockRoute(String path, dynamic Function(RequestOptions) handler) {
    _handlers[path] = handler;
  }

  /// Registra uma resposta fixa (sem lógica customizada) para uma rota.
  void mockResponse(String path, Map<String, dynamic> responseBody, {bool asString = true}) {
    _handlers[path] = (_) => asString ? jsonEncode(responseBody) : responseBody;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;

    // Procura um handler cujo key seja substring do path completo
    final matchedKey = _handlers.keys.firstWhere(
      (key) => path.contains(key),
      orElse: () => '',
    );

    if (matchedKey.isNotEmpty) {
      final responseData = _handlers[matchedKey]!(options);
      handler.resolve(
        Response(
          requestOptions: options,
          data: responseData,
          statusCode: 200,
          headers: Headers.fromMap({
            'content-type': ['application/json'],
          }),
        ),
        true,
      );
    } else {
      // Rota não mapeada — retorna erro genérico
      handler.reject(
        DioException(
          requestOptions: options,
          message: 'FakeInterceptor: nenhum handler registrado para "$path"',
          type: DioExceptionType.unknown,
        ),
        true,
      );
    }
  }
}
