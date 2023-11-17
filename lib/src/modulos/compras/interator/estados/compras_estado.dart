import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';

sealed class ComprasEstado {}

class ComprasEstadoInicial extends ComprasEstado {}

class ComprasCarregando extends ComprasEstado {}

class ComprasCarregado extends ComprasEstado {
  final List<ComprasModelo> compras;

  ComprasCarregado({required this.compras});
}

class ComprasErroAoListar extends ComprasEstado {
  final Exception erro;

  ComprasErroAoListar({required this.erro});
}
