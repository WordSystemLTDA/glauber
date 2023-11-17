import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AutenticacaoServicoImpl implements AutenticacaoServico {
  final IHttpClient client;

  AutenticacaoServicoImpl(this.client);

  @override
  Future<bool> entrar(String email, String senha, String? tokenNotificacao) async {
    var url = 'autenticacao/entrar.php';

    var campos = {
      "email": email,
      "senha": senha,
      "tokenNotificacao": tokenNotificacao,
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
  Future<bool> entrarSocial(dynamic usuario, TiposLogin tipo, String? tokenNotificacao) async {
    var url = 'autenticacao/entrar_social.php';
    String? idSocialLogin = '';
    String? nome = '';
    String? email = '';

    if (tipo == TiposLogin.google) {
      var usuarioTipo = usuario as GoogleSignInAccount;
      idSocialLogin = usuarioTipo.id;
      nome = usuarioTipo.displayName;
      email = usuarioTipo.email;
    } else if (tipo == TiposLogin.apple) {
      var usuarioTipo = usuario as AuthorizationCredentialAppleID;
      idSocialLogin = usuarioTipo.userIdentifier;
      nome = "${usuarioTipo.familyName} ${usuarioTipo.givenName}";
      email = usuarioTipo.email;
    }

    var campos = {
      "email": email,
      "nome": nome,
      "idSocialLogin": idSocialLogin,
      "tokenNotificacao": tokenNotificacao,
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
  Future<bool> sair(tokenNotificacao) async {
    var url = 'autenticacao/sair.php';

    var usuarioProvider = UsuarioProvider.getUsuario();

    if (usuarioProvider == null) {
      return false;
    }

    var idCliente = usuarioProvider.id;

    var campos = {
      "id_cliente": idCliente,
      "tokenNotificacao": tokenNotificacao,
    };

    final response = await client.post(
      url: url,
      body: jsonEncode(campos),
    );

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return sucesso;
    } else {
      return false;
    }
  }

  @override
  Future<(bool, String)> cadastrar(String nome, String apelido, String email, String senha, String hcCabeceira, String hcPiseiro) async {
    var url = 'autenticacao/cadastrar.php';

    var campos = {
      "nome": nome,
      "apelido": apelido,
      "email": email,
      "senha": senha,
      "hcCabeceira": hcCabeceira,
      "hcPiseiro": hcPiseiro,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    String mensagem = result['mensagem'];

    if (response.statusCode == 200) {
      return (sucesso, mensagem);
    } else {
      return (false, 'Erro ao tentar inserir');
    }
  }

  @override
  Future<bool> verificar(String? tokenNotificacao) async {
    var url = 'autenticacao/verificacao.php';

    var usuarioProvider = UsuarioProvider.getUsuario();

    if (usuarioProvider == null) {
      return false;
    }

    var campos = {
      "email": usuarioProvider.email,
      "senha": usuarioProvider.senha,
      "token": usuarioProvider.token,
      "tipo": usuarioProvider.tipo,
      "tokenNotificacao": tokenNotificacao,
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
