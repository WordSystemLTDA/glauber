import 'package:syncfusion_flutter_calendar/calendar.dart';

class AgendaDataSource extends CalendarDataSource {
  AgendaDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    List<Appointment> atendimentos = [
      Appointment(startTime: DateTime.now(), endTime: DateTime.now().add(const Duration(hours: 1))),
      Appointment(startTime: DateTime.now(), endTime: DateTime.now().add(const Duration(hours: 2))),
      Appointment(startTime: DateTime.now(), endTime: DateTime.now().add(const Duration(hours: 3))),
    ];

    appointments!.addAll(atendimentos);

    notifyListeners(CalendarDataSourceAction.add, atendimentos);
  }
}
