import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/dados/dados.dart';

class ListarDadosServicos {
  final DioClient client;

  ListarDadosServicos(this.client);

  Future<DadosModelo> listarDados() async {
    var url = 'dados/listar_dados.php';

    Response response = await client.dio.get(url);

    var jsonData = jsonDecode(response.data);
    // bool sucesso = jsonData['sucesso'];
    DadosModelo dados = DadosModelo.fromMap(jsonData['dados']);

    return dados;
  }
}
