// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/firebase/notification_service.dart';
import 'package:provadelaco/src/modulos/calendario/interator/estados/agenda_info_estado.dart';
import 'package:provadelaco/src/modulos/calendario/interator/stores/agenda_info_store.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaVerEventoCalendarioArgumentos {
  final CalendarTapDetails dados;

  PaginaVerEventoCalendarioArgumentos({
    required this.dados,
  });
}

class PaginaVerEventoCalendario extends StatefulWidget {
  final PaginaVerEventoCalendarioArgumentos argumentos;
  const PaginaVerEventoCalendario({super.key, required this.argumentos});

  @override
  State<PaginaVerEventoCalendario> createState() => _PaginaVerEventoCalendarioState();
}

class _PaginaVerEventoCalendarioState extends State<PaginaVerEventoCalendario> {
  bool ativarNotificacao = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        var agendaInfoStore = context.read<AgendaInfoStore>();
        agendaInfoStore.listar(widget.argumentos.dados.appointments![0].id);

        NotificationService().localNotificationsPlugin.pendingNotificationRequests().then((value) {
          var notificacaoAtivada = value.where((element) => element.id == int.parse(widget.argumentos.dados.appointments![0].id));

          if (notificacaoAtivada.isNotEmpty) {
            setState(() {
              ativarNotificacao = true;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var agendaInfoStore = context.read<AgendaInfoStore>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.argumentos.dados.appointments![0].subject),
      ),
      body: ValueListenableBuilder<AgendaInfoEstado>(
        valueListenable: agendaInfoStore,
        builder: (context, state, _) {
          if (state is AgendaInfoCarregando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is AgendaInfoCarregado) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ativar notificação desse evento?',
                        style: TextStyle(fontSize: 16),
                      ),
                      Checkbox(
                        value: ativarNotificacao,
                        onChanged: (value) {
                          var startTime = widget.argumentos.dados.appointments![0].startTime as DateTime;
                          var diferencaDataEmSegundos = startTime.difference(DateTime.now()).inSeconds;

                          if (!(diferencaDataEmSegundos.isNegative)) {
                            setState(() {
                              ativarNotificacao = value!;
                            });

                            if (value == true) {
                              NotificationService().showNotificationScheduled(
                                CustomNotification(
                                  id: int.parse(widget.argumentos.dados.appointments![0].id),
                                  title: 'Evento já disponível',
                                  body: '${widget.argumentos.dados.appointments![0].subject} já está disponivel.',
                                  payload: '',
                                ),
                                Duration(seconds: diferencaDataEmSegundos),
                              );
                            } else {
                              NotificationService().localNotificationsPlugin.cancel(int.parse(widget.argumentos.dados.appointments![0].id));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Não é possível ativar notificação desse evento, pois esse evento já aconteceu.'),
                              ),
                            );
                            if (value == false) {
                              NotificationService().localNotificationsPlugin.cancel(int.parse(widget.argumentos.dados.appointments![0].id));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(state.agendaInfo.link))) {
                        await launchUrl(Uri.parse(state.agendaInfo.link));
                      }
                    },
                    child: const Text('Abrir LINK'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Erro ao listar'));
        },
      ),
    );
  }
}
