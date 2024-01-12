import 'package:provadelaco/src/modulos/calendario/interator/modelos/agenda_info_modelo.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

abstract interface class AgendaServico {
  Future<List<Appointment>?> listar(List<dynamic>? events, String startDate, String endDate);
  Future<AgendaInfoModelo?> listarPorId(String idCalendario);
}
