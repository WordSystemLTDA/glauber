import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';

abstract interface class AutenticacaoServico {
  Future<bool> verificar(String? tokenNotificacao);
  Future<bool> sair(String? tokenNotificacao);
  Future<bool> entrar(String email, String senha, String? tokenNotificacao);
  Future<bool> entrarSocial(dynamic usuario, TiposLogin tipo, String? tokenNotificacao);
  Future<(bool, String)> cadastrar(String nome, String apelido, String email, String senha, String hcCabeceira, String hcPiseiro);
}
