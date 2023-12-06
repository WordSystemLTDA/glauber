import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/modelos/handicaps_modelo.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/handicap_servico.dart';

class HandiCapServicoImpl implements HandiCapServico {
  final IHttpClient client;

  HandiCapServicoImpl(this.client);

  @override
  Future<List<HandiCapsModelos>> listar() async {
    var url = 'handicaps/listar.php';

    var response = await client.get(url: url);

    var jsonData = jsonDecode(response.data);
    var sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return List<HandiCapsModelos>.from(jsonData['dados'].map((elemento) {
        return HandiCapsModelos.fromMap(elemento);
      }));
    } else {
      return [];
    }
  }
}
