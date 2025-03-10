import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/dados_fakes.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/compartilhado/widgets/termos_de_uso.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/pagamentos_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/paginas/pagina_finalizar_compra.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/estados/provas_estado.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/stores/provas_store.dart';
import 'package:provadelaco/src/modulos/provas/ui/paginas/pagina_aovivo.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/card_banner_carrossel_evento.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/modal_localizacao.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/modal_pagamentos_disponiveis.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/page_view.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaginaProvasArgumentos {
  final String idEvento;

  PaginaProvasArgumentos({required this.idEvento});
}

class PaginaProvas extends StatefulWidget {
  final PaginaProvasArgumentos argumentos;
  const PaginaProvas({super.key, required this.argumentos});

  @override
  State<PaginaProvas> createState() => _PaginaProvasState();
}

class _PaginaProvasState extends State<PaginaProvas> {
  List<ProvaModelo> provasCarrinho = [];
  final cs.CarouselSliderController _carrosselController = cs.CarouselSliderController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provasStore = context.read<ProvasStore>();
      var usuarioProvider = context.read<UsuarioProvider>();
      provasStore.listar(usuarioProvider.usuario, widget.argumentos.idEvento, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    var provasStore = context.read<ProvasStore>();

    var width = MediaQuery.of(context).size.width;

    double valorTotal = provasCarrinho.fold(0, (previousValue, element) => previousValue + double.parse(element.valor));

    return Consumer<UsuarioProvider>(builder: (context, usuarioProvider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: provasCarrinho.isNotEmpty,
          child: Stack(
            children: [
              SizedBox(
                width: 250,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRotas.finalizarCompra,
                      arguments: PaginaFinalizarCompraArgumentos(provas: provasCarrinho, idEvento: widget.argumentos.idEvento),
                    );
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: const Color.fromARGB(255, 247, 24, 8),
                  label: Column(
                    children: [
                      const Text('Confirmar Inscrição', style: TextStyle(fontSize: 11, color: Colors.white)),
                      Row(
                        children: [
                          Text("${provasCarrinho.length.toString()} ${provasCarrinho.length == 1 ? 'Item' : 'Itens'}"),
                          const SizedBox(width: 10),
                          Text(
                            Utils.coverterEmReal.format(valorTotal),
                            style: const TextStyle(color: Colors.white),
                          ),
                          // const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white),
              ),
            ],
          ),
        ),
        body: ValueListenableBuilder<ProvasEstado>(
          valueListenable: provasStore,
          builder: (context, state, _) {
            var evento = state is ProvasCarregando ? DadosFakes.dadosFakesEventos[0] : state.evento;
            var animalPadrao = state.animalPadrao;
            var provas = state is ProvasCarregando ? DadosFakes.dadosFakesProvas : state.provas;
            var nomesCabeceira = state is ProvasCarregando ? DadosFakes.dadosFakesNomesCabeceira : state.nomesCabeceira;

            if (state is ErroAoCarregar) {
              return const Text('Erro ao listar Provas.');
            }

            if (evento != null) {
              return RefreshIndicator(
                onRefresh: () async {
                  provasStore.atualizarLista(usuarioProvider.usuario, widget.argumentos.idEvento, '');
                },
                child: Skeletonizer(
                  enabled: state is ProvasCarregando,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 250,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 250,
                              child: cs.CarouselSlider.builder(
                                carouselController: _carrosselController,
                                options: cs.CarouselOptions(
                                  height: 250.0,
                                  autoPlay: evento.bannersCarrossel.isNotEmpty ? true : false,
                                  aspectRatio: 2.0,
                                  enableInfiniteScroll: evento.bannersCarrossel.isNotEmpty ? true : false,
                                  pauseAutoPlayOnTouch: true,
                                  viewportFraction: 1.0,
                                  autoPlayInterval: const Duration(seconds: 10),
                                ),
                                itemCount: evento.bannersCarrossel.length + 1,
                                itemBuilder: (context, index, realIndex) {
                                  var bannerCarrossel = evento.bannersCarrossel.isEmpty ? null : evento.bannersCarrossel[index == 0 ? index : (index - 1)];

                                  return CardBannerCarrossel(
                                    evento: evento,
                                    bannerCarrossel: bannerCarrossel,
                                    index: index,
                                  );
                                },
                              ),
                            ),
                            if (evento.bannersCarrossel.isNotEmpty) ...[
                              Positioned(
                                left: 10,
                                top: 0,
                                bottom: 0,
                                child: IconButton(
                                  color: Colors.grey,
                                  onPressed: () {
                                    _carrosselController.previousPage();
                                  },
                                  icon: const Icon(Icons.arrow_back_ios_outlined),
                                ),
                              ),
                            ],
                            if (evento.bannersCarrossel.isNotEmpty) ...[
                              Positioned(
                                right: 10,
                                top: 0,
                                bottom: 0,
                                child: IconButton(
                                  color: Colors.grey,
                                  onPressed: () {
                                    _carrosselController.nextPage();
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                                ),
                              ),
                            ],
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // const Text('CASA DE SHOWS', style: TextStyle(color: Colors.white, fontSize: 16)),
                                    Text(
                                      evento.nomeEvento,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(DateTime.parse(evento.dataEvento)),
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                            Skeleton.ignore(
                              child: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width: 90,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(106, 0, 0, 0),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: IconButton(
                                      icon: const Row(
                                        children: [
                                          Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                                          SizedBox(width: 10),
                                          Text('Voltar', style: TextStyle(color: Colors.white, fontSize: 14)),
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ActionChip(
                                avatar: const Icon(Icons.location_on_outlined),
                                label: const Text('Localização'),
                                onPressed: () {
                                  abrirLocalizacao(evento);
                                },
                              ),
                              const SizedBox(width: 10),
                              ActionChip(
                                avatar: Lottie.asset(
                                  'assets/lotties/aovivo.json',
                                  width: 20,
                                  height: 20,
                                  repeat: true,
                                ),
                                label: const Text('AO VIVO'),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRotas.aovivo,
                                    arguments: PaginaAoVivoArgumentos(
                                      idEvento: widget.argumentos.idEvento,
                                      idEmpresa: evento.idEmpresa,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              ActionChip(
                                avatar: const Icon(Icons.warning_amber),
                                label: const Text('Termos de Uso'),
                                onPressed: () {
                                  abrirTermosDeUso();
                                },
                              ),
                              // const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      if (provas.isNotEmpty && nomesCabeceira != null) ...[
                        // const Padding(
                        //   padding: EdgeInsets.only(left: 10),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text(
                        //       'Escolha sua Prova',
                        //       style: TextStyle(fontSize: 16),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: DefaultTabController(
                            length: provas.length,
                            initialIndex: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TabBar(
                                  isScrollable: true,
                                  tabAlignment: TabAlignment.start,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: provas.map((e) {
                                    return Tab(text: e.nomemodalidade);
                                  }).toList(),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                                    ),
                                    child: TabBarView(
                                      children: provas.map((e) {
                                        return PageViewProvas(
                                          evento: evento,
                                          animalPadrao: animalPadrao,
                                          provas: e.provas,
                                          modalidade: e.modalidade,
                                          nomesCabeceira: nomesCabeceira,
                                          provasCarrinho: provasCarrinho,
                                          state: state,
                                          adicionarAvulsaNoCarrinho: (quantidade, prova, evento) {
                                            adicionarAvulsaNoCarrinho(quantidade, prova, evento);
                                          },
                                          adicionarNoCarrinho: (prova, evento, quantParceiros) {
                                            adicionarNoCarrinho(prova, evento, quantParceiros);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            return const Text('Erro ao listar Provas.');
          },
        ),
      );
    });
  }

  void adicionarNoCarrinho(ProvaModelo prova, EventoModelo evento, String quantParceiros) {
    var novaProva = ProvaModelo(
      id: prova.id,
      nomeProva: prova.nomeProva,
      valor: prova.valor,
      hcMinimo: prova.hcMinimo,
      habilitarAoVivo: '',
      hcMaximo: prova.hcMaximo,
      idListaCompeticao: prova.idListaCompeticao,
      permitirSorteio: prova.permitirSorteio,
      avulsa: prova.avulsa,
      quantMinima: prova.quantMinima,
      quantMaxima: prova.quantMaxima,
      permitirCompra: prova.permitirCompra,
      idCabeceira: prova.idCabeceira,
      competidores: prova.competidores,
      nomeCabeceira: prova.nomeCabeceira,
      somatoriaHandicaps: prova.somatoriaHandicaps,
      sorteio: prova.sorteio,
      permitirEditarParceiros: prova.permitirEditarParceiros,
      liberarReembolso: prova.liberarReembolso,
    );

    if (mounted) {
      setState(() {
        // Irá permitir escolher so um pacote por prova
        if (evento.liberacaoDeCompra == '1') {
          var valoresDuplicados = provasCarrinho.where((element) => element.id == novaProva.id);

          if (provasCarrinho.where((element) => element.id == novaProva.id && element.idCabeceira == novaProva.idCabeceira).isNotEmpty) {
            setState(() {
              provasCarrinho.removeWhere((element) => element.id == novaProva.id && element.idCabeceira == novaProva.idCabeceira);

              if (int.tryParse(quantParceiros) != null && quantParceiros != '0') {
                provasCarrinho.add(novaProva);
              }
            });
          } else if (valoresDuplicados.isNotEmpty) {
            setState(() {
              provasCarrinho.removeWhere((element) => element.id == novaProva.id && element.idCabeceira == novaProva.idCabeceira);
              provasCarrinho.add(novaProva);
            });
          } else {
            setState(() {
              provasCarrinho.add(novaProva);
            });
          }

          // Poderá escolher multiplos pacotes por prova
        } else if (evento.liberacaoDeCompra == '2') {
          if (provasCarrinho.where((element) => element.id == novaProva.id && element.idCabeceira == novaProva.idCabeceira).isNotEmpty) {
            setState(() {
              provasCarrinho.removeWhere((element) => element.id == novaProva.id && element.idCabeceira == novaProva.idCabeceira);
            });
          } else {
            setState(() {
              provasCarrinho.add(novaProva);
            });
          }
        }
      });
    }
  }

  void adicionarAvulsaNoCarrinho(int quantidade, ProvaModelo prova, EventoModelo evento) {
    if (mounted) {
      var novaProva = ProvaModelo(
        id: prova.id,
        nomeProva: prova.nomeProva,
        valor: prova.valor,
        hcMinimo: prova.hcMinimo,
        permitirSorteio: prova.permitirSorteio,
        hcMaximo: prova.hcMaximo,
        idListaCompeticao: prova.idListaCompeticao,
        habilitarAoVivo: '',
        avulsa: prova.avulsa,
        quantMinima: prova.quantMinima,
        quantMaxima: prova.quantMaxima,
        permitirCompra: prova.permitirCompra,
        idCabeceira: prova.idCabeceira,
        competidores: prova.competidores,
        nomeCabeceira: prova.nomeCabeceira,
        somatoriaHandicaps: prova.somatoriaHandicaps,
        sorteio: prova.sorteio,
        permitirEditarParceiros: prova.permitirEditarParceiros,
        liberarReembolso: prova.liberarReembolso,
      );

      // Irá permitir escolher so um pacote por prova
      if (evento.liberacaoDeCompra == '1') {
        var valoresDuplicados = provasCarrinho.where((element) => element.id == novaProva.id);

        if (provasCarrinho.where((element) => element.id == novaProva.id && element.idCabeceira == novaProva.idCabeceira).isNotEmpty) {
          setState(() {
            provasCarrinho.removeWhere((element) => element.id == novaProva.id && element.idCabeceira == novaProva.idCabeceira);
          });
        }

        if (valoresDuplicados.isNotEmpty) {
          setState(() {
            provasCarrinho.removeWhere((element) => element.id == novaProva.id && element.idCabeceira != novaProva.idCabeceira);
          });

          for (var i = 0; i < quantidade; i++) {
            setState(() {
              provasCarrinho.add(novaProva);
            });
          }
        } else {
          for (var i = 0; i < quantidade; i++) {
            setState(() {
              provasCarrinho.add(novaProva);
            });
          }
        }

        // Poderá escolher multiplos pacotes por prova
      } else if (evento.liberacaoDeCompra == '2') {
        if (provasCarrinho.where((element) => element.id == novaProva.id && element.idCabeceira == novaProva.idCabeceira).isNotEmpty) {
          setState(() {
            provasCarrinho.removeWhere((element) => element.id == novaProva.id && element.idCabeceira == novaProva.idCabeceira);
          });
        }

        for (var i = 0; i < quantidade; i++) {
          setState(() {
            provasCarrinho.add(novaProva);
          });
        }
      }
    }
  }

  void abrirLocalizacao(evento) {
    showDialog(
      context: context,
      builder: (context) {
        return ModalLocalizacao(evento: evento);
      },
    );
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

  void abrirPagamentosDisponiveis(List<PagamentosModelo> pagamentosDisponiveis) {
    showDialog(
      context: context,
      builder: (context) {
        return ModalPagamentosDisponiveis(pagamentosDisponiveis: pagamentosDisponiveis);
      },
    );
  }

  double setarTamanhoTopo(double height, state) {
    var provas = state is ProvasCarregando ? DadosFakes.dadosFakesProvas : state.provas;

    if (((height * 0.40) - ((provas.isNotEmpty ? provas.length : 1) * (provas.isNotEmpty ? 110 : 0))).isNegative) {
      return 50;
    } else {
      return (height * 0.40) - ((provas.isNotEmpty ? provas.length : 1) * (provas.isNotEmpty ? 110 : 0));
    }
  }
}
