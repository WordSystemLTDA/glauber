import 'dart:convert';

import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/formulario_compra_modelo.dart';
import 'package:provadelaco/domain/models/formulario_editar_compra_modelo.dart';
import 'package:provadelaco/domain/models/retorno_compra_modelo.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';

class FinalizarCompraServico {
  final DioClient client;

  FinalizarCompraServico(this.client);

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

    var response = await client.dio.post(url, data: campos);
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

    var response = await client.dio.post(url, data: jsonEncode(campos));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];
    DadosRetornoCompraModelo dadosRetorno = DadosRetornoCompraModelo.fromMap(jsonData['dados']);

    return RetornoCompraModelo(sucesso: sucesso, mensagem: mensagem, dados: dadosRetorno);
  }
}
