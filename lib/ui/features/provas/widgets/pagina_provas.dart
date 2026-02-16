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
      backgroundColor: Colors.grey.shade50,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCheckoutButton(valorTotal),
      body: ListenableBuilder(
        listenable: provasStore,
        builder: (context, _) {
          if (provasStore.carregando) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFF71808)));
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
                    backgroundColor: const Color(0xFFF71808), // Ensure visible when collapsed
                    automaticallyImplyLeading: false,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.4),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: const EdgeInsets.only(left: 60, bottom: 16, right: 16),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              evento.nomeEvento.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(DateTime.parse(evento.dataEvento)),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
                              ),
                            ),
                          ),
                        ],
                      ),
                      expandedTitleScale: 1.5, // Less scaling to avoid huge jumps
                      background: Stack(
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
                        ],
                      ),
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
                          labelColor: const Color(0xFFF71808),
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: const Color(0xFFF71808),
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
            Colors.black.withOpacity(0.3),
            Colors.transparent,
            Colors.black.withOpacity(0.8),
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
          }, color: const Color(0xFFF71808)),
          _customActionChip(Icons.description, 'Regulamento', abrirTermosDeUso),
        ],
      ),
    );
  }

  Widget _customActionChip(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ActionChip(
        avatar: Icon(icon, size: 18, color: color ?? Colors.black87),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
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
        gradient: const LinearGradient(colors: [Color(0xFFF71808), Color(0xFFB31206)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRotas.finalizarCompra, arguments: PaginaFinalizarCompraArgumentos(provas: provasCarrinho, idEvento: widget.argumentos.idEvento)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${provasCarrinho.length} ${provasCarrinho.length == 1 ? 'PROVA' : 'PROVAS'} SELECIONADA',
                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text(CurrencyFormatter.coverterEmReal.format(valorTotal), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
      for (var i = 0; i < quantidade; i++) {
        provasCarrinho.add(prova.copyWith(idmodalidade: () => idmodalidade));
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
      color: Colors.grey.shade50, // Match default background
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
