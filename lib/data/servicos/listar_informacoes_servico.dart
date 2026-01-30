import 'dart:convert';

import 'package:provadelaco/config/network/http_cliente.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';
import 'package:provadelaco/domain/models/listar_informacoes_modelo.dart';
import 'package:provadelaco/domain/models/prova/prova_modelo.dart';

class ListarInformacoesServico {
  final IHttpClient client;

  ListarInformacoesServico(this.client);

  Future<(bool, String, ListarInformacoesModelo)> listarInformacoes(UsuarioModelo? usuario, List<ProvaModelo> provas, String idEvento, bool editando, String idVenda) async {
    var url = 'vendas/listar_informacoes.php';

    if (editando) {
      for (var element in provas) {
        element.competidores = [];
      }
    }

    var campos = {
      'provas': provas.map((e) => e.toJson()).toList(),
      'id_evento': idEvento,
      'id_cliente': usuario!.id ?? 0,
      'editando': editando,
      'idVenda': idVenda,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];
    ListarInformacoesModelo dados = ListarInformacoesModelo.fromMap(jsonData['dados']);

    return (sucesso, mensagem, dados);
  }
}
