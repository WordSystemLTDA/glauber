import 'dart:convert';

import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/evento/evento.dart';

class BuscarServico {
  final DioClient client;

  BuscarServico(this.client);

  Future<List<EventoModelo>> listarEventoPorNome(String nomeBusca) async {
    var url = "eventos/listar_por_nome.php?nome=$nomeBusca";

    var response = await client.dio.post(url, data: jsonEncode(''));

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
