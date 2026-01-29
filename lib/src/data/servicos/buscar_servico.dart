import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/domain/models/evento_modelo.dart';

class BuscarServico {
  final IHttpClient client;

  BuscarServico(this.client);

  Future<List<EventoModelo>> listarEventoPorNome(String nomeBusca) async {
    var url = "eventos/listar_por_nome.php?nome=$nomeBusca";

    var response = await client.post(url: url, body: jsonEncode(''));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    List<EventoModelo> eventos = jsonData['resultado'] != null
        ? List<EventoModelo>.from(jsonData['resultado'].map((elemento) {
            return EventoModelo.fromMap(elemento);
          }))
        : [];

    if (response.statusCode == 200 && sucesso == true) {
      return eventos;
    } else {
      return [];
    }
  }
}
