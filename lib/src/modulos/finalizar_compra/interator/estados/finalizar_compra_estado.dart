sealed class FinalizarCompraEstado {}

class FinalizarCompraEstadoInicial implements FinalizarCompraEstado {}

class Carregando implements FinalizarCompraEstado {}

class CompraRealizadaComSucesso implements FinalizarCompraEstado {}

class ErroAoTentarComprar implements FinalizarCompraEstado {
  final Exception erro;

  ErroAoTentarComprar({required this.erro});
}
