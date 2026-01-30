import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/cidade/cidade.dart';

class CidadeServico {
  final DioClient client;

  CidadeServico(this.client);

  Future<List<CidadeModelo>> listar(String? nome) async {
    var url = 'cidade/listar_por_nome.php?nome=$nome';

    try {
      final response = await client.dio.get(url);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.data);

        return List<CidadeModelo>.from(
          jsonData.map((elemento) {
            return CidadeModelo.fromMap(elemento);
          }),
        );
      }
    } on DioException catch (exception) {
      return Future.error('Verifique sua conexão', exception.stackTrace);
    } catch (exception, stacktrace) {
      return Future.error('Verifique sua conexão', stacktrace);
    }

    return Future.error('Ocorreu um erro, tente novamente.');
  }
}
