import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/handicap_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/modelos/handicaps_modelo.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/handicap_store.dart';
import 'package:provider/provider.dart';

class HandiCapsDialog extends StatefulWidget {
  final Function(HandiCapsModelos itemHC, List<HandiCapsModelos> handicaps) aoMudar;

  const HandiCapsDialog({super.key, required this.aoMudar});

  @override
  State<HandiCapsDialog> createState() => _HandiCapsDialogState();
}

class _HandiCapsDialogState extends State<HandiCapsDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        listar();
      }
    });
  }

  void listar() {
    var handiCapStore = context.read<HandiCapStore>();
    handiCapStore.listar();
  }

  @override
  Widget build(BuildContext context) {
    var handiCapStore = context.read<HandiCapStore>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: SizedBox(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
              child: Text('Selecione um Handicap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const Divider(),
            Expanded(
              child: ValueListenableBuilder<HandiCapEstado>(
                valueListenable: handiCapStore,
                builder: (context, state, _) {
                  if (state is HandiCapCarregando) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is HandiCapCarregado) {
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(height: 0.5, color: Color.fromARGB(255, 233, 233, 233));
                      },
                      shrinkWrap: true,

                      itemCount: state.handicaps.length,
                      // padding: const EdgeInsets.symmetric(vertical: 15),
                      itemBuilder: (context, index) {
                        var item = state.handicaps[index];

                        return ListTile(
                          onTap: () {
                            widget.aoMudar(item, state.handicaps);
                          },
                          title: Text(item.nome),
                        );
                      },
                    );
                  }

                  return const Text('Erro ao tentar Listar HandiCaps');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
