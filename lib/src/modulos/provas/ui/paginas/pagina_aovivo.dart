import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/compartilhado/constantes/dados_fakes.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/estados/orderdeentrada_estado_prova.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/stores/ordemdeentrada_prova_store.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/ui/widgets/card_ordemdeentrada_prova.dart';
import 'package:provadelaco/src/modulos/provas/interator/estados/provas_estado.dart';
import 'package:provadelaco/src/modulos/provas/interator/stores/provas_aovivo_store.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/card_provas_aovivo.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaginaAoVivoArgumentos {
  final String idEvento;
  final String? idProva;
  final String? nomeProva;

  PaginaAoVivoArgumentos({required this.idEvento, this.idProva, this.nomeProva});
}

class PaginaAoVivo extends StatefulWidget {
  final PaginaAoVivoArgumentos argumentos;
  const PaginaAoVivo({super.key, required this.argumentos});

  @override
  State<PaginaAoVivo> createState() => _PaginaAoVivoState();
}

class _PaginaAoVivoState extends State<PaginaAoVivo> {
  String provaSelecionada = '0';
  String nomeProvaSelecionada = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provasAoVivoStore = context.read<ProvasAoVivoStore>();
      var ordemDeEntradaProvaStore = context.read<OrdemDeEntradaProvaStore>();
      var usuarioProvider = context.read<UsuarioProvider>();
      if (widget.argumentos.idProva != null) {
        setState(() {
          provaSelecionada = widget.argumentos.idProva!;
          nomeProvaSelecionada = widget.argumentos.nomeProva!;
        });
        ordemDeEntradaProvaStore.listar(usuarioProvider.usuario, widget.argumentos.idProva!);
      }
      provasAoVivoStore.listar(usuarioProvider.usuario, widget.argumentos.idEvento, 'aovivo');
    });
  }

  @override
  Widget build(BuildContext context) {
    var provasAoVivoStore = context.read<ProvasAoVivoStore>();
    var ordemDeEntradaProvaStore = context.read<OrdemDeEntradaProvaStore>();
    var height = MediaQuery.of(context).size.height;

    return Consumer<UsuarioProvider>(builder: (context, usuarioProvider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ValueListenableBuilder<ProvasEstado>(
          valueListenable: provasAoVivoStore,
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
                  if (provaSelecionada != '0') {
                    ordemDeEntradaProvaStore.atualizarLista(usuarioProvider.usuario, provaSelecionada);
                  } else {
                    provasAoVivoStore.atualizarLista(usuarioProvider.usuario, widget.argumentos.idEvento, 'aovivo');
                  }
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
                                      width: provaSelecionada == '0' ? 90 : 180,
                                      decoration: const BoxDecoration(color: Color.fromARGB(106, 0, 0, 0), borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: IconButton(
                                        icon: Row(
                                          children: [
                                            const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                                            const SizedBox(width: 10),
                                            Text(provaSelecionada == '0' ? 'Voltar' : 'Ver Provas AO VIVO', style: const TextStyle(color: Colors.white, fontSize: 14)),
                                          ],
                                        ),
                                        onPressed: () {
                                          if (provaSelecionada == '0') {
                                            Navigator.pop(context);
                                          } else {
                                            setState(() {
                                              provaSelecionada = '0';
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (provas.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                provaSelecionada == "0" ? 'Provas AO VIVO!' : "Prova: $nomeProvaSelecionada",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          if (provaSelecionada != '0') ...[
                            ValueListenableBuilder<OrdemDeEntradaEstadoProva>(
                              valueListenable: ordemDeEntradaProvaStore,
                              builder: (context, state, _) {
                                if (state is OrdemDeEntradaCarregando) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                if (state is OrdemDeEntradaCarregado) {
                                  if (state.ordemdeentradas.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                          children: [
                                            Text('Nenhuma ordem de entrada', style: TextStyle(fontSize: 17)),
                                            Text('foi encontrada para essa prova.', style: TextStyle(fontSize: 17)),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return Column(
                                    children: [
                                      if (state.ordemdeentradas[0].quemEstaCorrendoAgora != null) ...[
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10, top: 10),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Quem está correndo agora',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: CardOrdemDeEntradaProva(
                                            selecionado: true,
                                            item: state.ordemdeentradas[0].quemEstaCorrendoAgora!,
                                            mostrarOpcoes: true,
                                          ),
                                        ),
                                        const Divider(height: 5),
                                      ],
                                      ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: state.ordemdeentradas.length,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(10),
                                        itemBuilder: (context, index) {
                                          var item = state.ordemdeentradas[index];

                                          return CardOrdemDeEntradaProva(
                                            item: item,
                                            mostrarOpcoes: true,
                                            selecionado: false,
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                }

                                return RefreshIndicator(
                                  onRefresh: () async {
                                    ordemDeEntradaProvaStore.atualizarLista(usuarioProvider.usuario, provaSelecionada);
                                  },
                                  child: SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: SizedBox(
                                      height: height - 200,
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Column(
                                            children: [
                                              Text('Nenhuma ordem de entrada', style: TextStyle(fontSize: 17)),
                                              Text('foi encontrada para essa prova.', style: TextStyle(fontSize: 17)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                          if (provaSelecionada == '0') ...[
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(10),
                              itemCount: provas.length,
                              itemBuilder: (context, index) {
                                var prova = provas[index];

                                return CardProvasAoVivo(
                                  prova: prova,
                                  evento: evento,
                                  // mostrarOpcoes: false,
                                  nomesCabeceira: nomesCabeceira,
                                  idEvento: widget.argumentos.idEvento,
                                  provasCarrinho: const [],
                                  aoSelecionarProvaAoVivo: (prova) {
                                    setState(() {
                                      provaSelecionada = prova.id;
                                      nomeProvaSelecionada = prova.nomeProva;
                                    });

                                    ordemDeEntradaProvaStore.listar(usuarioProvider.usuario, prova.id);
                                  },
                                  adicionarAvulsaNoCarrinho: (quantidade, prova, evento) {
                                    // adicionarAvulsaNoCarrinho(quantidade, prova, evento);
                                  },
                                  adicionarNoCarrinho: (prova, evento, quantParceiros) {
                                    // adicionarNoCarrinho(prova, evento, quantParceiros);
                                  },
                                  removerDoCarrinho: (prova) {},
                                );
                              },
                            ),
                          ],
                        ],
                        if (provas.isEmpty) ...[
                          RefreshIndicator(
                            onRefresh: () async {
                              provasAoVivoStore.atualizarLista(usuarioProvider.usuario, widget.argumentos.idEvento, 'aovivo');
                            },
                            child: SingleChildScrollView(
                              child: SizedBox(
                                height: 500,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: provaSelecionada == '0'
                                        ? const Padding(
                                            padding: EdgeInsets.only(top: 50),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Text('Não há provas AO VIVO para esse evento.', style: TextStyle(fontSize: 16)),
                                            ),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.only(top: 50),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: [
                                                  Text('Nenhuma ordem de entrada', style: TextStyle(fontSize: 17)),
                                                  Text('foi encontrada para essa prova.', style: TextStyle(fontSize: 17)),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
    });
  }
}
