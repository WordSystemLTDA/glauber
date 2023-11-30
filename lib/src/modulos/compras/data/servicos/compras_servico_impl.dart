import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ComprasServicoImpl implements ComprasServico {
  final IHttpClient client;

  ComprasServicoImpl(this.client);

  @override
  Future<List<ComprasModelo>> listar(UsuarioModelo? usuario) async {
    var url = 'compras/listar.php';

    var campos = {
      'id_cliente': usuario!.id,
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
