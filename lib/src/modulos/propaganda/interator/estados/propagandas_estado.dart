import 'package:provadelaco/src/domain/models/propaganda_modelo.dart';

sealed class PropagandasEstado {}

class PropagandasEstadoInicial extends PropagandasEstado {}

class PropagandasCarregando extends PropagandasEstado {}

class PropagandasCarregado extends PropagandasEstado {
  final PropagandaModelo? propagandas;

  PropagandasCarregado({required this.propagandas});
}

class PropagandasErroAoListar extends PropagandasEstado {
  final Exception erro;

  PropagandasErroAoListar({required this.erro});
}
