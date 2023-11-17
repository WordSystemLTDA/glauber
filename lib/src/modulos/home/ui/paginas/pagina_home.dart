import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/home/interator/estados/home_estado.dart';
import 'package:provadelaco/src/modulos/home/interator/stores/home_store.dart';
import 'package:provadelaco/src/modulos/home/ui/widgets/card_eventos.dart';
import 'package:provadelaco/src/modulos/home/ui/widgets/card_propagandas.dart';
import 'package:provider/provider.dart';

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

                        return CardEventos(evento: item);
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeStore homeStore = context.read<HomeStore>();
      homeStore.listar();
    });

    _categoriaController = TabController(
      initialIndex: 0,
      length: categorias.length,
      vsync: this,
    );
  }
}
