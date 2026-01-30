// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provadelaco/data/services/autenticacao_servico.dart';
import 'package:provadelaco/data/services/usuario_servico.dart';
import 'package:provadelaco/domain/models/modelo_modalidades_cadastro.dart';
import 'package:provadelaco/routing/routes.dart';
import 'package:provadelaco/ui/features/autenticacao/widgets/pagina_preencher_informacoes.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AutenticacaoStore extends ChangeNotifier {
  final AutenticacaoServico _autenticacaoServico;

  AutenticacaoStore(this._autenticacaoServico) : super();

  bool entrando = false;
  bool cadastrando = false;

  Future<({bool sucesso, String mensagem})> entrar(BuildContext context, String email, String senha, TiposLogin tiposLogin, String? tokenNotificacao) async {
    entrando = true;
    notifyListeners();

    try {
      if (tiposLogin == TiposLogin.email) {
        await _autenticacaoServico.entrar(email, senha, tiposLogin, null, tokenNotificacao).then((resposta) {
          var (sucesso, mensagem, usuarioRetorno) = resposta;

          if (sucesso) {
            UsuarioServico.salvarUsuario(context, usuarioRetorno!);
          }

          return (sucesso: sucesso, mensagem: mensagem);
        }).onError((error, stackTrace) {
          return (sucesso: false, mensagem: error.toString());
        });
      } else {
        await listarInformacoesLoginSocial(context, tiposLogin).then((usuario) async {
          if (usuario == null) {
            return (sucesso: false, mensagem: 'Login cancelado pelo Usuário');
          }

          await _autenticacaoServico.entrar(email, senha, tiposLogin, usuario, tokenNotificacao).then((resposta) {
            var (sucesso, _, usuarioRetorno) = resposta;

            if (sucesso) {
              UsuarioServico.salvarUsuario(context, usuarioRetorno!);
            } else {
              Navigator.pushNamed(
                context,
                AppRotas.preencherInformacoes,
                arguments: PaginaPreencherInformacoesArgumentos(usuario: usuario, tokenNotificacao: tokenNotificacao!, tipoLogin: tiposLogin),
              );
            }
          });
        });
      }

      return (sucesso: true, mensagem: 'Sucesso');
    } catch (e) {
      // value = AutenticacaoErro(erro: Exception(e));
      return (sucesso: false, mensagem: e.toString());
    }
  }

  Future<dynamic> listarInformacoesLoginSocial(BuildContext context, tiposLogin) async {
    if (tiposLogin == TiposLogin.google) {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.authorizationClient.authorizationForScopes(
        [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );

      var usuario = await googleSignIn.authenticate();

      return usuario;
    } else if (tiposLogin == TiposLogin.apple) {
      var usuario = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      return usuario;
    }
  }

  Future<({bool sucesso, String mensagem})> cadastrarSocial(BuildContext context, usuarioCadastro, tipoLogin, String nome, hcCabeceira, hcPiseiro) async {
    cadastrando = true;
    notifyListeners();

    var (:sucesso, :mensagem, :usuario) = await _autenticacaoServico.cadastrarSocial(usuarioCadastro, tipoLogin, nome, hcCabeceira, hcPiseiro);

    if (sucesso) {
      UsuarioServico.salvarUsuario(context, usuario!);
    }

    cadastrando = false;
    notifyListeners();

    return (sucesso: sucesso, mensagem: mensagem);
  }

  Future<({bool sucesso, String mensagem})> cadastrar({
    String? idcliente,
    required String nome,
    required String apelido,
    required String email,
    required String senha,
    required String celular,
    required String cidade,
    required String hcCabeceira,
    required String hcPiseiro,
    required String tipodecategoriaprofissional,
    required String handicaplacoindividual,
    required String datanascimento,
    required String sexo,
    required List<ModeloModalidadesCadastro> modalidades,
    required bool jaEstaCadastrado,
  }) async {
    cadastrando = true;
    notifyListeners();

    var (:sucesso, :mensagem) = await _autenticacaoServico.cadastrar(
      idcliente,
      nome,
      apelido,
      email,
      senha,
      celular,
      cidade,
      hcCabeceira,
      hcPiseiro,
      tipodecategoriaprofissional,
      handicaplacoindividual,
      datanascimento,
      sexo,
      modalidades,
      jaEstaCadastrado,
    );

    cadastrando = false;
    notifyListeners();

    return (sucesso: sucesso, mensagem: mensagem);
  }
}
