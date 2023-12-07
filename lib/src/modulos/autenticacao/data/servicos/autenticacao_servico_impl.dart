import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum TiposLogin {
  email,
  google,
  apple;

  String get nome {
    switch (this) {
      case TiposLogin.email:
        return 'email';
      case TiposLogin.google:
        return 'google';
      case TiposLogin.apple:
        return 'apple';
    }
  }
}

class AutenticacaoServicoImpl implements AutenticacaoServico {
  final IHttpClient client;

  AutenticacaoServicoImpl(this.client);

  @override
  Future<(bool, UsuarioModelo?)> entrar(String email, String senha, TiposLogin tipoLogin, dynamic usuario, String? tokenNotificacao) async {
    var url = 'autenticacao/entrar.php';

    String? idSocialLogin = '';
    String? nome = '';
    String? emailNovo = '';
    String? foto = '';

    if (tipoLogin == TiposLogin.email) {
      emailNovo = email;
    } else if (tipoLogin == TiposLogin.google) {
      var usuarioTipo = usuario as GoogleSignInAccount;
      idSocialLogin = usuarioTipo.id;
      nome = usuarioTipo.displayName;
      foto = usuarioTipo.photoUrl;
      emailNovo = usuarioTipo.email;
    } else if (tipoLogin == TiposLogin.apple) {
      var usuarioTipo = usuario as AuthorizationCredentialAppleID;
      idSocialLogin = usuarioTipo.userIdentifier;
      nome = "${usuarioTipo.familyName} ${usuarioTipo.givenName}";
      foto = 'semfoto';
      emailNovo = usuarioTipo.email;
    }

    var campos = {
      "email": emailNovo,
      "nome": nome,
      "senha": senha,
      "tipoLogin": tipoLogin.nome,
      "tokenNotificacao": tokenNotificacao,
      "idSocialLogin": idSocialLogin,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      UsuarioModelo usuarioRetorno = UsuarioModelo.fromMap({...result['resultado'], 'foto': foto});
      return (sucesso, usuarioRetorno);
    } else {
      return (false, null);
    }
  }

  @override
  Future<bool> sair(UsuarioModelo? usuario, tokenNotificacao) async {
    var url = 'autenticacao/sair.php';

    if (usuario == null) {
      return false;
    }

    var idCliente = usuario.id;

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
  Future<bool> excluirConta(UsuarioModelo? usuario, tokenNotificacao) async {
    var url = 'autenticacao/excluir_conta.php';

    if (usuario == null) {
      return false;
    }

    var idCliente = usuario.id;

    var campos = {
      "id_cliente": idCliente,
      "tokenNotificacao": tokenNotificacao,
    };

    final response = await client.post(
      url: url,
      body: jsonEncode(campos),
    );

    print(response.data);

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return sucesso;
    } else {
      return false;
    }
  }

  @override
  Future<(bool, UsuarioModelo?)> cadastrarSocial(dynamic usuario, TiposLogin tipoLogin, String nome, String hcCabeceira, String hcPiseiro) async {
    var url = 'autenticacao/cadastrar_social.php';

    String? idSocialLogin = '';
    String? nomeNovo = '';
    String? foto = '';
    String? email = '';
    String? identityToken = '';

    if (tipoLogin == TiposLogin.google) {
      var usuarioTipo = usuario as GoogleSignInAccount;
      idSocialLogin = usuarioTipo.id;
      nomeNovo = usuarioTipo.displayName;
      foto = usuarioTipo.photoUrl;
      email = usuarioTipo.email;
    } else if (tipoLogin == TiposLogin.apple) {
      var usuarioTipo = usuario as AuthorizationCredentialAppleID;
      idSocialLogin = usuarioTipo.userIdentifier;
      foto = 'semfoto';
      identityToken = usuarioTipo.identityToken;
      nomeNovo = nome;
      email = usuarioTipo.email;
    }

    var campos = {
      "email": email,
      "idSocialLogin": idSocialLogin,
      'identityToken': identityToken,
      "nome": nomeNovo,
      "tipoLogin": tipoLogin.nome,
      "tokenNotificacao": '',
      "hcCabeceira": hcCabeceira,
      "hcPiseiro": hcPiseiro,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      UsuarioModelo usuarioRetorno = UsuarioModelo.fromMap({...result['resultado'], 'foto': foto});
      return (sucesso, usuarioRetorno);
    } else {
      return (false, null);
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
  Future<(bool, UsuarioModelo?)> verificar(UsuarioModelo? usuario, String? tokenNotificacao) async {
    var url = 'autenticacao/verificacao.php';

    if (usuario == null) {
      return (false, null);
    }

    var campos = {
      "email": usuario.email,
      "senha": usuario.senha,
      "token": usuario.token,
      "tipo": usuario.tipo,
      "tokenNotificacao": tokenNotificacao,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      UsuarioModelo usuarioRetorno = UsuarioModelo.fromMap({...result['resultado'], 'foto': usuario.foto});
      return (sucesso, usuarioRetorno);
    } else {
      // await UsuarioProvider.removerUsuario();
      return (false, null);
    }
  }
}
