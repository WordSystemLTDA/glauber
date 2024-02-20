import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/clientes_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/retorno_lista_compra_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:share_plus/share_plus.dart';

class ComprasServicoImpl implements ComprasServico {
  final IHttpClient client;

  ComprasServicoImpl(this.client);

  @override
  Future<List<RetornoListaCompraModelo>> listar(UsuarioModelo? usuario, int pagina) async {
    var url = 'compras/listar.php';

    var campos = {
      'id_cliente': usuario!.id,
      'pagina': pagina,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return List<RetornoListaCompraModelo>.from(jsonData['dados'].map((elemento) {
        return RetornoListaCompraModelo.fromMap(elemento);
      }));
    } else {
      return [];
    }
  }

  @override
  Future<List<ClientesModelo>> listarClientes(String pesquisa) async {
    var url = 'compras/listar_clientes.php';

    var campos = {
      'pesquisa': pesquisa,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

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
}
