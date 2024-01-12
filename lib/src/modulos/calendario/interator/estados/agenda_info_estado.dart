import 'package:provadelaco/src/modulos/calendario/interator/modelos/agenda_info_modelo.dart';

sealed class AgendaInfoEstado {}

class AgendaInfoEstadoInicial extends AgendaInfoEstado {}

class AgendaInfoCarregando extends AgendaInfoEstado {}

class AgendaInfoCarregado extends AgendaInfoEstado {
  final AgendaInfoModelo agendaInfo;

  AgendaInfoCarregado({required this.agendaInfo});
}

class AgendaInfoErroAoListar extends AgendaInfoEstado {
  final Exception erro;

  AgendaInfoErroAoListar({required this.erro});
}
