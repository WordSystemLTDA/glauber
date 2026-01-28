import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/domain/models/formulario_compra_modelo.dart';
import 'package:provadelaco/src/domain/models/formulario_editar_compra_modelo.dart';
import 'package:provadelaco/src/domain/models/retorno_compra_modelo.dart';

class FinalizarCompraServicoImpl {
  final IHttpClient client;

  FinalizarCompraServicoImpl(this.client);

  Future<RetornoCompraModelo> inserir(UsuarioModelo? usuario, FormularioCompraModelo dados) async {
    var url = 'vendas/inserir.php';

    // var provasAvulsa = dados.provas.where((element) => element.avulsa == 'Sim').toList();
    // var provasNaoAvulsa = dados.provas.where((element) => element.avulsa != 'Sim').toList();

    var campos = {
      ...dados.toMap(),
      // 'provasAvulsa': dados.provas,
      'provas': dados.provas,
      // 'provasNaoAvulsa': provasNaoAvulsa,
      'usuario': usuario!.toMap(),
    };

    var response = await client.post(url: url, body: campos);
    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];
    DadosRetornoCompraModelo dadosRetorno = DadosRetornoCompraModelo.fromMap(jsonData['dados']);

    return RetornoCompraModelo(sucesso: sucesso, mensagem: mensagem, dados: dadosRetorno);
  }

  Future<RetornoCompraModelo> editar(UsuarioModelo? usuario, FormularioEditarCompraModelo dados) async {
    var url = 'vendas/editar.php';

    var campos = {
      ...dados.toMap(),
      'usuario': usuario!.toMap(),
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];
    DadosRetornoCompraModelo dadosRetorno = DadosRetornoCompraModelo.fromMap(jsonData['dados']);

    return RetornoCompraModelo(sucesso: sucesso, mensagem: mensagem, dados: dadosRetorno);
  }
}
