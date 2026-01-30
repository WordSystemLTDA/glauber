import 'dart:convert';

import 'package:provadelaco/config/network/http_cliente.dart';
import 'package:provadelaco/domain/models/handicaps_modelo.dart';

class HandiCapServico {
  final IHttpClient client;

  HandiCapServico(this.client);

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
