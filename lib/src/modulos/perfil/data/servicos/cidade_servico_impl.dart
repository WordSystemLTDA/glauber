import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/modulos/perfil/interator/modelos/cidade_modelo.dart';
import 'package:provadelaco/src/modulos/perfil/interator/servicos/cidade_servico.dart';

class CidadeServicoImpl implements CidadeServico {
  final IHttpClient client;

  CidadeServicoImpl(this.client);

  @override
  Future<List<CidadeModelo>> listar(String? nome) async {
    var url = 'cidade/listar_por_nome.php?nome=$nome';

    try {
      final response = await client.get(url: url);

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
