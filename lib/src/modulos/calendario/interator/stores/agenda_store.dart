import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provadelaco/src/modulos/calendario/interator/servicos/agenda_servico.dart';
import 'package:provadelaco/src/modulos/calendario/ui/widgets/agenda_datasource.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AgendaStore extends ChangeNotifier {
  AgendaServico agendaServico;
  AgendaDataSource agendaDataSource;

  AgendaStore(this.agendaServico, this.agendaDataSource);

  bool listando = false;
  final CalendarController calendarioController = CalendarController();

  DateTime? _startDate, _endDate;
  CalendarTapDetails? calendarTapDetails;

  void aoClicarAgenda(CalendarTapDetails detalhes) {
    calendarTapDetails = detalhes;
    notifyListeners();
  }

  void resetarAgenda() {
    if (_startDate != null && _endDate != null) {
      listando = true;
      notifyListeners();

      agendaDataSource = AgendaDataSource([], agendaServico);

      agendaDataSource.handleLoadMore(_startDate!, _endDate!).then((value) {
        listando = false;
        notifyListeners();
      });

      notifyListeners();
    }
  }

  void viewChanged(ViewChangedDetails viewChangedDetails) {
    _startDate = viewChangedDetails.visibleDates[0];
    _endDate = viewChangedDetails.visibleDates[viewChangedDetails.visibleDates.length - 1];

    SchedulerBinding.instance.addPostFrameCallback((duration) {
      notifyListeners();
    });
  }
}
