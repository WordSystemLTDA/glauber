import 'package:provadelaco/src/essencial/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';

abstract interface class AutenticacaoServico {
  Future<(bool, UsuarioModelo?)> verificar(UsuarioModelo? usuario, String? tokenNotificacao);
  Future<(bool, UsuarioModelo?)> verificarLoginSocial(dynamic usuario, TiposLoginSocial tipo, String? tokenNotificacao);
  Future<bool> sair(UsuarioModelo? usuario, String? tokenNotificacao);
  Future<bool> excluirConta(UsuarioModelo? usuario, String? tokenNotificacao);
  Future<(bool, UsuarioModelo?)> entrar(String email, String senha, String? tokenNotificacao);
  Future<(bool, UsuarioModelo?)> entrarSocial(dynamic usuario, TiposLoginSocial tipo, String? tokenNotificacao);
  Future<(bool, String)> cadastrar(String nome, String apelido, String email, String senha, String hcCabeceira, String hcPiseiro);
  Future<(bool, UsuarioModelo?)> cadastrarSocial(dynamic usuario, TiposLoginSocial tipo, String hcCabeceira, String hcPiseiro);
}
