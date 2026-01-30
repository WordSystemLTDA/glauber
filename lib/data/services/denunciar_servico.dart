import 'dart:convert';

import 'package:provadelaco/config/dio.dart';

class DenunciarServico {
  final DioClient client;

  DenunciarServico(this.client);

  Future<bool> denunciar(String idEvento, String idEmpresa, String nome, String celular, String mensagem) async {
    var url = 'denuncias/denunciar.php';

    var campos = {
      "id_evento": idEvento,
      "id_empresa": idEmpresa,
      "denuncia": mensagem,
      "nome": nome,
      "celular": celular,
    };

    var response = await client.dio.post(url, data: jsonEncode(campos));
    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return sucesso;
    } else {
      return false;
    }
  }
}
