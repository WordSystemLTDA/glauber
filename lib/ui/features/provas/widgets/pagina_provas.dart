import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/data/repositories/provas_repository.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/domain/models/evento/evento.dart';
import 'package:provadelaco/domain/models/prova/prova.dart';
import 'package:provadelaco/routing/routes.dart';
import 'package:provadelaco/ui/core/ui/termos_de_uso.dart';
import 'package:provadelaco/ui/features/finalizar_compra/widgets/pagina_finalizar_compra.dart';
import 'package:provadelaco/ui/features/provas/widgets/card_banner_carrossel_evento.dart';
import 'package:provadelaco/ui/features/provas/widgets/modal_localizacao.dart';
import 'package:provadelaco/ui/features/provas/widgets/page_view_provas.dart';
import 'package:provadelaco/ui/features/provas/widgets/pagina_aovivo.dart';
import 'package:provadelaco/utils/currency_formatter.dart';
import 'package:provider/provider.dart';

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
  final carousel.CarouselSliderController _carrosselController = carousel.CarouselSliderController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProvasProvedor>().listar(
            context.read<UsuarioProvider>().usuario,
            widget.argumentos.idEvento,
            '',
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provasStore = context.watch<ProvasProvedor>();

    double valorTotal = provasCarrinho.fold(0, (total, prova) => total + double.parse(prova.valor));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCheckoutButton(valorTotal),
      body: ListenableBuilder(
        listenable: provasStore,
        builder: (context, _) {
          if (provasStore.carregando) {
            return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
          }

          final evento = provasStore.evento;
          if (evento == null) return const Center(child: Text('Evento não encontrado.'));

          return DefaultTabController(
            length: provasStore.provas.length,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 280.0,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    scrolledUnderElevation: 0,
                    forceMaterialTransparency: true,
                    automaticallyImplyLeading: false,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.4),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        final expandedHeight = 280.0;
                        final minHeight = kToolbarHeight;
                        final currentHeight = constraints.biggest.height;
                        final t = ((expandedHeight - currentHeight) / (expandedHeight - minHeight)).clamp(0.0, 1.0);
                        final left = ui.lerpDouble(16.0, 70.0, t) ?? 16.0;
                        final nameFontSize = ui.lerpDouble(20.0, 13.0, t) ?? 13.0;
                        final dateFontSize = ui.lerpDouble(14.0, 10.0, t) ?? 10.0;
                        final dateOpacity = (1.0 - t * 1.5).clamp(0.0, 1.0);

                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            carousel.CarouselSlider.builder(
                              carouselController: _carrosselController,
                              options: carousel.CarouselOptions(
                                height: 320.0,
                                viewportFraction: 1.0,
                                autoPlay: evento.bannersCarrossel.isNotEmpty,
                              ),
                              itemCount: evento.bannersCarrossel.length + 1,
                              itemBuilder: (context, index, _) {
                                final banner = evento.bannersCarrossel.isEmpty ? null : evento.bannersCarrossel[index == 0 ? 0 : index - 1];
                                return CardBannerCarrossel(evento: evento, bannerCarrossel: banner, index: index);
                              },
                            ),
                            _buildGradientOverlay(),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: left, bottom: 16, right: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        evento.nomeEvento,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: nameFontSize,
                                          shadows: const [Shadow(color: Colors.black45, blurRadius: 2)],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (dateOpacity > 0)
                                      Flexible(
                                        child: Opacity(
                                          opacity: dateOpacity,
                                          child: Text(
                                            DateFormat('dd/MM/yyyy').format(DateTime.parse(evento.dataEvento)),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: dateFontSize,
                                              shadows: const [Shadow(color: Colors.black45, blurRadius: 2)],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildActionChips(evento)),
                  if (provasStore.provas.isNotEmpty)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelColor: Theme.of(context).colorScheme.primary,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          dividerColor: Colors.transparent,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          tabs: provasStore.provas.map((m) => Tab(text: m.nomemodalidade)).toList(),
                        ),
                      ),
                    ),
                ];
              },
              body: provasStore.provas.isNotEmpty
                  ? TabBarView(
                      children: provasStore.provas.map((modalidade) {
                        return PageViewProvas(
                          evento: evento,
                          animalPadrao: provasStore.animalPadrao,
                          provas: modalidade.provas,
                          modalidade: modalidade.modalidade,
                          nomesCabeceira: provasStore.nomesCabeceira,
                          provasCarrinho: provasCarrinho,
                          adicionarNoCarrinho: adicionarNoCarrinho,
                          adicionarAvulsaNoCarrinho: adicionarAvulsaNoCarrinho,
                        );
                      }).toList(),
                    )
                  : const Center(child: Text('Nenhuma prova disponível.')),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.3),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.8),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChips(EventoModelo evento) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _customActionChip(Icons.location_on, 'Onde é?', () => abrirLocalizacao(evento)),
          _customActionChip(Icons.live_tv, 'Ao Vivo', () {
            Navigator.pushNamed(context, AppRotas.aovivo, arguments: PaginaAoVivoArgumentos(idEvento: widget.argumentos.idEvento, idEmpresa: evento.idEmpresa));
          }, color: Colors.black87),
          _customActionChip(Icons.description, 'Regulamento', abrirTermosDeUso),
        ],
      ),
    );
  }

  Widget _customActionChip(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ActionChip(
        avatar: Icon(icon, size: 18, color: color ?? Theme.of(context).colorScheme.onSurface),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildCheckoutButton(double valorTotal) {
    if (provasCarrinho.isEmpty) return const SizedBox.shrink();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 65,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [ui.Color.fromARGB(255, 0, 0, 0), ui.Color.fromARGB(255, 170, 170, 170)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: InkWell(
        onTap: _aoTentarFinalizarCompra,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${provasCarrinho.length} ${provasCarrinho.length == 1 ? 'PROVA' : 'PROVAS'} SELECIONADA',
                    style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    CurrencyFormatter.coverterEmReal.format(valorTotal),
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Row(
                children: [
                  Text('CONTINUAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _aoTentarFinalizarCompra() async {
    final usuarioProvider = context.read<UsuarioProvider>();

    if (usuarioProvider.usuario == null) {
      await _mostrarModalLoginObrigatorio();
      return;
    }

    if (!mounted) return;
    Navigator.pushNamed(
      context,
      AppRotas.finalizarCompra,
      arguments: PaginaFinalizarCompraArgumentos(
        provas: provasCarrinho,
        idEvento: widget.argumentos.idEvento,
      ),
    );
  }

  Future<void> _mostrarModalLoginObrigatorio() async {
    final irParaLogin = await showDialog<bool>(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          title: const Text('Login necessário para comprar'),
          content: const Text(
            'Você não pode finalizar a compra agora porque está deslogado. '
            'Precisamos da sua conta para vincular o pedido, confirmar seus dados e liberar o pagamento com segurança.\n\n'
            'Deseja fazer login agora?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(contextDialog).pop(false),
              child: const Text('Depois'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(contextDialog).pop(true),
              child: const Text('Fazer login agora'),
            ),
          ],
        );
      },
    );

    if (!mounted || irParaLogin != true) return;
    Navigator.pushNamed(context, AppRotas.login);
  }

  void adicionarNoCarrinho(ProvaModelo prova, EventoModelo evento, String quantParceiros, String idmodalidade) {
    final provasProvedor = context.read<ProvasProvedor>();
    if (idmodalidade == '3' && provasProvedor.animalSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione um animal primeiro!'), backgroundColor: Colors.orange));
      return;
    }

    setState(() {
      final novaProva = prova.copyWith(animalSelecionado: () => provasProvedor.animalSelecionado, idmodalidade: () => idmodalidade);
      if (provasCarrinho.any((e) => e.id == novaProva.id && e.idCabeceira == novaProva.idCabeceira)) {
        provasCarrinho.removeWhere((e) => e.id == novaProva.id && e.idCabeceira == novaProva.idCabeceira);
      } else {
        provasCarrinho.add(novaProva);
      }
    });
  }

  void adicionarAvulsaNoCarrinho(int quantidade, ProvaModelo prova, EventoModelo evento, String idmodalidade) {
    setState(() {
      provasCarrinho.removeWhere((e) => e.id == prova.id);
      final competidores = prova.competidores ?? [];
      for (var i = 0; i < quantidade; i++) {
        // Para avulsa, cada cópia recebe apenas 1 competidor (1 venda por parceiro)
        final competidor = i < competidores.length ? [competidores[i]] : null;
        provasCarrinho.add(prova.copyWith(
          idmodalidade: () => idmodalidade,
          competidores: () => competidor,
        ));
      }
    });
  }

  void abrirLocalizacao(EventoModelo evento) => showDialog(context: context, builder: (_) => ModalLocalizacao(evento: evento));
  void abrirTermosDeUso() => showDialog(context: context, builder: (_) => const Dialog(child: TermosDeUso()));
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // Match default background
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
