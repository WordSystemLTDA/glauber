import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/denunciar_servico.dart';

class DenunciarServicoImpl implements DenunciarServico {
  final IHttpClient client;

  DenunciarServicoImpl(this.client);

  @override
  Future<bool> denunciar(String idEvento, String idEmpresa, String nome, String celular, String mensagem) async {
    var url = 'denuncias/denunciar.php';

    var campos = {
      "id_evento": idEvento,
      "id_empresa": idEmpresa,
      "denuncia": mensagem,
      "nome": nome,
      "celular": celular,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));
    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return sucesso;
    } else {
      return false;
    }
  }
}
