import 'dart:convert';

import 'package:glauber/src/essencial/network/http_cliente.dart';
import 'package:glauber/src/essencial/usuario_provider.dart';
import 'package:glauber/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:glauber/src/modulos/compras/interator/servicos/compras_servico.dart';

class ComprasServicoImpl implements ComprasServico {
  final IHttpClient client;

  ComprasServicoImpl(this.client);

  @override
  Future<List<ComprasModelo>> listar() async {
    var url = 'compras/listar.php';
    UsuarioProvider.atualizar();
    var usuarioProvider = UsuarioProvider.getUsuario();

    var campos = {
      'id_cliente': usuarioProvider.id,
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
}
