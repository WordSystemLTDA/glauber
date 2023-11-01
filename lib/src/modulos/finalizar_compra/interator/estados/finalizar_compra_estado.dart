sealed class FinalizarCompraEstado {}

class FinalizarCompraEstadoInicial implements FinalizarCompraEstado {}

class Carregando implements FinalizarCompraEstado {}

class CompraRealizada implements FinalizarCompraEstado {}

class ErroAoTentarComprar implements FinalizarCompraEstado {
  final Exception erro;

  ErroAoTentarComprar({required this.erro});
}
