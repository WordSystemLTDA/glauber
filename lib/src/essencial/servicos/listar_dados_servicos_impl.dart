import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:provadelaco/src/essencial/modelos/dados_modelo.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';

class ListarDadosServicosImpl {
  final IHttpClient client;

  ListarDadosServicosImpl(this.client);

  Future<DadosModelo> listarDados() async {
    var url = 'dados/listar_dados.php';

    Response response = await client.get(url: url);

    var jsonData = jsonDecode(response.data);
    // bool sucesso = jsonData['sucesso'];
    DadosModelo dados = DadosModelo.fromMap(jsonData['dados']);

    return dados;
  }
}
