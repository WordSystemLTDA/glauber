sealed class AutenticacaoEstado {}

class AutenticacaoEstadoInicial extends AutenticacaoEstado {}

class Carregando extends AutenticacaoEstado {}

class Autenticado extends AutenticacaoEstado {}

class AutenticacaoErro extends AutenticacaoEstado {
  final Exception erro;
  AutenticacaoErro({required this.erro}) : super();
}

class Cadastrando extends AutenticacaoEstado {}

class Cadastrado extends AutenticacaoEstado {}

class ErroAoCadastrar extends AutenticacaoEstado {
  final Exception erro;
  ErroAoCadastrar({required this.erro}) : super();
}
