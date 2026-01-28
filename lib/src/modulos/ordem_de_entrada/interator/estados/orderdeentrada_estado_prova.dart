import 'package:provadelaco/src/domain/models/prova_parceiros_modelo.dart';

sealed class OrdemDeEntradaEstadoProva {}

class OrdemDeEntradaEstadoProvaInicial extends OrdemDeEntradaEstadoProva {}

class OrdemDeEntradaCarregando extends OrdemDeEntradaEstadoProva {}

class OrdemDeEntradaCarregado extends OrdemDeEntradaEstadoProva {
  final List<ProvaParceirosModelos> ordemdeentradas;

  OrdemDeEntradaCarregado({required this.ordemdeentradas});
}

class OrdemDeEntradaErroAoListar extends OrdemDeEntradaEstadoProva {
  final Exception erro;

  OrdemDeEntradaErroAoListar({required this.erro});
}
