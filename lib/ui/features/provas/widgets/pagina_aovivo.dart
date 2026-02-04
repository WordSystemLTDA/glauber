// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/data/repositories/ordemdeentrada_prova_repository.dart';
import 'package:provadelaco/data/repositories/provas_aovivo_repository.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/domain/models/modelo_prova_ao_vivo.dart';
import 'package:provadelaco/ui/features/ordem_de_entrada/widgets/ordem_de_entrada_card_prova.dart';
import 'package:provadelaco/ui/features/provas/widgets/card_lista_competicao.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaginaAoVivoArgumentos {
  final String idEvento;
  final String idEmpresa;
  final String? idListaCompeticao;
  final String? nomeProva;

  PaginaAoVivoArgumentos({
    required this.idEvento,
    required this.idEmpresa,
    this.idListaCompeticao,
    this.nomeProva,
  });
}

class PaginaAoVivo extends StatefulWidget {
  final PaginaAoVivoArgumentos argumentos;
  const PaginaAoVivo({super.key, required this.argumentos});

  @override
  State<PaginaAoVivo> createState() => _PaginaAoVivoState();
}

class _PaginaAoVivoState extends State<PaginaAoVivo> {
  String idListaCompeticao = '0';
  String nomeProvaSelecionada = '';
  ModeloProvaAoVivo? itemListaCompeticaoSelecionada;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provasAoVivoStore = context.read<ProvasAoVivoStore>();
      var ordemDeEntradaProvaStore = context.read<OrdemDeEntradaProvaStore>();
      var usuarioProvider = context.read<UsuarioProvider>();

      if (widget.argumentos.idListaCompeticao != null) {
        setState(() {
          idListaCompeticao = widget.argumentos.idListaCompeticao!;
          nomeProvaSelecionada = widget.argumentos.nomeProva!;
        });
        ordemDeEntradaProvaStore.listarPorListaCompeticao(usuarioProvider.usuario, idListaCompeticao, widget.argumentos.idEmpresa, widget.argumentos.idEvento);
      }

