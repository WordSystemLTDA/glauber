import 'package:provadelaco/src/domain/models/handicaps_modelo.dart';

sealed class HandiCapEstado {
  final List<HandiCapsModelos> handicaps;

  HandiCapEstado({required this.handicaps});
}

class HandiCapEstadoInicial extends HandiCapEstado {
  HandiCapEstadoInicial() : super(handicaps: []);
}

class HandiCapCarregando extends HandiCapEstado {
  HandiCapCarregando() : super(handicaps: []);
}

class HandiCapCarregado extends HandiCapEstado {
  HandiCapCarregado({required super.handicaps});
}

class HandiCapErro extends HandiCapEstado {
  final Exception erro;
  HandiCapErro({required this.erro}) : super(handicaps: []);
}
