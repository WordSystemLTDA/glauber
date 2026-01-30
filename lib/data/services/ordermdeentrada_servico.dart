import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/ordem_de_entrada_modelo.dart';
import 'package:provadelaco/domain/models/prova_parceiros_modelo.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';
import 'package:share_plus/share_plus.dart';

class OrdemDeEntradaServico {
  final DioClient client;

  OrdemDeEntradaServico(this.client);

  Future<List<OrdemDeEntradaModelo>> listar(UsuarioModelo? usuario) async {
    var idCliente = usuario!.id;
    var url = "ordem_de_entrada/listar.php?id_cliente=$idCliente";

    var response = await client.dio.get(url);

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return List<OrdemDeEntradaModelo>.from(jsonData['dados'].map((elemento) {
        return OrdemDeEntradaModelo.fromMap(elemento);
      }));
    } else {
      return [];
    }
  }

  Future<List<ProvaParceirosModelos>> listarPorProva(UsuarioModelo? usuario, String idProva) async {
    // var idCliente = usuario!.id;
    var url = "ordem_de_entrada/listar_por_provas.php?id_prova=$idProva";

    var response = await client.dio.get(url);

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

  Future<List<ProvaParceirosModelos>> listarPorListaCompeticao(UsuarioModelo? usuario, String idListaCompeticao, String idEmpresa, String idEvento) async {
    var url = "ordem_de_entrada/listar_por_lista_competicao.php?id_empresa=$idEmpresa&id_evento=$idEvento&id_lista_competicao=$idListaCompeticao";

    var response = await client.dio.get(url);

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
}