      provasAoVivoStore.listar(usuarioProvider.usuario, widget.argumentos.idEmpresa, widget.argumentos.idEvento);
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
        body: ListenableBuilder(
          listenable: provasAoVivoStore,
          builder: (context, _) {
            var evento = provasAoVivoStore.evento;
            var listaCompeticao = provasAoVivoStore.listaCompeticao;
            var nomesCabeceira = provasAoVivoStore.nomesCabeceira;

            if (evento != null) {
              return RefreshIndicator(
                onRefresh: () async {
                  if (idListaCompeticao != '0' && idListaCompeticao != '-1' && idListaCompeticao != '-2') {
                    ordemDeEntradaProvaStore.listarPorListaCompeticao(usuarioProvider.usuario, idListaCompeticao, widget.argumentos.idEmpresa, widget.argumentos.idEvento);
                  } else {
                    await provasAoVivoStore.listar(usuarioProvider.usuario, widget.argumentos.idEmpresa, widget.argumentos.idEvento);
                    if (idListaCompeticao == '-1' || idListaCompeticao == '-2') {
                      itemListaCompeticaoSelecionada = provasAoVivoStore.listaCompeticao.where((element) => element.id == itemListaCompeticaoSelecionada!.id).first;
                    }
                  }
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
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
                                        colors: <Color>[const Color(0x8A000000), Colors.black12.withValues(alpha: 0.0)],
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
                                    width: idListaCompeticao == '0' ? 90 : 120,
                                    decoration: const BoxDecoration(color: Color.fromARGB(106, 0, 0, 0), borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: IconButton(
                                      icon: Row(
                                        children: [
                                          const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                                          const SizedBox(width: 10),
                                          Text(idListaCompeticao == '0' ? 'Voltar' : 'Ver Listas', style: const TextStyle(color: Colors.white, fontSize: 14)),
                                        ],
                                      ),
                                      onPressed: () {
                                        if (idListaCompeticao == '0') {
                                          Navigator.pop(context);
                                        } else {
                                          setState(() {
                                            idListaCompeticao = '0';
                                            itemListaCompeticaoSelecionada = null;
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
                      if (listaCompeticao.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              idListaCompeticao == "0" ? 'Listas de Competições!' : "Lista: $nomeProvaSelecionada",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        if (idListaCompeticao != '0') ...[
                          if (idListaCompeticao == '-1' || idListaCompeticao == '-2') ...[
                            Column(
                              children: [
                                if (itemListaCompeticaoSelecionada!.quemEstaCorrendoAgora != null) ...[
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10, top: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Inscrição Atual',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CardOrdemDeEntradaProva(
                                      selecionado: true,
                                      nomeprova: nomeProvaSelecionada,
                                      item: itemListaCompeticaoSelecionada!.quemEstaCorrendoAgora!,
                                      mostrarOpcoes: true,
                                    ),
                                  ),
                                  const Divider(height: 5),
                                ],
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: itemListaCompeticaoSelecionada!.ordemDeEntradas.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(10),
                                  itemBuilder: (context, index) {
                                    var item = itemListaCompeticaoSelecionada!.ordemDeEntradas[index];

                                    return CardOrdemDeEntradaProva(
                                      item: item,
                                      nomeprova: nomeProvaSelecionada,
                                      mostrarOpcoes: true,
                                      selecionado: false,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ] else ...[
                            ListenableBuilder(
                              listenable: ordemDeEntradaProvaStore,
                              builder: (context, _) {
                                if (ordemDeEntradaProvaStore.carregando) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                if (ordemDeEntradaProvaStore.carregando == false) {
                                  if (ordemDeEntradaProvaStore.ordemdeentradas.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                          children: [
                                            Text('Nenhuma ordem de entrada', style: TextStyle(fontSize: 17)),
                                            Text('foi encontrada para essa lista.', style: TextStyle(fontSize: 17)),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return Column(
                                    children: [
                                      if (ordemDeEntradaProvaStore.quemEstaCorrendoAgora != null) ...[
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10, top: 10),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Inscrição Atual',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: CardOrdemDeEntradaProva(
                                            selecionado: true,
                                            nomeprova: nomeProvaSelecionada,
                                            item: ordemDeEntradaProvaStore.quemEstaCorrendoAgora!,
                                            mostrarOpcoes: true,
                                          ),
                                        ),
                                        const Divider(height: 5),
                                      ],
                                      ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: ordemDeEntradaProvaStore.ordemdeentradas.length,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(10),
                                        itemBuilder: (context, index) {
                                          var item = ordemDeEntradaProvaStore.ordemdeentradas[index];

                                          return CardOrdemDeEntradaProva(
                                            item: item,
                                            nomeprova: nomeProvaSelecionada,
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
                                    ordemDeEntradaProvaStore.listar(usuarioProvider.usuario, idListaCompeticao);
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
                                              Text('foi encontrada para essa lista.', style: TextStyle(fontSize: 17)),
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
                        ],
                        if (idListaCompeticao == '0') ...[
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            itemCount: listaCompeticao.length,
                            itemBuilder: (context, index) {
                              var item = listaCompeticao[index];

                              return CardListaCompeticao(
                                item: item,
                                evento: evento,
                                nomesCabeceira: nomesCabeceira,
                                idEvento: widget.argumentos.idEvento,
                                provasCarrinho: const [],
                                aoSelecionar: (itemListaCompeticao) {
                                  setState(() {
                                    idListaCompeticao = itemListaCompeticao.id;
                                    nomeProvaSelecionada = itemListaCompeticao.nome;
                                    itemListaCompeticaoSelecionada = itemListaCompeticao;
                                  });

                                  ordemDeEntradaProvaStore.listarPorListaCompeticao(
                                      usuarioProvider.usuario, itemListaCompeticao.id, widget.argumentos.idEmpresa, widget.argumentos.idEvento);
                                },
                              );
                            },
                          ),
                        ],
                      ],
                      if (listaCompeticao.isEmpty) ...[
                        RefreshIndicator(
                          onRefresh: () async {
                            await provasAoVivoStore.listar(usuarioProvider.usuario, widget.argumentos.idEmpresa, widget.argumentos.idEvento);
                            if (idListaCompeticao == '-1' || idListaCompeticao == '-2') {
                              itemListaCompeticaoSelecionada = provasAoVivoStore.listaCompeticao.where((element) => element.id == itemListaCompeticaoSelecionada!.id).first;
                            }
                          },
                          child: SingleChildScrollView(
                            child: SizedBox(
                              height: 500,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: idListaCompeticao == '0'
                                      ? const Padding(
                                          padding: EdgeInsets.only(top: 50),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Text('Não há nenhuma lista para esse evento.', style: TextStyle(fontSize: 16)),
                                          ),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.only(top: 50),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              children: [
                                                Text('Nenhuma ordem de entrada', style: TextStyle(fontSize: 17)),
                                                Text('foi encontrada para essa lista.', style: TextStyle(fontSize: 17)),
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
              );
            }

            return const Text('Erro ao listar');
          },
        ),
      );
    });
  }
}
