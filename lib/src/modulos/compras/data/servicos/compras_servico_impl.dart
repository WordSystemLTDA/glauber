import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/clientes_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/retorno_compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/retorno_gerar_pagamentos.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:share_plus/share_plus.dart';

class ComprasServicoImpl implements ComprasServico {
  final IHttpClient client;
  final UsuarioProvider usuarioProvedor;

  ComprasServicoImpl(this.client, this.usuarioProvedor);

  @override
  Future<RetornoComprasModelo> listar(int pagina1, int pagina2, int pagina3) async {
    var url = 'compras/listar.php';

    var campos = {
      'id_cliente': usuarioProvedor.usuario!.id,
      'pagina1': pagina1,
      'pagina2': pagina2,
      'pagina3': pagina3,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return RetornoComprasModelo.fromMap(jsonData['dados']);
    } else {
      return RetornoComprasModelo(anteriores: [], atuais: [], canceladas: []);
    }
  }

  @override
  Future<ComprasModelo?> listarPorId(String id, String idProva, String idEvento) async {
    var url = 'compras/listar_por_id.php';

    var campos = {
      'id_cliente': usuarioProvedor.usuario!.id,
      'id': id,
      'id_prova': idProva,
      'id_evento': idEvento,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    var jsonData = jsonDecode(response.data);

    return ComprasModelo.fromMap(jsonData['dados']);
  }

  @override
  Future<List<ComprasModelo>> listarSomenteInscricoes(int pagina) async {
    var url = 'compras/listar_somente_inscricoes.php';

    var campos = {
      'id_cliente': usuarioProvedor.usuario!.id,
      'pagina': pagina,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return List<ComprasModelo>.from(jsonData['dados'].map((elemento) {
        return ComprasModelo.fromMap(elemento);
      }));
    } else {
      return [];
    }
  }

  @override
  Future<List<ClientesModelo>> listarClientesNormal(String pesquisa) async {
    var idCliente = usuarioProvedor.usuario!.id!;
    var url = 'compras/listar_clientes_normal.php?pesquisa=$pesquisa&id_cliente=$idCliente';

    var response = await client.get(url: url);

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return List<ClientesModelo>.from(jsonData['dados'].map((elemento) {
        return ClientesModelo.fromMap(elemento);
      }));
    } else {
      return [];
    }
  }

  @override
  Future<bool> baixarPDF(String idVenda) async {
    var tempDir = await getTemporaryDirectory();
    var savePath = '${tempDir.path}/inscricao$idVenda.pdf';

    var url = 'geracao_pdf/gerar_pdf_inscricao.php?id_venda=$idVenda';

    Response response = await client.get(
      url: url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    var file = File(savePath).openSync(mode: FileMode.write);
    file.writeFromSync(response.data);
    await file.close();

    await Share.shareXFiles([XFile(file.path)], subject: 'PDF da inscrição');

    return true;
  }

  @override
  Future<(bool, String)> transferirCompras(List<ComprasModelo> comprasTransferencia, String novoCliente) async {
    var url = 'transferencia/transferir.php';

    var campos = {
      'comprasTransferencias': comprasTransferencia,
      'novoCliente': novoCliente,
    };

    Response response = await client.post(
      url: url,
      body: jsonEncode(campos),
    );

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso, mensagem);
  }

  @override
  Future<(bool, String, RetornoGerarPagamentos?)> gerarPagamentos(List<ComprasModelo> comprasPagamentos, UsuarioModelo? usuario) async {
    var url = 'compras/gerar_pagamentos.php';

    var campos = {
      'comprasPagamentos': comprasPagamentos,
      'usuario': usuario?.toMap(),
    };

    Response response = await client.post(
      url: url,
      body: jsonEncode(campos),
    );

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];
    if (sucesso) {
      RetornoGerarPagamentos retornoGerarPagamentos = RetornoGerarPagamentos.fromMap(jsonData['dados']);

      return (sucesso, mensagem, retornoGerarPagamentos);
    } else {
      return (sucesso, mensagem, null);
    }
  }

  @override
  Future<(bool, String)> editarParceiro(String idParceiroVenda, String idParceiroOriginal, String idNovoParceiro, String modalidade) async {
    var url = 'compras/editar_parceiro.php';

    var campos = {
      'id_parceiro_venda': idParceiroVenda,
      'id_parceiro_original': idParceiroOriginal,
      'id_novo_parceiro': idNovoParceiro,
      'id_cliente_original': usuarioProvedor.usuario!.id,
      'modalidade': modalidade,
    };

    Response response = await client.post(
      url: url,
      body: jsonEncode(campos),
    );

    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso, mensagem);
  }

  @override
  Future<(bool, String)> editarReembolsoVenda(String id) async {
    var url = 'compras/editar_reembolso_venda.php';

    var campos = {
      'id_venda': id,
    };

    Response response = await client.post(
      url: url,
      body: jsonEncode(campos),
    );

    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso, mensagem);
  }
}
