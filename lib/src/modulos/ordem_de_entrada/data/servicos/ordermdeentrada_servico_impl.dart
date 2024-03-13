import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/parceiros_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/prova_parceiros_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/servicos/ordemdeentrada_servico.dart';
import 'package:share_plus/share_plus.dart';

class OrdemDeEntradaServicoImpl implements OrdemDeEntradaServico {
  final IHttpClient client;

  OrdemDeEntradaServicoImpl(this.client);

  @override
  Future<List<ParceirosModelos>> listar(UsuarioModelo? usuario) async {
    var idCliente = usuario!.id;
    var url = "ordem_de_entrada/listar.php?id_cliente=$idCliente";

    var response = await client.get(url: url);

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return List<ParceirosModelos>.from(jsonData['dados'].map((elemento) {
        return ParceirosModelos.fromMap(elemento);
      }));
    } else {
      return [];
    }
  }

  @override
  Future<List<ProvaParceirosModelos>> listarPorProva(UsuarioModelo? usuario, String idProva) async {
    // var idCliente = usuario!.id;
    var url = "ordem_de_entrada/listar_por_provas.php?id_prova=$idProva";

    var response = await client.get(url: url);

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return List<ProvaParceirosModelos>.from(jsonData['dados'].map((elemento) {
        return ProvaParceirosModelos.fromMap(elemento);
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
}
