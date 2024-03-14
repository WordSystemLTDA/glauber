// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardProvasAoVivo extends StatefulWidget {
  final ProvaModelo prova;
  final EventoModelo evento;
  // final bool verificando;
  final List<ProvaModelo> provasCarrinho;
  final List<NomesCabeceiraModelo>? nomesCabeceira;
  final String idEvento;
  final Function(ProvaModelo prova, EventoModelo evento, String quantParceiros) adicionarNoCarrinho;
  final Function(int quantidade, ProvaModelo prova, EventoModelo evento) adicionarAvulsaNoCarrinho;
  final Function(ProvaModelo prova) removerDoCarrinho;

  final Function(ProvaModelo prova)? aoSelecionarProvaAoVivo;

  const CardProvasAoVivo({
    super.key,
    required this.prova,
    required this.idEvento,
    // required this.verificando,
    required this.nomesCabeceira,
    required this.evento,
    required this.provasCarrinho,
    required this.adicionarAvulsaNoCarrinho,
    required this.adicionarNoCarrinho,
    required this.removerDoCarrinho,
    this.aoSelecionarProvaAoVivo,
  });

  @override
  State<CardProvasAoVivo> createState() => _CardProvasAoVivoState();
}

class _CardProvasAoVivoState extends State<CardProvasAoVivo> {
  double tamanhoCard = 110;
  bool verificando = false;

  Color? coresAction(ProvaModelo prova, NomesCabeceiraModelo item) {
    return Colors.red;
  }

  bool existeNoCarrinho(ProvaModelo prova, NomesCabeceiraModelo item) {
    var provaNova = ProvaModelo(
      id: prova.id,
      permitirCompra: prova.permitirCompra,
      hcMinimo: "0",
      hcMaximo: "0",
      avulsa: prova.avulsa,
      quantMaxima: "0",
      quantMinima: "0",
      nomeProva: prova.nomeProva,
      valor: prova.valor,
      habilitarAoVivo: '',
      idCabeceira: item.id,
      somatoriaHandicaps: prova.somatoriaHandicaps,
      competidores: prova.competidores,
      permitirSorteio: prova.permitirSorteio,
    );

    return widget.provasCarrinho.where((element) => element.id == provaNova.id && element.idCabeceira == provaNova.idCabeceira).isNotEmpty;
  }

  int quantidadeExisteCarrinho(ProvaModelo prova, NomesCabeceiraModelo item) {
    return widget.provasCarrinho.where((element) => element.id == prova.id && element.idCabeceira == item.id).length;
  }

  Color coresJaComprou(ProvaModelo prova) {
    return Colors.green;
  }

  void aoClicarNoCard(ProvaModelo prova) {
    if (widget.aoSelecionarProvaAoVivo != null) {
      widget.aoSelecionarProvaAoVivo!(prova);
    }
  }

  @override
  Widget build(BuildContext context) {
    var prova = widget.prova;
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
            aoClicarNoCard(prova);
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
                            child: VerticalDivider(color: coresJaComprou(prova), thickness: 5),
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
                                  prova.nomeProva,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              if (prova.descricao != null && prova.descricao!.isNotEmpty) ...[
                                SizedBox(
                                  width: (width - 90) - 50,
                                  child: Text(
                                    prova.descricao!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: !isDarkMode ? const Color.fromARGB(255, 123, 123, 123) : const Color.fromARGB(255, 208, 208, 208), fontSize: 12),
                                  ),
                                ),
                              ],
                              SizedBox(
                                width: (width - 90) - 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Utils.coverterEmReal.format(double.parse(prova.valor)),
                                      style: const TextStyle(fontSize: 18, color: Colors.green),
                                    ),
                                    if ((prova.hcMinimo.isNotEmpty && prova.hcMaximo.isNotEmpty) && (double.parse(prova.hcMinimo) > 0 && double.parse(prova.hcMaximo) > 0)) ...[
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "HC: ${prova.hcMinimo} á ${prova.hcMaximo}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ],
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
                                      if (widget.aoSelecionarProvaAoVivo != null) {
                                        widget.aoSelecionarProvaAoVivo!(prova);
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
                                              const Text(
                                                'Ver',
                                                // style: TextStyle(color: existeNoCarrinho(prova, item) ? Colors.white : (isDarkMode ? Colors.white : Colors.black)),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          const Text(
                                            'AO VIVO',
                                            // style: TextStyle(color: existeNoCarrinho(prova, item) ? Colors.white : (isDarkMode ? Colors.white : Colors.black)),
                                            textAlign: TextAlign.center,
                                          ),
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
