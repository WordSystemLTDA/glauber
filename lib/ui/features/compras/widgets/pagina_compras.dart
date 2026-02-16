import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/config/config.dart';
import 'package:provadelaco/data/repositories/compras_repository.dart';
import 'package:provadelaco/data/repositories/transferencia_repository.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/data/services/compras_servico.dart';
import 'package:provadelaco/domain/models/clientes/clientes.dart';
import 'package:provadelaco/domain/models/compras/compras.dart';
import 'package:provadelaco/routing/routes.dart';
import 'package:provadelaco/ui/features/compras/widgets/card_compras.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaginaCompras extends StatefulWidget {
  const PaginaCompras({super.key});

  @override
  State<PaginaCompras> createState() => _PaginaComprasState();
}

class _PaginaComprasState extends State<PaginaCompras> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  bool modoTransferencia = false;
  bool modoGerarPagamento = false;
  bool transferindo = false;
  bool gerandoPagamento = false;
  List<ComprasModelo> comprasTransferencia = [];
  List<ComprasModelo> comprasPagamentos = [];
  SearchController pesquisaClientesController = SearchController();
  TextEditingController textoClientesController = TextEditingController();
  String idClienteSelecionado = '0';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController = ScrollController();
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
          listarCompras();
        }
      });

      listarCompras();
    });
  }

  void listarCompras({bool? resetar}) {
    var comprasStore = context.read<ComprasProvedor>();
    var usuarioProvider = context.read<UsuarioProvider>();

    if (usuarioProvider.usuario != null) {
      comprasStore.listar(usuarioProvider.usuario, resetar ?? false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var comprasStore = context.read<ComprasProvedor>();
    var usuarioProvider = context.read<UsuarioProvider>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (usuarioProvider.usuario == null) {
      return Center(
        child: TextButton(
          child: const Text('Você precisa estar logado.'),
          onPressed: () {
            Navigator.pushNamed(context, AppRotas.login);
          },
        ),
      );
    }

    return ListenableBuilder(
      listenable: comprasStore,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: (comprasStore.compras.atuais.isEmpty ||
                  comprasStore.compras.atuais.where((element) => element.compras.where((element2) => element2.pago == 'Não').isNotEmpty).isEmpty)
              ? null
              : _buildFloatingActionButton(),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            // title: const Text(
            //   'Minhas Compras',
            //   style: TextStyle(
            //     color: Colors.black87,
            //     fontWeight: FontWeight.w600,
            //     fontSize: 20,
            //   ),
            // ),
            toolbarHeight: 1,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Anteriores'),
                    Tab(text: 'Atuais'),
                    Tab(text: 'Canceladas'),
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendaItem(color: Colors.green, label: 'Pago'),
                    _buildLegendaItem(color: Colors.red, label: 'Não Pago'),
                    _buildLegendaItem(color: Colors.blue, label: 'Lib. Reemb.'),
                    _buildLegendaItem(color: Colors.yellow, label: 'Canc./Reemb.'),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey[300]),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Skeletonizer(
                      enabled: comprasStore.pagina1 == 1,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          listarCompras(resetar: true);
                        },
                        child: comprasStore.carregando
                            ? const Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Align(alignment: Alignment.topCenter, child: CircularProgressIndicator()),
                              )
                            : comprasStore.compras.anteriores.isEmpty
                                ? SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: SizedBox(
                                      height: height - 200,
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Text('Nenhuma compra foi encontrada.'),
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: comprasStore.compras.anteriores.length + 1,
                                    controller: _scrollController,
                                    padding: const EdgeInsets.all(16),
                                    itemBuilder: (context, index) {
                                      if (index < comprasStore.compras.anteriores.length) {
                                        var item = comprasStore.compras.anteriores[index];

                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.5),
                                                blurRadius: 10,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Theme(
                                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                            child: ExpansionTile(
                                              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              childrenPadding: const EdgeInsets.only(bottom: 8),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              title: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.nomeProva,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    item.nomeEvento,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue.withValues(alpha: 0.1),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Text(
                                                          '${item.compras.length} inscrições',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.blue[700],
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        double.tryParse(item.somaTotal) != null ? double.tryParse(item.somaTotal)!.obterReal() : '',
                                                        style: TextStyle(
                                                          color: Colors.green[700],
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 16,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                                  child: Divider(height: 1, color: Colors.grey[200]),
                                                ),
                                                const SizedBox(height: 8),
                                                ...item.compras.map((e) {
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    child: CardCompras(
                                                      item: e,
                                                      comprasTransferencia: comprasTransferencia,
                                                      aoClicarParaTransferir: (compra) {
                                                        if (comprasTransferencia.contains(compra)) {
                                                          setState(() {
                                                            comprasTransferencia.remove(compra);
                                                          });
                                                        } else {
                                                          setState(() {
                                                            comprasTransferencia.add(compra);
                                                          });
                                                        }
                                                      },
                                                      aoClicarParaGerarPagamento: (compra) {
                                                        if (compra.pago == 'Sim') {
                                                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                            showCloseIcon: true,
                                                            content: Text(
                                                              'Você só pode selecionar inscrições que não foram pagas.',
                                                            ),
                                                          ));
                                                          return;
                                                        }
                                                        if ((compra.idFormaPagamento != '1' &&
                                                            compra.idFormaPagamento != '4' &&
                                                            compra.idFormaPagamento != '5' &&
                                                            compra.idFormaPagamento != '6')) {
                                                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                            showCloseIcon: true,
                                                            content: Text(
                                                              'Você só pode selecionar inscrições que foram geradas pela forma de pagamento PIX.',
                                                            ),
                                                          ));
                                                          return;
                                                        }

                                                        if (comprasPagamentos.isNotEmpty) {
                                                          if (compra.idEmpresa != comprasPagamentos.first.idEmpresa) {
                                                            ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                              showCloseIcon: true,
                                                              content: Text(
                                                                'Essa inscrição não pertence a mesma empresa da primeira inscrição que você selecionou.',
                                                              ),
                                                            ));
                                                            return;
                                                          }

                                                          if (compra.idFormaPagamento != comprasPagamentos.first.idFormaPagamento) {
                                                            ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                              showCloseIcon: true,
                                                              content: Text(
                                                                'Essa inscrição não é da mesma forma de pagamento da primeira inscrição que você selecionou.',
                                                              ),
                                                            ));
                                                            return;
                                                          }
                                                        }

                                                        if (comprasPagamentos.contains(compra)) {
                                                          setState(() {
                                                            comprasPagamentos.remove(compra);
                                                          });
                                                        } else {
                                                          setState(() {
                                                            comprasPagamentos.add(compra);
                                                          });
                                                        }
                                                      },
                                                      comprasPagamentos: comprasPagamentos,
                                                      modoGerarPagamento: modoGerarPagamento,
                                                      modoTransferencia: modoTransferencia,
                                                      atualizarLista: () {
                                                        listarCompras(resetar: true);
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 32),
                                          child: comprasStore.temMaisParaCarregar
                                              ? const Center(child: CircularProgressIndicator())
                                              : const Center(child: Text('Você chegou no fim da lista.')),
                                        );
                                      }
                                    },
                                  ),
                      ),
                    ),
                    Skeletonizer(
                      enabled: comprasStore.pagina2 == 1,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          listarCompras(resetar: true);
                        },
                        child: comprasStore.carregando
                            ? const Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Align(alignment: Alignment.topCenter, child: CircularProgressIndicator()),
                              )
                            : comprasStore.compras.atuais.isEmpty
                                ? SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: SizedBox(
                                      height: height - 200,
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Text('Nenhuma compra foi encontrada.'),
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: comprasStore.compras.atuais.length + 1,
                                    controller: _scrollController,
                                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70),
                                    itemBuilder: (context, index) {
                                      if (index < comprasStore.compras.atuais.length) {
                                        var item = comprasStore.compras.atuais[index];

                                        return SizedBox(
                                          width: width,
                                          child: Card(
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 0,
                                                  top: 0,
                                                  child: Container(
                                                    width: 5,
                                                    height: 90,
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(5),
                                                        bottomLeft: Radius.circular(5),
                                                      ),
                                                    ),
                                                    child: const VerticalDivider(color: Colors.grey, thickness: 5),
                                                  ),
                                                ),
                                                ExpansionTile(
                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  tilePadding: const EdgeInsets.only(right: 20),
                                                  title: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item.nomeProva,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        Text(
                                                          item.nomeEvento,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(fontSize: 13),
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text('Inscrições: ${item.compras.length}'),
                                                            if (item.compras[0].parcelas != '0') ...[
                                                              Text(
                                                                "${item.compras[0].parcelas} x de ${((double.tryParse(item.somaTotal) ?? 0) / num.tryParse(item.compras[0].parcelas)!).obterReal()}",
                                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                                              ),
                                                            ] else ...[
                                                              Text(
                                                                double.tryParse(item.somaTotal) != null ? ((double.tryParse(item.somaTotal) ?? 0)).obterReal() : '',
                                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                                              ),
                                                            ],
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(bottom: 10, top: 0),
                                                      child: Divider(
                                                        height: 1,
                                                      ),
                                                    ),
                                                    ...item.compras.map((e) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(left: 7, right: 7),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            if (e.tipodevenda == 'Filiação' &&
                                                                item.compras.where((element) => element.tipodevenda == 'Filiação').firstOrNull?.id == e.id) ...[
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.orange,
                                                                        borderRadius: BorderRadius.circular(4),
                                                                      ),
                                                                      child: const Text(
                                                                        'Filiação',
                                                                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ] else if ((item.compras.where((element) => element.idCabeceira == '1').firstOrNull?.id == e.id)) ...[
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                                                                child: Text(
                                                                  item.compras.where((element) => element.idCabeceira == '1').firstOrNull?.nomeProva ?? '',
                                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                                ),
                                                              ),
                                                            ] else if ((item.compras.where((element) => element.idCabeceira == '2').firstOrNull?.id == e.id)) ...[
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                                                                child: Text(
                                                                  item.compras.where((element) => element.idCabeceira == '2').firstOrNull?.nomeProva ?? '',
                                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                                ),
                                                              ),
                                                            ],
                                                            CardCompras(
                                                              item: e,
                                                              comprasTransferencia: comprasTransferencia,
                                                              aoClicarParaTransferir: (compra) {
                                                                if (comprasTransferencia.contains(compra)) {
                                                                  setState(() {
                                                                    comprasTransferencia.remove(compra);
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    comprasTransferencia.add(compra);
                                                                  });
                                                                }
                                                              },
                                                              modoTransferencia: modoTransferencia,
                                                              aoClicarParaGerarPagamento: (compra) {
                                                                if (compra.pago == 'Sim') {
                                                                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                    showCloseIcon: true,
                                                                    content: Text(
                                                                      'Você só pode selecionar inscrições que não foram pagas.',
                                                                    ),
                                                                  ));
                                                                  return;
                                                                }
                                                                if ((compra.idFormaPagamento != '1' &&
                                                                    compra.idFormaPagamento != '4' &&
                                                                    compra.idFormaPagamento != '5' &&
                                                                    compra.idFormaPagamento != '6')) {
                                                                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                    showCloseIcon: true,
                                                                    content: Text(
                                                                      'Você só pode selecionar inscrições que foram geradas pela forma de pagamento PIX.',
                                                                    ),
                                                                  ));
                                                                  return;
                                                                }

                                                                if (comprasPagamentos.isNotEmpty) {
                                                                  if (compra.idEmpresa != comprasPagamentos.first.idEmpresa) {
                                                                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                      showCloseIcon: true,
                                                                      content: Text(
                                                                        'Essa inscrição não pertence a mesma empresa da primeira inscrição que você selecionou.',
                                                                      ),
                                                                    ));
                                                                    return;
                                                                  }

                                                                  if (compra.idFormaPagamento != comprasPagamentos.first.idFormaPagamento) {
                                                                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                      showCloseIcon: true,
                                                                      content: Text(
                                                                        'Essa inscrição não é da mesma forma de pagamento da primeira inscrição que você selecionou.',
                                                                      ),
                                                                    ));
                                                                    return;
                                                                  }
                                                                }

                                                                if (comprasPagamentos.contains(compra)) {
                                                                  setState(() {
                                                                    comprasPagamentos.remove(compra);
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    comprasPagamentos.add(compra);
                                                                  });
                                                                }
                                                              },
                                                              comprasPagamentos: comprasPagamentos,
                                                              modoGerarPagamento: modoGerarPagamento,
                                                              atualizarLista: () {
                                                                listarCompras(resetar: true);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                    const SizedBox(height: 7),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 32),
                                          child: comprasStore.temMaisParaCarregar
                                              ? const Center(child: CircularProgressIndicator())
                                              : const Center(child: Text('Você chegou no fim da lista.')),
                                        );
                                      }
                                    },
                                  ),
                      ),
                    ),
                    Skeletonizer(
                      enabled: comprasStore.pagina3 == 1,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          listarCompras(resetar: true);
                        },
                        child: comprasStore.carregando
                            ? const Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Align(alignment: Alignment.topCenter, child: CircularProgressIndicator()),
                              )
                            : comprasStore.compras.canceladas.isEmpty
                                ? SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: SizedBox(
                                      height: height - 200,
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Text('Nenhuma compra foi encontrada.'),
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: comprasStore.compras.canceladas.length + 1,
                                    controller: _scrollController,
                                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70),
                                    itemBuilder: (context, index) {
                                      if (index < comprasStore.compras.canceladas.length) {
                                        var item = comprasStore.compras.canceladas[index];

                                        return SizedBox(
                                          width: width,
                                          child: Card(
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 0,
                                                  top: 0,
                                                  child: Container(
                                                    width: 5,
                                                    height: 90,
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(5),
                                                        bottomLeft: Radius.circular(5),
                                                      ),
                                                    ),
                                                    child: const VerticalDivider(color: Colors.grey, thickness: 5),
                                                  ),
                                                ),
                                                ExpansionTile(
                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  tilePadding: const EdgeInsets.only(right: 20),
                                                  title: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item.nomeProva,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        Text(
                                                          item.nomeEvento,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(fontSize: 13),
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text('Inscrições: ${item.compras.length}'),
                                                            Text(
                                                              double.tryParse(item.somaTotal) != null ? double.tryParse(item.somaTotal)!.obterReal() : '',
                                                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(bottom: 10, top: 0),
                                                      child: Divider(
                                                        height: 1,
                                                      ),
                                                    ),
                                                    ...item.compras.map((e) {
                                                      return Padding(
                                                        padding: const EdgeInsets.only(left: 7, right: 7),
                                                        child: CardCompras(
                                                          item: e,
                                                          comprasTransferencia: comprasTransferencia,
                                                          aoClicarParaTransferir: (compra) {
                                                            if (comprasTransferencia.contains(compra)) {
                                                              setState(() {
                                                                comprasTransferencia.remove(compra);
                                                              });
                                                            } else {
                                                              setState(() {
                                                                comprasTransferencia.add(compra);
                                                              });
                                                            }
                                                          },
                                                          aoClicarParaGerarPagamento: (compra) {},
                                                          comprasPagamentos: comprasPagamentos,
                                                          modoGerarPagamento: modoGerarPagamento,
                                                          modoTransferencia: modoTransferencia,
                                                          atualizarLista: () {
                                                            listarCompras(resetar: true);
                                                          },
                                                        ),
                                                      );
                                                    }),
                                                    const SizedBox(height: 7),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 32),
                                          child: comprasStore.temMaisParaCarregar
                                              ? const Center(child: CircularProgressIndicator())
                                              : const Center(child: Text('Você chegou no fim da lista.')),
                                        );
                                      }
                                    },
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendaItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget? _buildFloatingActionButton() {
    var width = MediaQuery.of(context).size.width;
    var usuarioProvider = context.read<UsuarioProvider>();
    var transferenciaProvedor = context.read<TransferenciaProvedor>();

    return SizedBox(
      width: width - 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // if (comprasStore.compras.anteriores.isNotEmpty && comprasStore.compras.atuais.isNotEmpty) ...[

          // ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (usuarioProvider.usuario != null && usuarioProvider.usuario!.nivel == 'Master') ...[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 40,
                    child: FloatingActionButton.extended(
                      heroTag: null,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: modoTransferencia ? Colors.green : Colors.grey,
                      label: const Text('Transferência'),
                      onPressed: () {
                        setState(() {
                          if (modoTransferencia == true) {
                            modoTransferencia = false;
                            comprasTransferencia.clear();
                          } else {
                            modoTransferencia = true;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
              if (comprasTransferencia.isNotEmpty && usuarioProvider.usuario != null && usuarioProvider.usuario!.nivel == 'Master') ...[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 40,
                    child: FloatingActionButton.extended(
                      heroTag: null,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: modoTransferencia ? Colors.green : Colors.grey,
                      label: Text('Transferir ${comprasTransferencia.length} ${comprasTransferencia.length == 1 ? 'item' : 'itens'}'),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (contextModal) {
                            return ListenableBuilder(
                              listenable: transferenciaProvedor,
                              builder: (context, _) {
                                return GestureDetector(
                                  onTap: () {
                                    FocusScope.of(contextModal).unfocus();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 30,
                                      bottom: MediaQuery.of(contextModal).viewInsets.bottom,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SearchAnchor(
                                          viewBuilder: (suggestions) {
                                            return ListView.builder(
                                              itemCount: suggestions.length,
                                              padding: EdgeInsets.only(bottom: ConstantesGlobal.alturaTeclado),
                                              itemBuilder: (context, index) {
                                                var item = suggestions.elementAt(index);

                                                return item;
                                              },
                                            );
                                          },
                                          isFullScreen: true,
                                          searchController: pesquisaClientesController,
                                          builder: (BuildContext context, SearchController controller) {
                                            return TextField(
                                              onTap: () {
                                                pesquisaClientesController.openView();
                                              },
                                              controller: textoClientesController,
                                              readOnly: true,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                label: Text('Transferir para'),
                                              ),
                                            );
                                          },
                                          suggestionsBuilder: (BuildContext context, SearchController controller) async {
                                            final keyword = controller.value.text;

                                            List<ClientesModelo>? clientes = await context.read<ComprasServico>().listarClientesNormal(keyword);

                                            Iterable<Widget> widgets = clientes.map((cliente) {
                                              return GestureDetector(
                                                onTap: () {
                                                  controller.closeView('');
                                                  setState(() {
                                                    idClienteSelecionado = cliente.id;
                                                    textoClientesController.text = cliente.nome;
                                                  });
                                                  FocusScope.of(context).unfocus();
                                                },
                                                child: Card(
                                                  elevation: 3.0,
                                                  child: ListTile(
                                                    leading: Text(cliente.id),
                                                    title: Text(cliente.nome),
                                                    subtitle: Text(
                                                      cliente.apelido,
                                                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });

                                            return widgets;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              var resposta = await transferenciaProvedor.transferirCompras(comprasTransferencia, idClienteSelecionado);
                                              if (!context.mounted) return;

                                              if (resposta.sucesso) {
                                                Navigator.pop(context);

                                                setState(() {
                                                  comprasTransferencia.clear();
                                                  idClienteSelecionado = '0';
                                                  textoClientesController.text = '';
                                                });

                                                listarCompras(resetar: true);

                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  showCloseIcon: true,
                                                  backgroundColor: Colors.green,
                                                  content: Center(child: Text(resposta.mensagem)),
                                                ));
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  showCloseIcon: true,
                                                  backgroundColor: Colors.red,
                                                  content: Center(child: Text(resposta.mensagem)),
                                                ));
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: const WidgetStatePropertyAll(Colors.green),
                                              foregroundColor: const WidgetStatePropertyAll(Colors.white),
                                              shape: WidgetStatePropertyAll(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                              ),
                                            ),
                                            child: transferenciaProvedor.carregando
                                                ? const Center(
                                                    child: SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 1,
                                                      ),
                                                    ),
                                                  )
                                                : Text('Transferir ${comprasTransferencia.length} ${comprasTransferencia.length == 1 ? 'item' : 'itens'}'),
                                          ),
                                        ),
                                        const SizedBox(height: 40),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(
            height: 40,
            child: FloatingActionButton.extended(
              heroTag: null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              backgroundColor: Colors.green,
              label: const Text('Quero Pagar Agora'),
              onPressed: () {
                Navigator.pushNamed(context, AppRotas.selecionarInscricoes);
                // setState(() {
                //   if (modoGerarPagamento == true) {
                //     modoGerarPagamento = false;
                //     comprasPagamentos.clear();
                //   } else {
                //     modoGerarPagamento = true;
                //   }
                // });
              },
            ),
          ),
        ],
      ),
    );
  }
}
