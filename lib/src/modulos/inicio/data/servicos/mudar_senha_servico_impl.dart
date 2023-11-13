import 'dart:convert';

import 'package:glauber/src/essencial/network/http_cliente.dart';
import 'package:glauber/src/essencial/usuario_provider.dart';
import 'package:glauber/src/modulos/inicio/interator/servicos/mudar_senha_servico.dart';

class MudarSenhaServicoImpl implements MudarSenhaServico {
  final IHttpClient client;

  MudarSenhaServicoImpl(this.client);

  @override
  Future<bool> mudarSenha(String senha) async {
    var url = 'clientes/mudar_senha.php';

    var usuarioProvider = UsuarioProvider.getUsuario();

    if (usuarioProvider.toMap().isEmpty) {
      return false;
    }

    var campos = {
      "id": usuarioProvider.id,
      "senha": senha,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    dynamic dados = result['dados'];

    if (response.statusCode == 200 && sucesso == true) {
      await UsuarioProvider.setUsuario(jsonEncode(dados));

      return sucesso;
    } else {
      return false;
    }
  }
}
