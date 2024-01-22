import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/formulario_compra_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/formulario_editar_compra_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/retorno_compra_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/finalizar_compra_servico.dart';

class FinalizarCompraServicoImpl implements FinalizarCompraServico {
  final IHttpClient client;

  FinalizarCompraServicoImpl(this.client);

  @override
  Future<RetornoCompraModelo> inserir(UsuarioModelo? usuario, FormularioCompraModelo dados) async {
    var url = 'vendas/inserir.php';

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

  @override
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
