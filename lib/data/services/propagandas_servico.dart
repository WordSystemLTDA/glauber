import 'dart:convert';

import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/propaganda_modelo.dart';

class PropagandasServico {
  final DioClient client;

  PropagandasServico(this.client);

  Future<PropagandaModelo?> listar(String idPropaganda) async {
    var url = 'propagandas/listar_por_id.php';

    var campos = {
      'id_propaganda': idPropaganda,
    };

    var response = await client.dio.post(url, data: jsonEncode(campos));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return PropagandaModelo.fromMap(jsonData['dados']);
    }
    return null;
  }
}
