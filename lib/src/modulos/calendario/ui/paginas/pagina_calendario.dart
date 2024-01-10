import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/calendario/ui/widgets/agenda_datasource.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PaginaCalendario extends StatefulWidget {
  const PaginaCalendario({super.key});

  @override
  State<PaginaCalendario> createState() => _PaginaCalendarioState();
}

class _PaginaCalendarioState extends State<PaginaCalendario> {
  final CalendarController calendarioController = CalendarController();
  final AgendaDataSource agendaDataSource = AgendaDataSource([]);

  FutureBuilder<void> loadMoreWidgetBuilder(BuildContext context, LoadMoreCallback loadMoreAppointments) {
    return FutureBuilder<void>(
      future: loadMoreAppointments(),
      builder: (context, snapShot) {
        return Container(
          height: calendarioController.view == CalendarView.schedule ? 50 : double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
      ),
      body: Stack(
        children: [
          SfCalendar(
            view: CalendarView.schedule,
            controller: calendarioController,
            allowViewNavigation: true,
            showNavigationArrow: true,
            dataSource: agendaDataSource,
            showDatePickerButton: true,
            loadMoreWidgetBuilder: loadMoreWidgetBuilder,
            allowedViews: const [
              CalendarView.month,
              CalendarView.day,
              CalendarView.schedule,
            ],
            showTodayButton: true,
            scheduleViewSettings: const ScheduleViewSettings(),
            monthViewSettings: const MonthViewSettings(
              navigationDirection: MonthNavigationDirection.vertical,
            ),
            // onViewChanged: agendaStore.viewChanged,
            // onDragEnd: onDragEnd,
            // onTap: onTap,
            // appointmentBuilder: appointmentBuilder,
          ),
        ],
      ),
    );
  }
}
