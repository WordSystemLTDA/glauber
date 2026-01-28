import 'package:provadelaco/src/domain/models/ordem_de_entrada_modelo.dart';

sealed class OrdemDeEntradaEstado {}

class OrdemDeEntradaEstadoInicial extends OrdemDeEntradaEstado {}

class OrdemDeEntradaCarregando extends OrdemDeEntradaEstado {}

class OrdemDeEntradaCarregado extends OrdemDeEntradaEstado {
  final List<OrdemDeEntradaModelo> ordemdeentradas;

  OrdemDeEntradaCarregado({required this.ordemdeentradas});
}

class OrdemDeEntradaErroAoListar extends OrdemDeEntradaEstado {
  final Exception erro;

  OrdemDeEntradaErroAoListar({required this.erro});
}
