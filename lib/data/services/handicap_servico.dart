import 'dart:convert';

import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/handicaps_modelo.dart';

class HandiCapServico {
  final DioClient client;

  HandiCapServico(this.client);

  Future<List<HandiCapsModelos>> listar() async {
    var url = 'handicaps/listar.php';

    var response = await client.dio.get(url);

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
