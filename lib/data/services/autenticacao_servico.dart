import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/modelo_modalidades_cadastro.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';
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

class AutenticacaoServico {
  final DioClient client;

  AutenticacaoServico(this.client);

  Future<(bool, String, UsuarioModelo?)> entrar(String email, String senha, TiposLogin tipoLogin, dynamic usuario, String? tokenNotificacao) async {
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

    var response = await client.dio.post(url, data: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    String mensagem = result['mensagem'];

    if (response.statusCode == 200 && sucesso == true) {
      UsuarioModelo usuarioRetorno = UsuarioModelo.fromMap({...result['resultado'], 'foto': foto});
      return (sucesso, mensagem, usuarioRetorno);
    } else {
      return (false, mensagem, null);
    }
  }

  Future<(bool, String)> sair(UsuarioModelo? usuario, tokenNotificacao) async {
    var url = 'autenticacao/sair.php';

    if (usuario == null) {
      return (false, '');
    }

    var idCliente = usuario.id;

    var campos = {
      "id_cliente": idCliente,
      "tokenNotificacao": tokenNotificacao,
    };

    final response = await client.dio.post(
      url,
      data: jsonEncode(campos),
    );

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    String mensagem = result['mensagem'];

    if (response.statusCode == 200 && sucesso == true) {
      return (sucesso, mensagem);
    } else {
      return (false, mensagem);
    }
  }

  Future<(bool, String)> excluirConta(UsuarioModelo? usuario, tokenNotificacao) async {
    var url = 'autenticacao/excluir_conta.php';

    if (usuario == null) {
      return (false, '');
    }

    var idCliente = usuario.id;

    var campos = {
      "id_cliente": idCliente,
      "tokenNotificacao": tokenNotificacao,
    };

    final response = await client.dio.post(
      url,
      data: jsonEncode(campos),
    );

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    String mensagem = result['mensagem'];

    if (response.statusCode == 200 && sucesso == true) {
      return (sucesso, mensagem);
    } else {
      return (false, mensagem);
    }
  }

  Future<({bool sucesso, String mensagem, UsuarioModelo? usuario})> cadastrarSocial(
      dynamic usuario, TiposLogin tipoLogin, String nome, String hcCabeceira, String hcPiseiro) async {
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

    var response = await client.dio.post(url, data: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    String mensagem = result['mensagem'];

    if (response.statusCode == 200 && sucesso == true) {
      UsuarioModelo usuarioRetorno = UsuarioModelo.fromMap({...result['resultado'], 'foto': foto});
      return (sucesso: sucesso, mensagem: mensagem, usuario: usuarioRetorno);
    } else {
      return (sucesso: false, mensagem: mensagem, usuario: null);
    }
  }

  Future<({bool sucesso, String mensagem})> cadastrar(
    String? idcliente,
    String nome,
    String apelido,
    String email,
    String senha,
    String celular,
    String cidade,
    String hcCabeceira,
    String hcPiseiro,
    String tipodecategoriaprofissional,
    String handicaplacoindividual,
    String datanascimento,
    String sexo,
    List<ModeloModalidadesCadastro> modalidades,
    bool jaEstaCadastrado,
  ) async {
    var url = 'autenticacao/cadastrar.php';

    var campos = {
      "id_cliente": idcliente ?? '0',
      "nome": nome,
      "apelido": apelido,
      "email": email,
      "senha": senha,
      "celular": celular,
      "cidade": cidade,
      "hcCabeceira": hcCabeceira,
      "hcPiseiro": hcPiseiro,
      'tipo_de_categoria_profissional': tipodecategoriaprofissional,
      'handi_cap_laco_individual': handicaplacoindividual,
      'data_nascimento': datanascimento,
      'sexo': sexo,
      'modalidades': modalidades.toList(),
      'jaEstaCadastrado': jaEstaCadastrado,
    };

    var response = await client.dio.post(url, data: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    String mensagem = result['mensagem'];

    if (response.statusCode == 200) {
      return (sucesso: sucesso, mensagem: mensagem);
    } else {
      return (sucesso: false, mensagem: mensagem);
    }
  }

  Future<(bool, String, UsuarioModelo?)> verificar(UsuarioModelo? usuario, String? tokenNotificacao) async {
    var url = 'autenticacao/verificacao.php';

    if (usuario == null) {
      return (false, '', null);
    }

    var campos = {
      "email": usuario.email,
      "senha": usuario.senha,
      "token": usuario.token,
      "tipo": usuario.tipo,
      "tokenNotificacao": tokenNotificacao,
    };

    var response = await client.dio.post(url, data: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    String mensagem = result['mensagem'];

    if (response.statusCode == 200 && sucesso == true) {
      UsuarioModelo usuarioRetorno = UsuarioModelo.fromMap({...result['resultado'], 'foto': usuario.foto});
      return (sucesso, mensagem, usuarioRetorno);
    } else {
      return (false, mensagem, null);
    }
  }
}
