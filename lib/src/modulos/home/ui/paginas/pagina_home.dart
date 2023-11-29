import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/constantes/funcoes_global.dart';
import 'package:provadelaco/src/essencial/usuario_provider.dart';
import 'package:provadelaco/src/modulos/home/interator/estados/home_estado.dart';
import 'package:provadelaco/src/modulos/home/interator/stores/home_store.dart';
import 'package:provadelaco/src/modulos/home/ui/widgets/card_eventos.dart';
import 'package:provadelaco/src/modulos/home/ui/widgets/card_propagandas.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaHome extends StatefulWidget {
  const PaginaHome({super.key});

  @override
  State<PaginaHome> createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int categoriasIndex = 0;
  List<String> categorias = ['Todas', 'Provas de Laços', 'Outros', 'Outros', 'Outros'];

  late TabController _categoriaController;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    HomeStore homeStore = context.read<HomeStore>();

    return ValueListenableBuilder<HomeEstado>(
      valueListenable: homeStore,
      builder: (context, state, _) {
        if (state is Carregando) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is Carregado) {
          return RefreshIndicator(
            onRefresh: () async {
              homeStore.listar();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  // Carrosel de Eventos
                  SizedBox(
                    height: 220,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 220.0,
                        autoPlay: true,
                        aspectRatio: 2.0,
                        pauseAutoPlayOnTouch: true,
                        autoPlayInterval: const Duration(seconds: 10),
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                      ),
                      itemCount: state.eventos.length,
                      itemBuilder: (context, index, realIndex) {
                        var item = state.eventos[index];

                        return CardEventos(
                          evento: item,
                          aparecerInformacoes: true,
                        );
                      },
                    ),
                  ),
                  // Categorias
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 40,
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        controller: _categoriaController,
                        isScrollable: true,
                        tabs: categorias
                            .map((e) => Tab(
                                  child: Text(e, style: const TextStyle(fontSize: 16)),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  // Carrosel de Propagandas
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 100.0,
                        autoPlay: true,
                        aspectRatio: 2.0,
                        pauseAutoPlayOnTouch: true,
                        autoPlayInterval: const Duration(seconds: 20),
                      ),
                      itemCount: 2,
                      itemBuilder: (context, index, realIndex) {
                        return const CardPropagandas();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Lista de eventos
                  Flexible(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.eventos.length,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var item = state.eventos[index];

                        return CardEventos(
                          evento: item,
                          aparecerInformacoes: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  void verificarAtualicao() async {
    var dados = context.read<UsuarioProvider>().usuario!;

    if (await FuncoesGlobais.appPrecisaAtualizar(dados.versaoAppAndroid, dados.versaoAppIos) && mounted) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contextDialog) {
          return AlertDialog(
            title: const Text(
              'Atualização disponível',
              style: TextStyle(fontSize: 16),
            ),
            content: Text(Platform.isAndroid ? 'Escolha uma opção para poder atualizar o aplicativo.' : 'Clique no botão ATUALIZAR para poder atualizar o aplicativo'),
            actions: <Widget>[
              if (Platform.isAndroid) ...[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Baixar APK'),
                  onPressed: () async {
                    try {
                      if (await canLaunchUrl(Uri.parse(dados.baixarApk!))) {
                        await launchUrl(Uri.parse(dados.baixarApk!));
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Não foi possível abrir o LINK, entre em contato com o suporte.'),
                            backgroundColor: Colors.red,
                            showCloseIcon: true,
                          ));
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Não foi possível abrir o LINK, entre em contato com o suporte.'),
                          backgroundColor: Colors.red,
                          showCloseIcon: true,
                        ));
                        // print(e);
                      }
                    }
                  },
                ),
              ],
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Atualizar'),
                onPressed: () async {
                  try {
                    if (Platform.isAndroid) {
                      if (await canLaunchUrl(Uri.parse(dados.linkAtualizacaoAndroid!))) {
                        await launchUrl(Uri.parse(dados.linkAtualizacaoAndroid!));
                      }
                    } else if (Platform.isIOS) {
                      if (await canLaunchUrl(Uri.parse(dados.linkAtualizacaoIos!))) {
                        await launchUrl(Uri.parse(dados.linkAtualizacaoIos!));
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Não foi possível abrir o LINK, entre em contato com o suporte.'),
                        backgroundColor: Colors.red,
                        showCloseIcon: true,
                      ));
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeStore homeStore = context.read<HomeStore>();
      homeStore.listar();
      verificarAtualicao();
    });

    _categoriaController = TabController(
      initialIndex: 0,
      length: categorias.length,
      vsync: this,
    );
  }
}
