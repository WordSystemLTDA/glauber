import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/listar_informacoes_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/listar_informacoes_servico.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

class ListarInformacoesServicoImpl implements ListarInformacoesServico {
  final IHttpClient client;

  ListarInformacoesServicoImpl(this.client);

  @override
  Future<(bool, String, ListarInformacoesModelo)> listarInformacoes(UsuarioModelo? usuario, List<ProvaModelo> provas, String idEvento, bool editando, String idVenda) async {
    var url = 'vendas/listar_informacoes.php';

    if (editando) {
      for (var element in provas) {
        element.competidores = [];
      }
    }

    var campos = {
      'provas': provas,
      'id_evento': idEvento,
      'id_cliente': usuario!.id ?? 0,
      'editando': editando,
      'idVenda': idVenda,
    };

    var response = await client.post(url: url, body: json.encode(campos));

    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];
    ListarInformacoesModelo dados = ListarInformacoesModelo.fromMap(jsonData['dados']);

    return (sucesso, mensagem, dados);
  }
}
