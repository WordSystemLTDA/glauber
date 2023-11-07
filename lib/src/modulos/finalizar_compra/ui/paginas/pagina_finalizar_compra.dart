import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/uteis.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/estados/finalizar_compra_estado.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/estados/listar_informacoes_estado.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/formulario_compra_modelo.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/listar_informacoes_modelo.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/stores/finalizar_compra_store.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/stores/listar_informacoes_store.dart';
import 'package:glauber/src/modulos/finalizar_compra/ui/paginas/pagina_sucesso_compra.dart';
import 'package:provider/provider.dart';

class PaginaFinalizarCompra extends StatefulWidget {
  final String idProva;
  final String idEvento;
  const PaginaFinalizarCompra({super.key, required this.idProva, required this.idEvento});

  @override
  State<PaginaFinalizarCompra> createState() => _PaginaFinalizarCompraState();
}

class _PaginaFinalizarCompraState extends State<PaginaFinalizarCompra> {
  bool concorda = false;
  int metodoPagamento = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var finalizarCompraStore = context.read<FinalizarCompraStore>();
      var listarInformacoesStore = context.read<ListarInformacoesStore>();

      listarInformacoesStore.listarInformacoes(widget.idProva, widget.idEvento);

      finalizarCompraStore.addListener(() {
        FinalizarCompraEstado state = finalizarCompraStore.value;

        if (state is CompraRealizadaComSucesso) {
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return PaginaSucessoCompra(dados: state.dados);
              },
            ));
          }
        }
      });
    });
  }

  void salvar(ListarInformacoesModelo dados) {
    var finalizarCompraStore = context.read<FinalizarCompraStore>();
    finalizarCompraStore.inserir(
      FormularioCompraModelo(
        idProva: widget.idProva,
        idEmpresa: dados.evento.idEmpresa,
        idFormaPagamento: metodoPagamento.toString(),
        valorIngresso: dados.prova.valor,
        valorTaxa: "0",
        valorDesconto: "0",
        valorTotal: dados.prova.valor,
        tipoDeVenda: "Venda",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var finalizarCompraStore = context.read<FinalizarCompraStore>();
    var listarInformacoesStore = context.read<ListarInformacoesStore>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0),
              blurRadius: 10.0,
            )
          ]),
          child: AppBar(
            elevation: 0.0,
            title: const Text("Finalizar Compra"),
          ),
        ),
      ),
      body: ValueListenableBuilder<ListarInformacoesEstado>(
        valueListenable: listarInformacoesStore,
        builder: (context, state, _) {
          if (state is CarregandoInformacoes) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CarregadoInformacoes) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(width: double.infinity, height: 20),
                      const Text(
                        'Método de pagamento',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: double.infinity, height: 10),
                      SizedBox(
                        width: width,
                        child: SegmentedButton(
                          segments: const [
                            ButtonSegment(
                              value: 1,
                              label: Text(
                                'Mercado Pago',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          selected: {metodoPagamento},
                          showSelectedIcon: false,
                          onSelectionChanged: (novoValor) {
                            setState(() {
                              metodoPagamento = novoValor.first;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            Utils.coverterEmReal.format(double.parse(state.dados.prova.valor)),
                            style: const TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text(
                      //       'Taxa Admin.',
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //     Text(
                      //       "+ ${Utils.coverterEmReal.format(5)}",
                      //       style: const TextStyle(fontSize: 16, color: Colors.green),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Total: ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      Utils.coverterEmReal.format(double.parse(state.dados.prova.valor)),
                                      style: const TextStyle(fontSize: 16, color: Colors.green),
                                    ),
                                  ],
                                ),
                                ValueListenableBuilder(
                                  valueListenable: finalizarCompraStore,
                                  builder: (context, stateFinalizarCompra, _) {
                                    return AbsorbPointer(
                                      absorbing: !concorda || metodoPagamento == 0 || stateFinalizarCompra is Carregando,
                                      child: SizedBox(
                                        width: 150,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(
                                              (!concorda || metodoPagamento == 0 || stateFinalizarCompra is Carregando) ? Colors.grey : Colors.green,
                                            ),
                                            foregroundColor: MaterialStateProperty.all(Colors.white),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (stateFinalizarCompra is Carregando) {
                                              return;
                                            }

                                            salvar(state.dados);
                                          },
                                          child: stateFinalizarCompra is Carregando
                                              ? const CircularProgressIndicator(color: Colors.white)
                                              : const Text(
                                                  'Concluir',
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          setState(() {
                            concorda = concorda ? false : true;
                          });
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: concorda,
                              onChanged: (novoValor) {
                                setState(() {
                                  concorda = novoValor!;
                                });
                              },
                            ),
                            SizedBox(
                              width: width - 100,
                              child: RichText(
                                textAlign: TextAlign.left,
                                softWrap: true,
                                text: TextSpan(
                                  text: "Li e aceito o contrato, a politica de privacidade e os ",
                                  style: Theme.of(context).textTheme.titleSmall,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' Termos de uso',
                                      style: const TextStyle(color: Colors.red),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const Dialog(
                                                child: SizedBox(
                                                  height: 230,
                                                  width: 300,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ],
              ),
            );
          }

          return const Text('Erro');
        },
      ),
    );
  }
}
