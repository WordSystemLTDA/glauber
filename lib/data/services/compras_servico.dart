import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/domain/models/clientes/clientes.dart';
import 'package:provadelaco/domain/models/compras/compras.dart';
import 'package:provadelaco/domain/models/retorno_compras_modelo.dart';
import 'package:provadelaco/domain/models/retorno_gerar_pagamentos.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';
import 'package:share_plus/share_plus.dart';

class ComprasServico {
  final DioClient client;
  final UsuarioProvider usuarioProvedor;

  ComprasServico(this.client, this.usuarioProvedor);

  Future<RetornoComprasModelo> listar(int pagina1, int pagina2, int pagina3) async {
    var url = 'compras/listar.php';

    var campos = {
      'id_cliente': usuarioProvedor.usuario!.id,
      'pagina1': pagina1,
      'pagina2': pagina2,
      'pagina3': pagina3,
    };

    var response = await client.dio.get(url, queryParameters: campos);

    var jsonData = response.data;
    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return RetornoComprasModelo.fromMap(jsonData['dados']);
    } else {
      return RetornoComprasModelo(anteriores: [], atuais: [], canceladas: []);
    }
  }

  Future<ComprasModelo?> listarPorId(String id, String idProva, String idEvento) async {
    var url = 'compras/listar_por_id.php?id=$id&id_prova=$idProva&id_evento=$idEvento&id_cliente=${usuarioProvedor.usuario!.id}';

    var response = await client.dio.get(url);

    var jsonData = jsonDecode(response.data);

    return ComprasModelo.fromMap(jsonData['dados']);
  }

  Future<List<ComprasModelo>> listarSomenteInscricoes(int pagina) async {
    var url = 'compras/listar_somente_inscricoes.php';

    var campos = {
      'id_cliente': usuarioProvedor.usuario!.id,
      'pagina': pagina,
    };

    var response = await client.dio.post(url, data: jsonEncode(campos));

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

  Future<List<ClientesModelo>> listarClientesNormal(String pesquisa) async {
    var idCliente = usuarioProvedor.usuario!.id!;
    var url = 'compras/listar_clientes_normal.php?pesquisa=$pesquisa&id_cliente=$idCliente';

    var response = await client.dio.get(url);

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

  Future<bool> baixarPDF(String idVenda) async {
    var tempDir = await getTemporaryDirectory();
    var savePath = '${tempDir.path}/inscricao$idVenda.pdf';

    var url = 'geracao_pdf/gerar_pdf_inscricao.php?id_venda=$idVenda';

    Response response = await client.dio.get(
      url,
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

    await SharePlus.instance.share(ShareParams(
      files: [XFile(file.path)],
      subject: 'PDF da inscrição',
    ));

    return true;
  }

  Future<({bool sucesso, String mensagem})> transferirCompras(List<ComprasModelo> comprasTransferencia, String novoCliente) async {
    var url = 'transferencia/transferir.php';

    var campos = {
      'comprasTransferencias': comprasTransferencia,
      'novoCliente': novoCliente,
    };

    Response response = await client.dio.post(
      url,
      data: jsonEncode(campos),
    );

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso: sucesso, mensagem: mensagem);
  }

  Future<(bool, String, RetornoGerarPagamentos?)> gerarPagamentos(List<ComprasModelo> comprasPagamentos, UsuarioModelo? usuario) async {
    var url = 'compras/gerar_pagamentos.php';

    var campos = {
      'comprasPagamentos': comprasPagamentos,
      'usuario': usuario?.toMap(),
    };

    Response response = await client.dio.post(
      url,
      data: jsonEncode(campos),
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

  Future<(bool, String)> editarParceiro(String idParceiroVenda, String idParceiroOriginal, String idNovoParceiro, String modalidade) async {
    var url = 'compras/editar_parceiro.php';

    var campos = {
      'id_parceiro_venda': idParceiroVenda,
      'id_parceiro_original': idParceiroOriginal,
      'id_novo_parceiro': idNovoParceiro,
      'id_cliente_original': usuarioProvedor.usuario!.id,
      'modalidade': modalidade,
    };

    Response response = await client.dio.post(
      url,
      data: jsonEncode(campos),
    );

    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso, mensagem);
  }

  Future<(bool, String)> editarReembolsoVenda(String id, String idcliente, String modalidade) async {
    var url = 'compras/editar_reembolso_venda.php';

    var campos = {
      'id_venda': id,
      'modalidade': modalidade,
      'idcliente': idcliente,
    };

    Response response = await client.dio.post(
      url,
      data: jsonEncode(campos),
    );

    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso, mensagem);
  }
}
