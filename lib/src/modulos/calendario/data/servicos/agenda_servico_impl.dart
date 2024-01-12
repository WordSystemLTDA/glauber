import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:provadelaco/src/compartilhado/constantes/hexcolor.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/modulos/calendario/interator/modelos/agenda_info_modelo.dart';
import 'package:provadelaco/src/modulos/calendario/interator/servicos/agenda_servico.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AgendaServicoImpl implements AgendaServico {
  final IHttpClient client;

  AgendaServicoImpl(this.client);

  @override
  Future<AgendaInfoModelo?> listarPorId(String idCalendario) async {
    var url = 'calendario/listar_por_id.php?idCalendario=$idCalendario';

    final response = await client.get(url: url);

    print(response.data);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.data);

      return AgendaInfoModelo.fromMap(jsonData);
    }

    return null;
  }

  @override
  Future<List<Appointment>?> listar(List<dynamic>? events, String startDate, String endDate) async {
    var url = 'calendario/listar.php?startDate=$startDate&endDate=$endDate';

    try {
      final response = await client.get(url: url);

      if (response.statusCode == 200) {
        final List<Appointment> appointmentData = [];
        var jsonData = jsonDecode(response.data);

        for (var data in jsonData) {
          Appointment apps = Appointment(
            id: data['id'],
            startTime: DateTime.parse(data['startTime']),
            endTime: DateTime.parse(data['endTime']),
            color: HexColor(data['color']),
            subject: data['subject'],
            notes: data['notes'],
            isAllDay: data['isAllDay'],
            recurrenceRule: data['recurrenceRule'],
          );

          if (events!.contains(apps)) {
            continue;
          }

          appointmentData.add(apps);
        }

        return appointmentData;
      }
    } on DioException catch (exception) {
      return Future.error('Verifique sua conexão', exception.stackTrace);
    } catch (exception, stacktrace) {
      return Future.error('Verifique sua conexão', stacktrace);
    }

    return Future.error('Ocorreu um erro, tente novamente.');
  }
}
