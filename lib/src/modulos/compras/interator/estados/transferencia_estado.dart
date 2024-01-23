sealed class TransferenciaEstado {}

class TransferenciaEstadoInicial extends TransferenciaEstado {}

class Transferindo extends TransferenciaEstado {}

class TransferidoComSucesso extends TransferenciaEstado {
  final String mensagem;

  TransferidoComSucesso({required this.mensagem});
}

class ErroAoTransferir extends TransferenciaEstado {
  final Exception erro;

  ErroAoTransferir({required this.erro});
}
