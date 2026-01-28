import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';

class MudarSenhaServicoImpl {
  final IHttpClient client;

  MudarSenhaServicoImpl(this.client);

  Future<bool> mudarSenha(UsuarioModelo? usuario, String senha) async {
    var url = 'clientes/mudar_senha.php';

    if (usuario == null) {
      return false;
    }

    var campos = {
      "id": usuario.id,
      "senha": senha,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return sucesso;
    } else {
      return false;
    }
  }
}
