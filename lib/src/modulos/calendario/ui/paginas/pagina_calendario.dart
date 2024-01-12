import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/modulos/calendario/interator/stores/agenda_store.dart';
import 'package:provadelaco/src/modulos/calendario/ui/paginas/pagina_ver_evento_calendario.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PaginaCalendario extends StatefulWidget {
  const PaginaCalendario({super.key});

  @override
  State<PaginaCalendario> createState() => _PaginaCalendarioState();
}

class _PaginaCalendarioState extends State<PaginaCalendario> {
  FutureBuilder<void> loadMoreWidgetBuilder(BuildContext context, LoadMoreCallback loadMoreAppointments) {
    final agendaStore = context.read<AgendaStore>();

    return FutureBuilder<void>(
      future: loadMoreAppointments(),
      builder: (context, snapShot) {
        return Container(
          height: agendaStore.calendarioController.view == CalendarView.schedule ? 50 : double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue)),
        );
      },
    );
  }

  void onTap(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      Navigator.pushNamed(context, AppRotas.verEventoCalendario, arguments: PaginaVerEventoCalendarioArgumentos(dados: calendarTapDetails));
    }
  }

  @override
  Widget build(BuildContext context) {
    final agendaStore = context.read<AgendaStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
      ),
      body: Stack(
        children: [
          SfCalendar(
            view: CalendarView.month,
            controller: agendaStore.calendarioController,
            allowViewNavigation: true,

            showNavigationArrow: true,
            dataSource: agendaStore.agendaDataSource,
            showDatePickerButton: true,
            loadMoreWidgetBuilder: loadMoreWidgetBuilder,
            allowedViews: const [
              CalendarView.month,
              CalendarView.day,
              CalendarView.schedule,
            ],

            // appointmentBuilder: appointmentBuilder,
            showTodayButton: true,
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              navigationDirection: MonthNavigationDirection.vertical,
            ),
            onTap: onTap,
            // onViewChanged: agendaStore.viewChanged,
            // onDragEnd: onDragEnd,
          ),
        ],
      ),
    );
  }
}
