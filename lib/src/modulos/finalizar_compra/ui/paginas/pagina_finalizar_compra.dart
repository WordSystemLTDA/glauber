import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/compartilhado/widgets/termos_de_uso.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/finalizar_compra_estado.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/listar_informacoes_estado.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/formulario_compra_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/listar_informacoes_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/finalizar_compra_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/listar_informacoes_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/paginas/pagina_sucesso_compra.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provider/provider.dart';

class PaginaFinalizarCompra extends StatefulWidget {
  final List<ProvaModelo> provas;
  final String idEvento;
  const PaginaFinalizarCompra({super.key, required this.idEvento, required this.provas});

  @override
  State<PaginaFinalizarCompra> createState() => _PaginaFinalizarCompraState();
}

class _PaginaFinalizarCompraState extends State<PaginaFinalizarCompra> {
  bool concorda = false;
  String metodoPagamento = "0";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var finalizarCompraStore = context.read<FinalizarCompraStore>();
      var listarInformacoesStore = context.read<ListarInformacoesStore>();

      listarInformacoesStore.listarInformacoes(widget.provas, widget.idEvento);

      finalizarCompraStore.addListener(() {
        FinalizarCompraEstado state = finalizarCompraStore.value;

        if (state is CompraRealizadaComSucesso) {
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return PaginaSucessoCompra(dados: state.dados, metodoPagamento: metodoPagamento);
              },
            ));
          }
        } else if (state is ErroAoTentarComprar) {
          if (mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.erro.toString()),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ));
          }
        }
      });
    });
  }

  void abrirTermosDeUso() {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: TermosDeUso(),
        );
      },
    );
  }

  void salvar(ListarInformacoesModelo dados) {
    var finalizarCompraStore = context.read<FinalizarCompraStore>();
    var usuarioProvider = context.read<UsuarioProvider>();

    finalizarCompraStore.inserir(
      usuarioProvider.usuario,
      FormularioCompraModelo(
        provas: widget.provas,
        idEvento: widget.idEvento,
        idProva: widget.provas[0].id,
        idEmpresa: dados.evento.idEmpresa,
        idFormaPagamento: metodoPagamento,
        valorIngresso: dados.prova.valor,
        valorTaxa: dados.prova.taxaProva,
        valorDesconto: "0",
        valorTotal: (double.parse(dados.prova.valor) + double.parse(dados.prova.taxaProva)).toString(),
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
      appBar: const AppBarSombra(
        titulo: Text("Finalizar Compra"),
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
                        'Métodos de pagamento',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: double.infinity, height: 10),
                      if (state.dados.pagamentos.isEmpty) ...[
                        SizedBox(
                          width: width,
                          child: const Center(child: Text('Nenhum pagamento está diponivel.')),
                        ),
                      ],
                      if (state.dados.pagamentos.isNotEmpty) ...[
                        SizedBox(
                          width: width,
                          child: SegmentedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return const Color.fromARGB(222, 247, 24, 8);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.white;
                                  }
                                  return Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;
                                },
                              ),
                            ),
                            segments: [
                              for (var i = 0; i < state.dados.pagamentos.length; i++)
                                ButtonSegment(
                                  value: state.dados.pagamentos[i].id,
                                  label: Text(
                                    state.dados.pagamentos[i].nome,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                            selected: {metodoPagamento},
                            showSelectedIcon: false,
                            onSelectionChanged: (pagamento) {
                              setState(() {
                                metodoPagamento = pagamento.first;
                              });
                            },
                          ),
                        ),
                      ],
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
                            Utils.coverterEmReal.format(double.parse(state.dados.prova.valor.toString())),
                            style: const TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        ],
                      ),
                      if (double.parse(state.dados.prova.taxaProva) != 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Taxa Admin.',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "+ ${Utils.coverterEmReal.format(double.parse(state.dados.prova.taxaProva))}",
                              style: const TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),
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
                                      Utils.coverterEmReal.format(double.parse(state.dados.prova.valor.toString()) + double.parse(state.dados.prova.taxaProva)),
                                      style: const TextStyle(fontSize: 16, color: Colors.green),
                                    ),
                                  ],
                                ),
                                ValueListenableBuilder(
                                  valueListenable: finalizarCompraStore,
                                  builder: (context, stateFinalizarCompra, _) {
                                    return AbsorbPointer(
                                      absorbing: !concorda || metodoPagamento == '0' || stateFinalizarCompra is Carregando,
                                      child: SizedBox(
                                        width: 150,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(
                                              (!concorda || metodoPagamento == '0' || stateFinalizarCompra is Carregando) ? Colors.grey : const Color.fromARGB(255, 247, 24, 8),
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
                                          abrirTermosDeUso();
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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
