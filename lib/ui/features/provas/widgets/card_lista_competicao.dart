// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provadelaco/domain/models/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/domain/models/evento/evento_modelo.dart';
import 'package:provadelaco/domain/models/modelo_prova_ao_vivo.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardListaCompeticao extends StatefulWidget {
  final ModeloProvaAoVivo item;
  final EventoModelo evento;
  // final bool verificando;
  final List<ModeloProvaAoVivo> provasCarrinho;
  final List<NomesCabeceiraModelo>? nomesCabeceira;
  final String idEvento;

  final Function(ModeloProvaAoVivo item)? aoSelecionar;

  const CardListaCompeticao({
    super.key,
    required this.item,
    required this.idEvento,
    // required this.verificando,
    required this.nomesCabeceira,
    required this.evento,
    required this.provasCarrinho,
    this.aoSelecionar,
  });

  @override
  State<CardListaCompeticao> createState() => _CardListaCompeticaoState();
}

class _CardListaCompeticaoState extends State<CardListaCompeticao> {
  double tamanhoCard = 110;
  bool verificando = false;

  Color coresJaComprou(ModeloProvaAoVivo prova) {
    return Colors.green;
  }

  void aoClicarNoCard(ModeloProvaAoVivo item) {
    if (widget.aoSelecionar != null) {
      widget.aoSelecionar!(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    var width = MediaQuery.of(context).size.width;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: width,
      height: tamanhoCard,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            aoClicarNoCard(item);
          },
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              if (verificando) ...[
                const Center(child: CircularProgressIndicator()),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        Skeleton.shade(
                          child: Container(
                            width: 5,
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: VerticalDivider(color: coresJaComprou(item), thickness: 5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (width - 90) - 50,
                                child: Text(
                                  item.nome,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                width: (width - 90) - 50,
                                child: Text(
                                  "Competidores: ${item.ordemDeEntradas.length}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: !isDarkMode ? const Color.fromARGB(255, 123, 123, 123) : const Color.fromARGB(255, 208, 208, 208), fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    height: tamanhoCard,
                    child: Material(
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                        ),
                        child: SizedBox(
                          height: tamanhoCard,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                                  border: Border.all(width: 1, color: const Color.fromARGB(255, 255, 159, 152)),
                                  color: const Color(0xFFfbe5ea),
                                ),
                                width: 90,
                                height: tamanhoCard - 10,
                                child: Material(
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.aoSelecionar != null) {
                                        widget.aoSelecionar!(item);
                                      }
                                    },
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Lottie.asset(
                                                'assets/lotties/aovivo.json',
                                                width: 20,
                                                height: 20,
                                                repeat: true,
                                              ),
                                              const Text('Ver', textAlign: TextAlign.center),
                                            ],
                                          ),
                                          const Text('AO VIVO', textAlign: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
