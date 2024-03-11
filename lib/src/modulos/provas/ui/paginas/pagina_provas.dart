import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/dados_fakes.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/compartilhado/widgets/termos_de_uso.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/verificar_permitir_compra_estado.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/pagamentos_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/verificar_permitir_compra_provedor.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/paginas/pagina_finalizar_compra.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/estados/provas_estado.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/stores/provas_store.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/card_provas.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/modal_denunciar.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/modal_detalhes_prova.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/modal_localizacao.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/modal_pagamentos_disponiveis.dart';
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

  late VerificarPermitirCompraProvedor verificarPermitirCompraProvedor;
  late Function() li;

  @override
  void initState() {
    super.initState();

    verificarPermitirCompraProvedor = context.read<VerificarPermitirCompraProvedor>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provasStore = context.read<ProvasStore>();
      var usuarioProvider = context.read<UsuarioProvider>();
      provasStore.listar(usuarioProvider.usuario, widget.argumentos.idEvento);

      li = listenerVerificacaoCompra();
      verificarPermitirCompraProvedor.addListener(li);
    });
  }

  @override
  void dispose() {
    if (mounted) {
      verificarPermitirCompraProvedor.removeListener(li);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provasStore = context.read<ProvasStore>();

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    double valorTotal = provasCarrinho.fold(0, (previousValue, element) => previousValue + double.parse(element.valor));

    return PopScope(
      onPopInvoked: (didPop) {
        verificarPermitirCompraProvedor.removeListener(li);
      },
      child: Consumer<UsuarioProvider>(builder: (context, usuarioProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible: provasCarrinho.isNotEmpty,
            child: SizedBox(
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
                label: Row(
                  children: [
                    Text("${provasCarrinho.length.toString()} ${provasCarrinho.length == 1 ? 'Item' : 'Itens'}"),
                    const SizedBox(width: 10),
                    Text(
                      Utils.coverterEmReal.format(valorTotal),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_ios_outlined),
                  ],
                ),
              ),
            ),
          ),
          body: ValueListenableBuilder<ProvasEstado>(
            valueListenable: provasStore,
            builder: (context, state, _) {
              var evento = state is ProvasCarregando ? DadosFakes.dadosFakesEventos[0] : state.evento;
              var provas = state is ProvasCarregando ? DadosFakes.dadosFakesProvas : state.provas;
              var nomesCabeceira = state is ProvasCarregando ? DadosFakes.dadosFakesNomesCabeceira : state.nomesCabeceira;

              if (state is ErroAoCarregar) {
                return const Text('Erro ao listar Provas.');
              }

              if (evento != null) {
                return RefreshIndicator(
                  onRefresh: () async {
                    provasStore.atualizarLista(usuarioProvider.usuario, widget.argumentos.idEvento);
                  },
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Skeletonizer(
                      enabled: state is ProvasCarregando,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 250,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: evento.foto,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(value: downloadProgress.progress),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                Skeleton.ignore(
                                  child: GestureDetector(
                                    onTap: () {
                                      final imageProvider = Image.network(evento.foto).image;
                                      showImageViewer(
                                        context,
                                        imageProvider,
                                        useSafeArea: true,
                                        immersive: false,
                                        doubleTapZoomable: true,
                                      );
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 300,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            end: const Alignment(0.0, -0.6),
                                            begin: const Alignment(0.0, 0),
                                            colors: <Color>[const Color(0x8A000000), Colors.black12.withOpacity(0.0)],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
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
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent, // Needed for invisible things to be tapped.
                                    onTap: () {},
                                    child: const SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Padding(
                                        padding: EdgeInsets.all(9.0), // Configure hit area.
                                      ),
                                    ),
                                  ),
                                ),
                                Skeleton.ignore(
                                  child: SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        width: 90,
                                        decoration: const BoxDecoration(color: Color.fromARGB(106, 0, 0, 0), borderRadius: BorderRadius.all(Radius.circular(10))),
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
                                  // const SizedBox(width: 10),
                                  // ActionChip(
                                  //   avatar: const Icon(Icons.payment_outlined),
                                  //   label: const Text('Pagamentos'),
                                  //   onPressed: () {
                                  //     abrirPagamentosDisponiveis(state.pagamentosDisponiveis!);
                                  //   },
                                  // ),
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
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Escolha sua Prova',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            ValueListenableBuilder<VerificarPermitirCompraEstado>(
                              valueListenable: verificarPermitirCompraProvedor,
                              builder: (context, statePermitir, _) {
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(10),
                                  itemCount: provas.length,
                                  itemBuilder: (context, index) {
                                    var prova = provas[index];

                                    return CardProvas(
                                      prova: prova,
                                      evento: evento,
                                      verificando: statePermitir is VerificandoPermitirCompra && statePermitir.idProvaVerificando == prova.id,
                                      nomesCabeceira: nomesCabeceira,
                                      idEvento: widget.argumentos.idEvento,
                                      provasCarrinho: provasCarrinho,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                          if (provas.isEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Não há provas para esse evento.',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                          Padding(
                            padding: EdgeInsets.only(top: setarTamanhoTopo(height, state)),
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
                                  padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: provasCarrinho.isNotEmpty ? 110 : (Platform.isAndroid ? 50 : 20)),
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
                                                child: Text(
                                                  " ${evento.nomeCidade}",
                                                  style: const TextStyle(fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          Row(
                                            children: [
                                              const Icon(Icons.date_range, size: 20),
                                              Opacity(
                                                opacity: 0.6,
                                                child: Text(
                                                  " ${DateFormat('dd/MM/yyyy').format(DateTime.parse(evento.dataEvento))}",
                                                  style: const TextStyle(fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'Descrição do evento',
                                        style: TextStyle(fontSize: 16),
                                      ),
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
                                                backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                                                elevation: MaterialStatePropertyAll(0),
                                                side: MaterialStatePropertyAll<BorderSide>(
                                                  BorderSide(
                                                    width: 1,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                'Termos de Uso',
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: width / 2.4,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                abrirDenunciar(state);
                                              },
                                              style: const ButtonStyle(
                                                backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                                                elevation: MaterialStatePropertyAll(0),
                                                side: MaterialStatePropertyAll<BorderSide>(
                                                  BorderSide(
                                                    width: 1,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                'Denunciar',
                                                style: TextStyle(color: Colors.red),
                                              ),
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
                    ),
                  ),
                );
              }

              return const Text('Erro ao listar Provas.');
            },
          ),
        );
      }),
    );
  }

  void adicionarNoCarrinho(ProvaModelo prova, EventoModelo evento, String quantParceiros) {
    var novaProva = ProvaModelo(
      id: prova.id,
      nomeProva: prova.nomeProva,
      valor: prova.valor,
      hcMinimo: prova.hcMinimo,
      hcMaximo: prova.hcMaximo,
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
        avulsa: prova.avulsa,
        quantMinima: prova.quantMinima,
        quantMaxima: prova.quantMaxima,
        permitirCompra: prova.permitirCompra,
        idCabeceira: prova.idCabeceira,
        competidores: prova.competidores,
        nomeCabeceira: prova.nomeCabeceira,
        somatoriaHandicaps: prova.somatoriaHandicaps,
        sorteio: prova.sorteio,
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

  void abrirLocalizacao(evento) {
    showDialog(
      context: context,
      builder: (context) {
        return ModalLocalizacao(evento: evento);
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

  void Function() listenerVerificacaoCompra() {
    return () {
      var provasStore = context.read<ProvasStore>();
      var usuarioProvider = context.read<UsuarioProvider>();
      VerificarPermitirCompraEstado state = verificarPermitirCompraProvedor.value;

      if (state is SucessoAoVerificarPermitirCompra) {
        if (state.permitirCompraModelo.liberado) {
          var provaModelo = ProvaModelo(
            id: state.provaModelo.id,
            permitirCompra: state.provaModelo.permitirCompra,
            nomeProva: state.provaModelo.nomeProva,
            permitirSorteio: state.provaModelo.permitirSorteio,
            valor: state.provaModelo.valor,
            hcMinimo: state.provaModelo.hcMinimo,
            avulsa: state.provaModelo.avulsa,
            quantMaxima: state.permitirCompraModelo.quantMaximaAvulsa == null ? state.provaModelo.quantMaxima : state.permitirCompraModelo.quantMaximaAvulsa!,
            quantMinima: state.provaModelo.quantMinima,
            hcMaximo: state.provaModelo.hcMaximo,
            idCabeceira: state.idCabeceira,
            somatoriaHandicaps: state.provaModelo.somatoriaHandicaps,
            competidores: state.provaModelo.competidores,
          );

          if (provaModelo.avulsa == 'Sim') {
            if (mounted) {
              showModalBottomSheet(
                showDragHandle: true,
                isScrollControlled: true,
                context: context,
                builder: (contextModal) {
                  return ModalDetalhesProva(
                    prova: provaModelo,
                    quantParceiros: state.permitirCompraModelo.quantParceiros,
                    provasCarrinho: provasCarrinho,
                    adicionarNoCarrinho: (quantidade, listaCompetidores, sorteio) {
                      var novaProva = ProvaModelo(
                        id: provaModelo.id,
                        nomeProva: provaModelo.nomeProva,
                        valor: provaModelo.valor,
                        permitirSorteio: provaModelo.permitirSorteio,
                        permitirCompra: provaModelo.permitirCompra,
                        hcMinimo: "0",
                        hcMaximo: "0",
                        avulsa: provaModelo.avulsa,
                        quantMaxima: "0",
                        quantMinima: "0",
                        sorteio: sorteio,
                        idCabeceira: provaModelo.idCabeceira,
                        somatoriaHandicaps: provaModelo.somatoriaHandicaps,
                        competidores: listaCompetidores,
                      );

                      if (quantidade == 0) {
                        setState(() {
                          provasCarrinho.removeWhere((element) => element.id == novaProva.id && element.idCabeceira == novaProva.idCabeceira);
                        });
                        Navigator.pop(context);
                        return true;
                      }

                      // if ((provaModelo.permitirSorteio == 'Sim' && sorteio == false) &&
                      //     state.permitirCompraModelo.permVincularParceiro == 'Sim' &&
                      //     listaCompetidores.where((element) => element.id == '').isNotEmpty) {
                      //   return false;
                      // }
                      if (state.permitirCompraModelo.permVincularParceiro == 'Sim' &&
                          ((provaModelo.permitirSorteio == 'Sim' && sorteio == true) ? false : listaCompetidores.where((element) => element.id == '').isNotEmpty)) {
                        return false;
                      }

                      adicionarAvulsaNoCarrinho(quantidade, novaProva, state.eventoModelo);

                      Navigator.pop(context);

                      return true;
                    },
                  );
                },
              );
            }
          } else {
            if (int.tryParse(state.permitirCompraModelo.quantParceiros!) != null ? int.parse(state.permitirCompraModelo.quantParceiros!) == 0 : false) {
              var novaProva = ProvaModelo(
                id: provaModelo.id,
                nomeProva: provaModelo.nomeProva,
                valor: provaModelo.valor,
                permitirSorteio: provaModelo.permitirSorteio,
                permitirCompra: provaModelo.permitirCompra,
                hcMinimo: "0",
                hcMaximo: "0",
                avulsa: provaModelo.avulsa,
                quantMaxima: "0",
                quantMinima: "0",
                sorteio: false,
                idCabeceira: provaModelo.idCabeceira,
                somatoriaHandicaps: provaModelo.somatoriaHandicaps,
                competidores: provaModelo.competidores,
              );

              adicionarNoCarrinho(novaProva, state.eventoModelo, state.permitirCompraModelo.quantParceiros!);
            } else {
              if (mounted) {
                showModalBottomSheet(
                  showDragHandle: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (contextModal) {
                    return ModalDetalhesProva(
                      prova: provaModelo,
                      quantParceiros: state.permitirCompraModelo.quantParceiros,
                      provasCarrinho: provasCarrinho,
                      adicionarNoCarrinho: (quantidade, listaCompetidores, sorteio) {
                        var novaProva = ProvaModelo(
                          id: provaModelo.id,
                          nomeProva: provaModelo.nomeProva,
                          valor: provaModelo.valor,
                          permitirSorteio: provaModelo.permitirSorteio,
                          permitirCompra: provaModelo.permitirCompra,
                          hcMinimo: "0",
                          hcMaximo: "0",
                          avulsa: provaModelo.avulsa,
                          quantMaxima: "0",
                          quantMinima: "0",
                          sorteio: sorteio,
                          idCabeceira: provaModelo.idCabeceira,
                          somatoriaHandicaps: provaModelo.somatoriaHandicaps,
                          competidores: listaCompetidores,
                        );

                        if (quantidade == 0) {
                          setState(() {
                            provasCarrinho.removeWhere((element) => element.id == novaProva.id && element.idCabeceira == novaProva.idCabeceira);
                          });
                          Navigator.pop(context);
                          return true;
                        }

                        if (state.permitirCompraModelo.permVincularParceiro == 'Sim' &&
                            ((provaModelo.permitirSorteio == 'Sim' && sorteio == true) ? false : listaCompetidores.where((element) => element.id == '').isNotEmpty)) {
                          return false;
                        }

                        adicionarNoCarrinho(novaProva, state.eventoModelo, state.permitirCompraModelo.quantParceiros!);

                        Navigator.pop(context);

                        return true;
                      },
                    );
                  },
                );
              }
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            if (state.permitirCompraModelo.rota != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Center(child: Text(state.permitirCompraModelo.mensagem)),
                action: SnackBarAction(
                  label: state.permitirCompraModelo.tituloAcao!,
                  onPressed: () {
                    Navigator.pushNamed(context, state.permitirCompraModelo.rota!).then((value) {
                      provasStore.listar(usuarioProvider.usuario, widget.argumentos.idEvento);
                    });
                  },
                ),
                backgroundColor: Colors.red,
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Center(child: Text(state.permitirCompraModelo.mensagem)),
                showCloseIcon: true,
                backgroundColor: Colors.red,
              ));
            }
          }
        }
      }
    };
  }
}
