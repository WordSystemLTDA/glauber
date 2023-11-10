import 'package:flutter/foundation.dart';
import 'package:glauber/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:glauber/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';

class AutenticacaoStore extends ValueNotifier<AutenticacaoEstado> {
  final AutenticacaoServico _autenticacaoServico;

  AutenticacaoStore(this._autenticacaoServico) : super(AutenticacaoEstadoInicial());

  void entrar(email, senha) async {
    value = Carregando();

    _autenticacaoServico.entrar(email, senha).then((sucesso) {
      if (sucesso) {
        value = Autenticado();
      } else {
        value = AutenticacaoErro(erro: Exception('Erro ao tentar entrar!'));
      }
    }).onError((error, stackTrace) {
      value = AutenticacaoErro(erro: Exception(error));
    });
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
