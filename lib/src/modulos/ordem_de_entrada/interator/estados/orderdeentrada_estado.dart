import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/parceiros_modelo.dart';

sealed class OrdemDeEntradaEstado {}

class OrdemDeEntradaEstadoInicial extends OrdemDeEntradaEstado {}

class OrdemDeEntradaCarregando extends OrdemDeEntradaEstado {}

class OrdemDeEntradaCarregado extends OrdemDeEntradaEstado {
  final List<ParceirosModelos> ordemdeentradas;

  OrdemDeEntradaCarregado({required this.ordemdeentradas});
}

class OrdemDeEntradaErroAoListar extends OrdemDeEntradaEstado {
  final Exception erro;

  OrdemDeEntradaErroAoListar({required this.erro});
}
