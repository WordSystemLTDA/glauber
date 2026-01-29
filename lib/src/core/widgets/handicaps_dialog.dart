import 'package:flutter/material.dart';
import 'package:provadelaco/src/domain/models/handicaps_modelo.dart';
import 'package:provadelaco/src/data/repositories/handicap_store.dart';
import 'package:provider/provider.dart';

class HandiCapsDialog extends StatefulWidget {
  final List<double> mostrarSomente;
  final Function(HandiCapsModelos itemHC, List<HandiCapsModelos> handicaps) aoMudar;

  const HandiCapsDialog({super.key, this.mostrarSomente = const [], required this.aoMudar});

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
              child: ListenableBuilder(
                listenable: handiCapStore,
                builder: (context, _) {
                  if (handiCapStore.carregando) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(height: 0.5, color: Color.fromARGB(255, 233, 233, 233));
                    },
                    shrinkWrap: true,
                    itemCount: widget.mostrarSomente.isEmpty
                        ? handiCapStore.handicaps.length
                        : handiCapStore.handicaps.where((element) => widget.mostrarSomente.contains(double.parse(element.valor))).toList().length,
                    // padding: const EdgeInsets.symmetric(vertical: 15),
                    itemBuilder: (context, index) {
                      var item = widget.mostrarSomente.isEmpty
                          ? handiCapStore.handicaps[index]
                          : handiCapStore.handicaps.where((element) => widget.mostrarSomente.contains(double.parse(element.valor))).toList()[index];

                      return ListTile(
                        onTap: () {
                          widget.aoMudar(item, handiCapStore.handicaps);
                        },
                        title: Text(item.nome),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
