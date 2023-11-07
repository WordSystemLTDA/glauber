import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/retorno_compra_modelo.dart';

sealed class FinalizarCompraEstado {}

class FinalizarCompraEstadoInicial implements FinalizarCompraEstado {}

class Carregando implements FinalizarCompraEstado {}

class CompraRealizadaComSucesso implements FinalizarCompraEstado {
  final DadosRetornoCompraModelo dados;

  CompraRealizadaComSucesso({required this.dados});
}

class ErroAoTentarComprar implements FinalizarCompraEstado {
  final Exception erro;

  ErroAoTentarComprar({required this.erro});
}
