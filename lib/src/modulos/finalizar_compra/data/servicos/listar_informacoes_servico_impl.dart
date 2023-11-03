import 'dart:convert';

import 'package:glauber/src/essencial/network/http_cliente.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/listar_informacoes_modelo.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/servicos/listar_informacoes_servico.dart';

class ListarInformacoesServicoImpl implements ListarInformacoesServico {
  final IHttpClient client;

  ListarInformacoesServicoImpl(this.client);

  @override
  Future<(bool, String, ListarInformacoesModelo)> listarInformacoes(String idProva, String idEvento) async {
    var url = 'vendas/listar_informacoes.php';

    var campos = {
      'id_prova': idProva,
      'id_evento': idEvento,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];
    ListarInformacoesModelo dados = ListarInformacoesModelo.fromMap(jsonData['dados']);

    return (sucesso, mensagem, dados);
  }
}
