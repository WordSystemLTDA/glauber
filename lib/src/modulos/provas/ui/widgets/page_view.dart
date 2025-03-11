import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/compartilhado/widgets/termos_de_uso.dart';
import 'package:provadelaco/src/modulos/animais/modelos/modelo_animal.dart';
import 'package:provadelaco/src/modulos/animais/paginas/pagina_animais.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/estados/provas_estado.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/stores/provas_provedor.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/card_provas.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/modal_denunciar.dart';
import 'package:provider/provider.dart';

class PageViewProvas extends StatefulWidget {
  final EventoModelo evento;
  final ModeloAnimal? animalPadrao;
  final List<ProvaModelo> provas;
  final List<NomesCabeceiraModelo>? nomesCabeceira;
  final List<ProvaModelo> provasCarrinho;
  final ProvasEstado state;
  final String modalidade;
  final Function(ProvaModelo prova, EventoModelo evento, String quantParceiros, String modalidade) adicionarNoCarrinho;
  final Function(int quantidade, ProvaModelo prova, EventoModelo evento, String modalidade) adicionarAvulsaNoCarrinho;

  const PageViewProvas({
    super.key,
    required this.evento,
    required this.animalPadrao,
    required this.provas,
    this.nomesCabeceira,
    required this.provasCarrinho,
    required this.state,
    required this.adicionarNoCarrinho,
    required this.adicionarAvulsaNoCarrinho,
    required this.modalidade,
  });

  @override
  State<PageViewProvas> createState() => _PageViewProvasState();
}

class _PageViewProvasState extends State<PageViewProvas> {
  late List<ProvaModelo> provas = [];
  late EventoModelo evento;
  late List<NomesCabeceiraModelo>? nomesCabeceira = [];
  late List<ProvaModelo> provasCarrinho = [];

  @override
  void initState() {
    super.initState();
    setarCampos();
  }

  void setarCampos() {
    provas = widget.provas;
    evento = widget.evento;
    nomesCabeceira = widget.nomesCabeceira;
    provasCarrinho = widget.provasCarrinho;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        var provasProvedor = context.read<ProvasProvedor>();
        provasProvedor.animalSelecionado = widget.animalPadrao;
      }
    });
  }

  void abrirTermosDeUso() {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: TermosDeUso(),
        );
      },
    );
  }

  void abrirDenunciar(ProvasEstado provasEstado) {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return ModalDenunciar(provasEstado: provasEstado);
      },
    );
  }

  void selecionarAnimal() {
    var provasProvedor = context.read<ProvasProvedor>();

    Navigator.pushNamed(context, '/animais', arguments: PaginaAnimaisArgumentos(selecionarAnimais: true)).then((value) {
      var item = value as ModeloAnimal;

      provasProvedor.animalSelecionado = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Consumer<ProvasProvedor>(
      builder: (context, provedor, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              if (widget.modalidade == '3') ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: provedor.animalSelecionado == null
                        ? Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: InkWell(
                              onTap: () {
                                selecionarAnimal();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Selecionar Animal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: InkWell(
                              onTap: () {
                                selecionarAnimal();
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      provedor.animalSelecionado!.foto,
                                      height: 105,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return SizedBox(
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return const Icon(Icons.error_outline, color: Colors.grey, size: 105);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(provedor.animalSelecionado!.nomedoanimal, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          Text(provedor.animalSelecionado!.racadoanimal),
                                          Text(provedor.animalSelecionado!.sexo),
                                          Text(
                                            "${(DateTime.now().year - DateTime.parse(Utils.trocarFormatacaoData(provedor.animalSelecionado!.datanascianimal, pattern: '/', to: '-')).year).toString()} anos",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
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
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                itemCount: provas.length,
                itemBuilder: (context, index) {
                  var prova = provas[index];

                  return CardProvas(
                    prova: prova,
                    evento: evento,
                    nomesCabeceira: nomesCabeceira,
                    idEvento: evento.id,
                    modalidade: widget.modalidade,
                    provasCarrinho: provasCarrinho,
                    adicionarAvulsaNoCarrinho: (quantidade, prova, evento) {
                      widget.adicionarAvulsaNoCarrinho(quantidade, prova, evento, widget.modalidade);
                    },
                    adicionarNoCarrinho: (prova, evento, quantParceiros) {
                      widget.adicionarNoCarrinho(prova, evento, quantParceiros, widget.modalidade);
                    },
                    removerDoCarrinho: (prova) {
                      setState(() {
                        provasCarrinho.removeWhere((element) => element.id == prova.id && element.idCabeceira == prova.idCabeceira);
                      });
                    },
                  );
                },
              ),
              if (provas.isEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Não há provas para essa modalidade.', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
              Padding(
                padding: EdgeInsets.only(top: provas.length > 4 ? 50 : 300),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    ),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: provasCarrinho.isNotEmpty ? 110 : (!kIsWeb && Platform.isAndroid ? 50 : 20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.pin_drop_outlined, size: 20),
                                  Opacity(
                                    opacity: 0.6,
                                    child: Text(" ${evento.nomeCidade}", style: const TextStyle(fontSize: 15)),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                children: [
                                  const Icon(Icons.date_range, size: 20),
                                  Opacity(
                                    opacity: 0.6,
                                    child: Text(" ${DateFormat('dd/MM/yyyy').format(DateTime.parse(evento.dataEvento))}", style: const TextStyle(fontSize: 15)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text('Descrição do evento', style: TextStyle(fontSize: 16)),
                          if (evento.descricao1.isNotEmpty) ...[
                            const SizedBox(height: 15),
                            Text(evento.descricao1),
                          ],
                          if (evento.descricao2.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(evento.descricao2),
                          ],
                          if (evento.descricao1.isEmpty && evento.descricao2.isEmpty) ...[
                            const SizedBox(height: 15),
                            const Text('...'),
                          ],
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width / 2.4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    abrirTermosDeUso();
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                                    elevation: WidgetStatePropertyAll(0),
                                    side: WidgetStatePropertyAll<BorderSide>(
                                      BorderSide(width: 1, color: Colors.grey),
                                    ),
                                  ),
                                  child: const Text('Termos de Uso', style: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: width / 2.4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    abrirDenunciar(widget.state);
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                                    elevation: WidgetStatePropertyAll(0),
                                    side: WidgetStatePropertyAll<BorderSide>(
                                      BorderSide(width: 1, color: Colors.red),
                                    ),
                                  ),
                                  child: const Text('Denunciar', style: TextStyle(color: Colors.red)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
