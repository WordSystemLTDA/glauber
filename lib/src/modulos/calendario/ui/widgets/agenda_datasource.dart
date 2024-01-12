import 'package:intl/intl.dart';
import 'package:provadelaco/src/modulos/calendario/interator/servicos/agenda_servico.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AgendaDataSource extends CalendarDataSource {
  final AgendaServico servicoAgenda;

  AgendaDataSource(List<Appointment> source, this.servicoAgenda) {
    appointments = source;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    List<Appointment> atendimentos = (await servicoAgenda.listar(
      appointments,
      DateFormat('yyyy-MM-dd').format(startDate),
      DateFormat('yyyy-MM-dd').format(endDate),
    ))!;

    appointments!.addAll(atendimentos);

    notifyListeners(CalendarDataSourceAction.add, atendimentos);
  }
}
