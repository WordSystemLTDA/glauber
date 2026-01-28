import 'package:provadelaco/src/domain/models/compras_modelo.dart';

sealed class ComprasEstado {}

class ComprasEstadoInicial extends ComprasEstado {}

class ComprasCarregando extends ComprasEstado {
  final List<ComprasModelo> compras;

  ComprasCarregando({required this.compras});
}

class ComprasCarregado extends ComprasEstado {
  final List<ComprasModelo> compras;

  ComprasCarregado({required this.compras});
}

class ComprasErroAoListar extends ComprasEstado {
  final Exception erro;

  ComprasErroAoListar({required this.erro});
}
