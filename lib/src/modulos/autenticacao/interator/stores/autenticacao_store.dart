import 'package:flutter/foundation.dart';
import 'package:glauber/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:glauber/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum TiposLogin { email, google, apple }

class AutenticacaoStore extends ValueNotifier<AutenticacaoEstado> {
  final AutenticacaoServico _autenticacaoServico;

  AutenticacaoStore(this._autenticacaoServico) : super(AutenticacaoEstadoInicial());

  void entrar(email, senha, TiposLogin tipo) async {
    value = Carregando();

    if (tipo == TiposLogin.email) {
      _autenticacaoServico.entrar(email, senha).then((sucesso) {
        if (sucesso) {
          value = Autenticado();
        } else {
          value = AutenticacaoErro(erro: Exception('Erro ao tentar entrar!'));
        }
      }).onError((error, stackTrace) {
        value = AutenticacaoErro(erro: Exception(error));
      });
    } else if (tipo == TiposLogin.google) {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );

      await googleSignIn.signIn().then((usuario) {
        if (usuario != null) {
          print(usuario.displayName);
          print(usuario.email);
          print(usuario.photoUrl);
          value = Autenticado();
        } else {
          value = AutenticacaoErro(erro: Exception('Erro ao tentar entrar!'));
        }
      }).onError((error, stackTrace) {
        value = AutenticacaoErro(erro: Exception(error));
      });
      // final GoogleSignInAuthentication autenticacao = await usuario!.authentication;
    } else if (tipo == TiposLogin.apple) {
      await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      ).then((value) {
        print(value);
      }).onError((error, stackTrace) {
        print(error);
        value = AutenticacaoErro(erro: Exception(error));
      });
    }
  }

  void cadastrar(nome, apelido, email, senha, hcCabeceira, hcPiseiro) async {
    value = Cadastrando();

    _autenticacaoServico.cadastrar(nome, apelido, email, senha, hcCabeceira, hcPiseiro).then((valores) {
      if (valores[0]) {
        value = Cadastrado();
      } else {
        value = ErroAoCadastrar(erro: Exception('Erro ao tentar cadastrar!'));
      }
    }).onError((error, stackTrace) {
      value = ErroAoCadastrar(erro: Exception(error));
    });
  }
}
