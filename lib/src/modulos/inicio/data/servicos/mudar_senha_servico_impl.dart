import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/inicio/interator/servicos/mudar_senha_servico.dart';

class MudarSenhaServicoImpl implements MudarSenhaServico {
  final IHttpClient client;

  MudarSenhaServicoImpl(this.client);

  @override
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
