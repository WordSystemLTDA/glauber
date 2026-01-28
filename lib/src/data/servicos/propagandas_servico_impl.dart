import 'dart:convert';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/domain/models/propaganda_modelo.dart';

class PropagandasServicoImpl {
  final IHttpClient client;

  PropagandasServicoImpl(this.client);

  Future<PropagandaModelo?> listar(String idPropaganda) async {
    var url = 'propagandas/listar_por_id.php';

    var campos = {
      'id_propaganda': idPropaganda,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return PropagandaModelo.fromMap(jsonData['dados']);
    }
    return null;
  }
}
