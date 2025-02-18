// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_servico.dart';
import 'package:provadelaco/src/modulos/autenticacao/data/servicos/autenticacao_servico_impl.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/modelos/modelo_modalidades_cadastro.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_preencher_informacoes.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AutenticacaoStore extends ValueNotifier<AutenticacaoEstado> {
  final AutenticacaoServico _autenticacaoServico;

  AutenticacaoStore(this._autenticacaoServico) : super(AutenticacaoEstadoInicial());

  void entrar(BuildContext context, String email, String senha, TiposLogin tiposLogin, String? tokenNotificacao) async {
    value = Carregando();

    if (tiposLogin == TiposLogin.email) {
      await _autenticacaoServico.entrar(email, senha, tiposLogin, null, tokenNotificacao).then((resposta) {
        var (sucesso, mensagem, usuarioRetorno) = resposta;

        if (sucesso) {
          UsuarioServico.salvarUsuario(context, usuarioRetorno!);
          value = Autenticado();
        } else {
          value = AutenticacaoErro(erro: Exception(mensagem));
        }
      }).onError((error, stackTrace) {
        value = AutenticacaoErro(erro: Exception(error));
      });
    } else {
      await listarInformacoesLoginSocial(context, tiposLogin).then((usuario) async {
        if (usuario == null) {
          return;
        }

        await _autenticacaoServico.entrar(email, senha, tiposLogin, usuario, tokenNotificacao).then((resposta) {
          var (sucesso, _, usuarioRetorno) = resposta;

          if (sucesso) {
            UsuarioServico.salvarUsuario(context, usuarioRetorno!);
            value = Autenticado();
          } else {
            value = AutenticacaoErro(erro: Exception('Preencha as informações acima.'));

            Navigator.pushNamed(
              context,
              AppRotas.preencherInformacoes,
              arguments: PaginaPreencherInformacoesArgumentos(usuario: usuario, tokenNotificacao: tokenNotificacao!, tipoLogin: tiposLogin),
            );
          }
        }).onError((error, stackTrace) {
          value = AutenticacaoErro(erro: Exception(error));
        });
      }).onError((error, stackTrace) {
        value = AutenticacaoErro(erro: Exception(error));
      });
    }
  }

  Future<dynamic> listarInformacoesLoginSocial(BuildContext context, tiposLogin) async {
    if (tiposLogin == TiposLogin.google) {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );

      var usuario = await googleSignIn.signIn();

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

  void cadastrarSocial(BuildContext context, usuario, tipoLogin, String nome, hcCabeceira, hcPiseiro) async {
    value = Cadastrando();

    _autenticacaoServico.cadastrarSocial(usuario, tipoLogin, nome, hcCabeceira, hcPiseiro).then((resposta) {
      var (sucesso, mensagem, usuarioRetorno) = resposta;

      if (sucesso) {
        UsuarioServico.salvarUsuario(context, usuarioRetorno!);
        value = Cadastrado();
      } else {
        value = ErroAoCadastrar(erro: Exception(mensagem));
      }
    }).onError((error, stackTrace) {
      value = ErroAoCadastrar(erro: Exception(error));
    });
  }

  void cadastrar({
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
  }) async {
    value = Cadastrando();

    _autenticacaoServico
        .cadastrar(
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
    )
        .then((resposta) {
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
