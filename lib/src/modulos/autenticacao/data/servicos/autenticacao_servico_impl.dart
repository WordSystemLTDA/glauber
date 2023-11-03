import 'dart:convert';

import 'package:glauber/src/essencial/network/http_cliente.dart';
import 'package:glauber/src/essencial/usuario_provider.dart';
import 'package:glauber/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';

class AutenticacaoServicoImpl implements AutenticacaoServico {
  final IHttpClient client;

  AutenticacaoServicoImpl(this.client);

  @override
  Future<bool> entrar(String email, String senha) async {
    var url = 'autenticacao/entrar.php';

    var campos = {
      "email": email,
      "senha": senha,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    dynamic dados = result['resultado'];

    if (response.statusCode == 200 && sucesso == true) {
      await UsuarioProvider.setUsuario(jsonEncode(dados));

      return sucesso;
    } else {
      return false;
    }
  }

  @override
  Future<List<dynamic>> cadastrar(String nome, String email, String senha) async {
    var url = 'autenticacao/cadastrar.php';

    var campos = {
      "nome": nome,
      "email": email,
      "senha": senha,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    dynamic mensagem = result['mensagem'];

    if (response.statusCode == 200) {
      return [sucesso, mensagem];
    } else {
      return [false, 'Erro ao tentar inserir'];
    }
  }

  @override
  Future<bool> verificar() async {
    var url = 'autenticacao/verificacao.php';

    var usuarioProvider = UsuarioProvider.getUsuario();

    if (usuarioProvider.toMap().isEmpty) {
      return false;
    }

    var campos = {
      "email": usuarioProvider.email,
      "senha": usuarioProvider.senha,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    dynamic dados = result['resultado'];

    if (response.statusCode == 200 && sucesso == true) {
      await UsuarioProvider.setUsuario(jsonEncode(dados));

      return sucesso;
    } else {
      return false;
    }
  }
}
