import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/constantes/dados_fakes.dart';
import 'package:provadelaco/src/modulos/home/interator/estados/home_estado.dart';
import 'package:provadelaco/src/modulos/home/interator/stores/home_store.dart';
import 'package:provadelaco/src/modulos/home/ui/widgets/card_eventos.dart';
import 'package:provadelaco/src/modulos/home/ui/widgets/card_propagandas.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaginaHome extends StatefulWidget {
  const PaginaHome({super.key});

  @override
  State<PaginaHome> createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int categoriasIndex = 0;

  TabController? _categoriaController;

  GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeStore homeStore = context.read<HomeStore>();
      homeStore.listar(context, categoriasIndex);

      homeStore.addListener(() {
        HomeEstado state = homeStore.value;

        if (state is Carregado) {
          if (mounted) {
            _categoriaController = TabController(
              initialIndex: 0,
              length: state.categorias.length,
              vsync: this,
            );
          }

          if (_categoriaController != null) {
            _categoriaController!.animateTo(categoriasIndex);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    if (_categoriaController != null) {
      _categoriaController!.dispose();
    }
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    HomeStore homeStore = context.read<HomeStore>();

    return ValueListenableBuilder<HomeEstado>(
      valueListenable: homeStore,
      builder: (context, state, _) {
        var eventosTopo = state is Carregando ? DadosFakes.dadosFakesEventos : state.eventosTopo;
        var eventos = state is Carregando ? DadosFakes.dadosFakesEventos : state.eventos;
        var propagandas = state is Carregando ? DadosFakes.dadosFakesPropagandas : state.propagandas;
        var categorias = state is Carregando ? DadosFakes.dadosFakesCategoria : state.categorias;

        return RefreshIndicator(
          onRefresh: () async {
            homeStore.atualizarLista(context, categoriasIndex);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 30),
            child: Skeletonizer(
              enabled: state is Carregando,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  // Carrosel de Eventos
                  if (eventosTopo.isNotEmpty) ...[
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
                        itemCount: eventosTopo.length,
                        itemBuilder: (context, index, realIndex) {
                          var item = eventosTopo[index];

                          return CardEventos(
                            evento: item,
                            aparecerInformacoes: true,
                          );
                        },
                      ),
                    ),
                  ],
                  if (_categoriaController != null) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 40,
                        child: TabBar(
                          tabAlignment: TabAlignment.start,
                          dividerColor: Colors.transparent,
                          controller: _categoriaController,
                          isScrollable: true,
                          onTap: (categoria) async {
                            if (categoriasIndex == categoria) {
                              return;
                            }

                            setState(() {
                              categoriasIndex = categoria;
                            });

                            homeStore.listar(context, int.parse(categorias[categoria].id));
                          },
                          tabs: categorias
                              .map((e) => Tab(
                                    child: Text(e.nome, style: const TextStyle(fontSize: 16)),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                  // Categorias
                  if (_categoriaController == null) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 40,
                        child: DefaultTabController(
                          length: categorias.length,
                          child: TabBar(
                            tabAlignment: TabAlignment.start,
                            dividerColor: Colors.transparent,
                            isScrollable: true,
                            tabs: categorias
                                .map((e) => Tab(
                                      child: Text(e.nome, style: const TextStyle(fontSize: 16)),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Carrosel de Propagandas
                  const SizedBox(height: 10),
                  if (propagandas.isNotEmpty) ...[
                    SizedBox(
                      height: 110,
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          height: 110.0,
                          autoPlay: true,
                          aspectRatio: 2.0,
                          pauseAutoPlayOnTouch: true,
                          autoPlayInterval: const Duration(seconds: 20),
                        ),
                        itemCount: propagandas.length,
                        itemBuilder: (context, index, realIndex) {
                          var item = propagandas[index];

                          return CardPropagandas(propaganda: item);
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: eventos.length,
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var item = eventos[index];

                      return CardEventos(
                        evento: item,
                        aparecerInformacoes: true,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
