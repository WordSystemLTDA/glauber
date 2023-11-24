import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/usuario_provider.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/ordem_de_entrada_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/servicos/ordemdeentrada_servico.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class OrdemDeEntradaServicoImpl implements OrdemDeEntradaServico {
  final IHttpClient client;

  OrdemDeEntradaServicoImpl(this.client);

  @override
  Future<List<OrdemDeEntradaModelo>> listar() async {
    UsuarioProvider.atualizar();
    var usuarioProvider = UsuarioProvider.getUsuario();
    var idCliente = usuarioProvider!.id;
    var url = "ordem_de_entrada/listar.php?id_cliente=$idCliente";

    var response = await client.get(url: url);

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
