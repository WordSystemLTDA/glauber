sealed class VerificarPagamentoEstado {}

class VerificarPagamentoEstadoInicial implements VerificarPagamentoEstado {}

class Verificando implements VerificarPagamentoEstado {}

class SucessoAoVerificar implements VerificarPagamentoEstado {}

class ErroAoVerificar implements VerificarPagamentoEstado {
  final Exception erro;

  ErroAoVerificar({required this.erro});
}
