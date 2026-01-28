import 'package:provadelaco/src/domain/models/cartao_modelo.dart';

sealed class ListarCartoesEstado {}

class ListarCartoesEstadoInicial implements ListarCartoesEstado {}

class CartoesCarregandoInformacoes implements ListarCartoesEstado {}

class CartoesCarregadoInformacoes implements ListarCartoesEstado {
  final List<CartaoModelo> cartoes;

  CartoesCarregadoInformacoes({required this.cartoes});
}

class CartoesErroAoListar implements ListarCartoesEstado {
  final Exception erro;

  CartoesErroAoListar({required this.erro});
}
