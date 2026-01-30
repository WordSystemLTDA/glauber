import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:provadelaco/domain/models/dados/dados_modelo.dart';
import 'package:provadelaco/config/network/http_cliente.dart';

class ListarDadosServicos {
  final IHttpClient client;

  ListarDadosServicos(this.client);

  Future<DadosModelo> listarDados() async {
    var url = 'dados/listar_dados.php';

    Response response = await client.get(url: url);

    var jsonData = jsonDecode(response.data);
    // bool sucesso = jsonData['sucesso'];
    DadosModelo dados = DadosModelo.fromMap(jsonData['dados']);

    return dados;
  }
}
