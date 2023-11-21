import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum TiposLoginSocial { google, apple }

class AutenticacaoStore extends ValueNotifier<AutenticacaoEstado> {
  final AutenticacaoServico _autenticacaoServico;

  AutenticacaoStore(this._autenticacaoServico) : super(AutenticacaoEstadoInicial());

  void entrarComEmail(email, senha, String? tokenNotificacao) async {
    value = Carregando();

    _autenticacaoServico.entrar(email, senha, tokenNotificacao).then((sucesso) {
      if (sucesso) {
        value = Autenticado();
      } else {
        value = AutenticacaoErro(erro: Exception('Erro ao tentar entrar!'));
      }
    }).onError((error, stackTrace) {
      value = AutenticacaoErro(erro: Exception(error));
    });
  }

  Future<(bool, dynamic)> listarInformacoesLogin(tipoLoginSocial, tokenNotificacao) async {
    value = Carregando();

    if (tipoLoginSocial == TiposLoginSocial.google) {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );

      var usuario = await googleSignIn.signIn().onError((error, stackTrace) {
        value = AutenticacaoErro(erro: Exception(error));
        return Future.error(error!);
      });

      bool sucesso = await _autenticacaoServico.verificarLoginSocial(usuario, tipoLoginSocial, tokenNotificacao);

      if (sucesso) {
        value = Autenticado();
      }

      return (sucesso, usuario);
    } else if (tipoLoginSocial == TiposLoginSocial.apple) {
      var usuario = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      ).onError((error, stackTrace) {
        value = AutenticacaoErro(erro: Exception(error));
        return Future.error(error!);
      });

      bool sucesso = await _autenticacaoServico.verificarLoginSocial(usuario, tipoLoginSocial, tokenNotificacao);

      if (sucesso) {
        value = Autenticado();
      }

      return (sucesso, usuario);
    }

    return (false, 'Erro');
  }

  void entrarSocial(usuario, TiposLoginSocial tipo, String? tokenNotificacao) async {
    value = Carregando();

    _autenticacaoServico.entrarSocial(usuario, tipo, tokenNotificacao).then((sucesso) {
      if (sucesso) {
        value = Autenticado();
      } else {
        value = AutenticacaoErro(erro: Exception('Erro ao tentar entrar!'));
      }
    }).onError((error, stackTrace) {
      value = AutenticacaoErro(erro: Exception(error));
    });
  }

  void cadastrarSocial(usuario, tipoLogin, hcCabeceira, hcPiseiro) async {
    value = Cadastrando();

    _autenticacaoServico.cadastrarSocial(usuario, tipoLogin, hcCabeceira, hcPiseiro).then((sucesso) {
      if (sucesso) {
        value = Cadastrado();
      } else {
        value = ErroAoCadastrar(erro: Exception('Erro ao tentar cadastrar, tente novamente.'));
      }
    }).onError((error, stackTrace) {
      value = ErroAoCadastrar(erro: Exception(error));
    });
  }

  void cadastrar(nome, apelido, email, senha, hcCabeceira, hcPiseiro) async {
    value = Cadastrando();

    _autenticacaoServico.cadastrar(nome, apelido, email, senha, hcCabeceira, hcPiseiro).then((resposta) {
      var (sucesso, mensagem) = resposta;

      if (sucesso) {
        value = Cadastrado();
      } else {
        value = ErroAoCadastrar(erro: Exception(mensagem));
      }
    }).onError((error, stackTrace) {
      value = ErroAoCadastrar(erro: Exception(error));
    });
  }
}
