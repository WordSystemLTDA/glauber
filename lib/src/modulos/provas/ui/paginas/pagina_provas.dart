import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/uteis.dart';
import 'package:glauber/src/modulos/finalizar_compra/ui/paginas/pagina_finalizar_compra.dart';
import 'package:glauber/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:glauber/src/modulos/provas/interator/estados/provas_estado.dart';
import 'package:glauber/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:glauber/src/modulos/provas/interator/stores/provas_store.dart';
import 'package:glauber/src/modulos/provas/ui/widgets/card_provas.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaginaProvas extends StatefulWidget {
  final String idEvento;
  const PaginaProvas({super.key, required this.idEvento});

  @override
  State<PaginaProvas> createState() => _PaginaProvasState();
}

class _PaginaProvasState extends State<PaginaProvas> {
  List<ProvaModelo> provasCarrinho = [];
  List<double> valoresProvasCarrinho = [];

  void adicionarNoCarrinho(ProvaModelo prova, EventoModelo evento) {
    // Irá permitir escolher so um pacote por prova
    if (evento.liberacaoDeCompra == '1') {
      var valoresDuplicados = provasCarrinho.where((element) => element.id == prova.id);

      setState(() {
        if (valoresDuplicados.isNotEmpty) {
          valoresProvasCarrinho.remove(double.parse(valoresDuplicados.firstOrNull!.valor));
          provasCarrinho.remove(valoresDuplicados.first);
        }

        if (provasCarrinho.contains(prova)) {
          provasCarrinho.remove(prova);
          valoresProvasCarrinho.remove(double.parse(prova.valor));
        } else {
          provasCarrinho.add(prova);
          valoresProvasCarrinho.add(double.parse(prova.valor));
        }
      });

      // Poderá escolher multiplos pacotes por prova
    } else if (evento.liberacaoDeCompra == '2') {
      setState(() {
        if (provasCarrinho.contains(prova)) {
          provasCarrinho.remove(prova);
          valoresProvasCarrinho.remove(double.parse(prova.valor));
        } else {
          provasCarrinho.add(prova);
          valoresProvasCarrinho.add(double.parse(prova.valor));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var provasStore = context.read<ProvasStore>();

    double valorTotal = valoresProvasCarrinho.fold(0, (previousValue, element) => previousValue + element);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: provasCarrinho.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return PaginaFinalizarCompra(provas: provasCarrinho, idEvento: widget.idEvento);
                  },
                ));
              },
              label: Row(
                children: [
                  Text("${provasCarrinho.length.toString()} Itens"),
                  const SizedBox(width: 10),
                  Text(
                    Utils.coverterEmReal.format(valorTotal),
                    style: const TextStyle(color: Colors.green),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_ios_outlined),
                ],
              ),
            )
          : Container(),
      body: ValueListenableBuilder<ProvasEstado>(
        valueListenable: provasStore,
        builder: (context, state, _) {
          if (state is ProvasCarregando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProvasCarregado) {
            return Column(
              children: [
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: state.evento!.foto,
                        width: double.infinity,
                        height: 300,
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
                      Align(
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // const Text('CASA DE SHOWS', style: TextStyle(color: Colors.white, fontSize: 16)),
                              Text(state.evento!.nomeEvento, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                              Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(state.evento!.dataEvento)), style: const TextStyle(color: Colors.white, fontSize: 14)),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: const BoxDecoration(color: Color.fromARGB(106, 0, 0, 0), borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: IconButton(
                              icon: const Row(
                                children: [
                                  Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                                  Text('Voltar', style: TextStyle(color: Colors.white, fontSize: 16)),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.location_on_outlined),
                        label: const Text('Localização'),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      ActionChip(
                        avatar: const Icon(Icons.payment_outlined),
                        label: const Text('Pagamentos'),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      ActionChip(
                        avatar: const Icon(Icons.warning_amber),
                        label: const Text('Termos de Uso'),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                if (state.provas.isNotEmpty) ...[
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
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        provasStore.listar(widget.idEvento);
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: state.provas.length,
                        itemBuilder: (context, index) {
                          var prova = state.provas[index];

                          return CardProvas(
                            prova: prova,
                            evento: state.evento!,
                            nomesCabeceira: state.nomesCabeceira!,
                            idEvento: widget.idEvento,
                            provasCarrinho: provasCarrinho,
                            aoClicarNaProva: (prova) {
                              adicionarNoCarrinho(prova, state.evento!);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
                if (state.provas.isEmpty) ...[
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
              ],
            );
          }

          return const Text('Erro ao listar Provas.');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provasStore = context.read<ProvasStore>();
      provasStore.listar(widget.idEvento);
    });
  }
}
