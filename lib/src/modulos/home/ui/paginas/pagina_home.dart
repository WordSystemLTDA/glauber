import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_selecionar_modalidades.dart';
import 'package:provadelaco/src/data/servicos/home_servico_impl.dart';
import 'package:provadelaco/src/data/repositories/home_store.dart';
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

  TabController? _categoriaController;

  GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeStore homeStore = context.read<HomeStore>();
      homeStore.listar(context, categoriasIndex);

      verificarModalidadesUsuario();
      verificarConfirmarParceiros();

      // homeStore.addListener(() {
      //   HomeEstado state = homeStore.value;

      //   if (state is Carregado) {
      //     if (mounted) {
      //       _categoriaController = TabController(
      //         initialIndex: 0,
      //         length: state.categorias.length,
      //         vsync: this,
      //       );
      //     }

      //     if (_categoriaController != null) {
      //       _categoriaController!.animateTo(categoriasIndex);
      //     }
      //   }
      // });
    });
  }

  @override
  void dispose() {
    if (_categoriaController != null) {
      _categoriaController!.dispose();
    }
    super.dispose();
  }

  void verificarModalidadesUsuario() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var usuario = context.read<UsuarioProvider>().usuario;

      if (usuario == null) return;

      if (usuario.tambores3 == 'Pendente' || usuario.lacoemdupla == 'Pendente' || usuario.lacoindividual == 'Pendente') {
        Navigator.pushNamed(
          context,
          AppRotas.selecionarModalidades,
          arguments: PaginaSelecionarModalidadesArgumentos(
            jaEstaCadastrado: true,
          ),
        );
      }
    });
  }

  Future<void> verificarConfirmarParceiros() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var usuario = context.read<UsuarioProvider>().usuario;

      if (usuario == null) return;

      var servico = context.read<HomeServicoImpl>();
      var usuarioProvider = context.read<UsuarioProvider>();

      var dados = await servico.listarConfirmarParceiros(usuarioProvider.usuario?.id ?? '0');

      if (mounted) {
        if (dados.lacarcabeca.isNotEmpty || dados.lacarpe.isNotEmpty) {
          Navigator.pushNamed(context, AppRotas.confirmarParceiros);
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    HomeStore homeStore = context.read<HomeStore>();

    return ListenableBuilder(
      listenable: homeStore,
      builder: (context, _) {
        return RefreshIndicator(
          onRefresh: () async {
            homeStore.listar(context, categoriasIndex);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                // Carrosel de Eventos
                if (homeStore.eventosTopo.isNotEmpty) ...[
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
                      itemCount: homeStore.eventosTopo.length,
                      itemBuilder: (context, index, realIndex) {
                        var item = homeStore.eventosTopo[index];

                        return CardEventos(
                          evento: item,
                          aparecerInformacoes: true,
                        );
                      },
                    ),
                  ),
                ],
                if (_categoriaController != null && _categoriaController?.length == homeStore.categorias.length) ...[
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

                          homeStore.listar(context, int.parse(homeStore.categorias[categoria].id));
                        },
                        tabs: homeStore.categorias
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
                        length: homeStore.categorias.length,
                        child: TabBar(
                          tabAlignment: TabAlignment.start,
                          dividerColor: Colors.transparent,
                          isScrollable: true,
                          tabs: homeStore.categorias
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
                if (homeStore.propagandas.isNotEmpty) ...[
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
                      itemCount: homeStore.propagandas.length,
                      itemBuilder: (context, index, realIndex) {
                        var item = homeStore.propagandas[index];

                        return CardPropagandas(propaganda: item);
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeStore.eventos.length,
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var item = homeStore.eventos[index];

                    return CardEventos(
                      key: Key(item.id),
                      evento: item,
                      aparecerInformacoes: true,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
