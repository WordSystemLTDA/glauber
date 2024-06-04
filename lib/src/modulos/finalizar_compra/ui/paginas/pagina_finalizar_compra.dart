import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/dados_fakes.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/compartilhado/widgets/termos_de_uso.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/finalizar_compra_estado.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/listar_informacoes_estado.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/cartao_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/dados_edicao_venda_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/formulario_compra_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/formulario_editar_compra_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/listar_informacoes_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/finalizar_compra_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/listar_informacoes_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/paginas/pagina_sucesso_compra.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/widgets/card_cartao.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/widgets/modal_selecionar_cartao.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaginaFinalizarCompraArgumentos {
  final List<ProvaModelo> provas;
  final String idEvento;
  bool? editarVenda;
  DadosEdicaoVendaModelo? dadosEdicaoVendaModelo;

  PaginaFinalizarCompraArgumentos({required this.provas, required this.idEvento, this.editarVenda, this.dadosEdicaoVendaModelo});
}

class PaginaFinalizarCompra extends StatefulWidget {
  final PaginaFinalizarCompraArgumentos argumentos;
  const PaginaFinalizarCompra({super.key, required this.argumentos});

  @override
  State<PaginaFinalizarCompra> createState() => _PaginaFinalizarCompraState();
}

class _PaginaFinalizarCompraState extends State<PaginaFinalizarCompra> {
  bool concorda = false;

  String metodoPagamento = "0";
  int parcela = 1;
  CartaoModelo? cartaoSelecionado;
  List<CartaoModelo> cartaoMemoria = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var finalizarCompraStore = context.read<FinalizarCompraStore>();
      var listarInformacoesStore = context.read<ListarInformacoesStore>();
      var usuarioProvider = context.read<UsuarioProvider>();

      listarInformacoesStore.listarInformacoes(usuarioProvider.usuario, widget.argumentos.provas, widget.argumentos.idEvento, widget.argumentos.editarVenda ?? false,
          widget.argumentos.dadosEdicaoVendaModelo?.idVenda ?? '');

      finalizarCompraStore.addListener(() {
        FinalizarCompraEstado state = finalizarCompraStore.value;

        if (state is CompraRealizadaComSucesso) {
          if (widget.argumentos.editarVenda != null && widget.argumentos.editarVenda!) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Sucesso ao editar a forma de pagamento dessa inscrição.'),
                backgroundColor: Colors.green,
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {},
                ),
              ));
              Navigator.pushReplacementNamed(
                context,
                AppRotas.sucessoCompra,
                arguments: PaginaSucessoCompraArgumentos(dados: state.dados, metodoPagamento: metodoPagamento),
              );
            }
          } else {
            if (mounted) {
              Navigator.pushReplacementNamed(
                context,
                AppRotas.sucessoCompra,
                arguments: PaginaSucessoCompraArgumentos(dados: state.dados, metodoPagamento: metodoPagamento),
              );
            }
          }
        } else if (state is ErroAoTentarComprar) {
          if (mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.erro.toString().substring(11)),
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

  bool permitirClickConcluir(stateFinalizarCompra) {
    if (stateFinalizarCompra is Carregando) {
      return false;
    }

    if (concorda && metodoPagamento != '0') {
      if (metodoPagamento == '3' && (cartaoSelecionado != null && parcela != -1)) {
        return true;
      } else if (metodoPagamento != '3') {
        return true;
      }
    }

    return false;
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

    if (widget.argumentos.editarVenda != null && widget.argumentos.editarVenda!) {
      finalizarCompraStore.editar(
        usuarioProvider.usuario,
        FormularioEditarCompraModelo(
          idVenda: widget.argumentos.dadosEdicaoVendaModelo!.idVenda,
          idEvento: widget.argumentos.idEvento,
          idProva: widget.argumentos.provas[0].id,
          idEmpresa: dados.evento.idEmpresa,
          idFormaPagamento: metodoPagamento,
          valorIngresso: dados.prova.valor,
          valorTaxa: dados.prova.taxaProva,
          valorTaxaCartao: metodoPagamento == '3' ? dados.taxaCartao : '0',
          valorDesconto: "0",
          valorTotal: retornarValorTotal(dados).toString(),
          temValorFiliacao: dados.valorAdicional?.valor,
          cartao: cartaoSelecionado,
        ),
      );
    } else {
      // widget.argumentos.provas.map((e) => print(e.toMap()));
      // log('opa', error: widget.argumentos.provas);
      // print(widget.argumentos.provas.where((element) => element.id == '188').length);
      // print(widget.argumentos.provas.where((element) => element.id == '189').length);

      // return;
      finalizarCompraStore.inserir(
        usuarioProvider.usuario,
        FormularioCompraModelo(
          temValorFiliacao: dados.valorAdicional?.valor,
          provas: widget.argumentos.provas,
          idEvento: widget.argumentos.idEvento,
          idProva: widget.argumentos.provas[0].id,
          idEmpresa: dados.evento.idEmpresa,
          idFormaPagamento: metodoPagamento,
          valorIngresso: dados.prova.valor,
          valorTaxa: dados.prova.taxaProva,
          valorTaxaCartao: metodoPagamento == '3' ? dados.taxaCartao : '0',
          valorDesconto: "0",
          valorTotal: retornarValorTotal(dados).toString(),
          tipoDeVenda: "Venda",
          cartao: cartaoSelecionado,
        ),
      );
    }
  }

  double retornarValorTotal(ListarInformacoesModelo dados) {
    double valorTotal = double.parse(dados.prova.valor) + double.parse(dados.prova.taxaProva);

    if (metodoPagamento == '3') {
      valorTotal = valorTotal + double.parse(dados.taxaCartao);
    }

    if (dados.valorAdicional != null) {
      if (dados.valorAdicional!.tipo == 'soma') {
        valorTotal = valorTotal + double.parse(dados.valorAdicional!.valor);
      } else if (dados.valorAdicional!.tipo == 'diminuir') {
        valorTotal = valorTotal - double.parse(dados.valorAdicional!.valor);
      }
    }

    return valorTotal;
  }

  void abrirModalCartoes() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return ModalSelecionarCartao(
          cartaoSelecionado: cartaoSelecionado,
          parcela: parcela,
          cartaoMemoria: cartaoMemoria,
          aoMudarCartao: (cartao) {
            setState(() {
              cartaoSelecionado = cartao;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var finalizarCompraStore = context.read<FinalizarCompraStore>();
    var listarInformacoesStore = context.read<ListarInformacoesStore>();
    var usuarioProvider = context.read<UsuarioProvider>();

    return Scaffold(
      appBar: AppBarSombra(
        titulo: Text((widget.argumentos.editarVenda != null && widget.argumentos.editarVenda!) ? 'Editar Venda' : "Finalizar Compra"),
      ),
      body: ValueListenableBuilder<ListarInformacoesEstado>(
        valueListenable: listarInformacoesStore,
        builder: (context, state, _) {
          ListarInformacoesModelo dados = state is CarregandoInformacoes
              ? DadosFakes.dadosFakesFinalizarCompra
              : state is CarregadoInformacoes
                  ? state.dados
                  : DadosFakes.dadosFakesFinalizarCompra;

          if (state is ErroAoListar) {
            return const Text('Erro ao listar informações.');
          }

          return Skeletonizer(
            enabled: state is CarregandoInformacoes,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  listarInformacoesStore.listarInformacoes(usuarioProvider.usuario, widget.argumentos.provas, widget.argumentos.idEvento, widget.argumentos.editarVenda ?? false,
                      widget.argumentos.dadosEdicaoVendaModelo?.idVenda ?? '');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(width: double.infinity, height: 0),
                        const Text('Métodos de pagamento', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: double.infinity, height: 10),
                        if (dados.pagamentos.isEmpty) ...[
                          SizedBox(
                            width: width,
                            child: const Center(child: Text('Nenhum pagamento está diponivel.')),
                          ),
                        ],
                        if (dados.pagamentos.isNotEmpty) ...[
                          SizedBox(
                            width: width,
                            child: SegmentedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return const Color.fromARGB(222, 247, 24, 8);
                                    }
                                    return Colors.transparent;
                                  },
                                ),
                                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Colors.white;
                                    }
                                    return Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;
                                  },
                                ),
                              ),
                              segments: dados.pagamentos
                                  .map(
                                    (itemPagamento) => ButtonSegment(
                                      value: itemPagamento.id,
                                      tooltip: itemPagamento.nome,
                                      label: Text(
                                        itemPagamento.nome,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              selected: {metodoPagamento},
                              showSelectedIcon: false,
                              onSelectionChanged: (pagamento) {
                                if (pagamento.first == '1' || pagamento.first == '4' || pagamento.first == '5' || pagamento.first == '6') {
                                  if (dados.ativoPagamento == 'Sim') {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext contextDialog) {
                                        return AlertDialog(
                                          title: const Text('Alerta'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                RichText(
                                                  textAlign: TextAlign.justify,
                                                  text: TextSpan(
                                                    text: 'O pagamento deve ser realizado em até',
                                                    style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                                                    children: <TextSpan>[
                                                      TextSpan(text: " ${dados.tempoCancel} minutos", style: const TextStyle(fontWeight: FontWeight.bold)),
                                                      const TextSpan(text: '. Ápos isso, o pedido será'),
                                                      const TextSpan(text: ' cancelado automaticamente', style: TextStyle(color: Colors.red)),
                                                      const TextSpan(text: '.'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                setState(() {
                                                  if (pagamento.first != '3') {
                                                    parcela = -1;
                                                  } else {
                                                    parcela = 1;
                                                  }

                                                  metodoPagamento = pagamento.first;
                                                });
                                                Navigator.of(contextDialog).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    return;
                                  }
                                }

                                setState(() {
                                  if (pagamento.first != '3') {
                                    parcela = -1;
                                  } else {
                                    parcela = 1;
                                  }

                                  metodoPagamento = pagamento.first;
                                });
                              },
                            ),
                          ),
                        ],
                        if (metodoPagamento == '3') ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                height: 55,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(width: 5);
                                  },
                                  itemCount: dados.parcelasDisponiveisCartao.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    var itemParcela = dados.parcelasDisponiveisCartao[index];

                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: parcela == itemParcela.parcela ? Colors.green : Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          if (parcela == itemParcela.parcela) {
                                            setState(() {
                                              parcela = -1;
                                            });
                                          } else {
                                            setState(() {
                                              parcela = itemParcela.parcela;
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                itemParcela.parcela == 1
                                                    ? 'Crédito á vista'
                                                    : '${itemParcela.parcela}x de ${(retornarValorTotal(dados) / itemParcela.parcela).obterReal()}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                retornarValorTotal(dados).obterReal(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                CardCartao(
                                  cartao: cartaoSelecionado ?? CartaoModelo(nomeCartao: '', numeroCartao: '', expiracaoCartao: '', cpfTitularCartao: ''),
                                  aparecerSeta: true,
                                  aparecerVazio: cartaoSelecionado == null,
                                  tamanhoCard: width - 20,
                                  aparecerSombra: 1,
                                  aoClicar: () {
                                    abrirModalCartoes();
                                  },
                                ),
                              ],
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
                              Utils.coverterEmReal.format(double.parse(dados.prova.valor.toString())),
                              style: const TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                        if (double.parse(dados.taxaCartao) != 0 && metodoPagamento == '3') ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Taxa Cartão',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "+ ${double.parse(dados.taxaCartao).obterReal()}",
                                style: const TextStyle(fontSize: 16, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                        if (double.parse(dados.prova.taxaProva) != 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Taxa Admin.',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "+ ${double.parse(dados.prova.taxaProva).obterReal()}",
                                style: const TextStyle(fontSize: 16, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                        if (parcela != -1 && metodoPagamento == '3') ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Parcelas',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                parcela == 1 ? 'Crédito á vista' : "${parcela}x de ${(retornarValorTotal(dados) / parcela).obterReal()}",
                                style: const TextStyle(fontSize: 16, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                        if (dados.valorAdicional != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    dados.valorAdicional!.titulo,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 5),
                                  const Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    showDuration: Duration(minutes: 5),
                                    message: 'Esse valor é PAGO somente UMA VEZ, caso desejar comprar outras inscrições, você deve pagar essa inscrição primeiro para continuar.',
                                    child: Icon(Icons.info_outline, size: 16),
                                  )
                                ],
                              ),
                              Text(
                                "${dados.valorAdicional!.tipo == 'soma' ? '+' : '-'} ${double.parse(dados.valorAdicional!.valor).obterReal()}",
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
                                        retornarValorTotal(dados).obterReal(),
                                        style: const TextStyle(fontSize: 16, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: finalizarCompraStore,
                                    builder: (context, stateFinalizarCompra, _) {
                                      return AbsorbPointer(
                                        absorbing: !permitirClickConcluir(stateFinalizarCompra),
                                        child: SizedBox(
                                          width: 150,
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all(
                                                permitirClickConcluir(stateFinalizarCompra) ? const Color.fromARGB(255, 247, 24, 8) : Colors.grey,
                                              ),
                                              foregroundColor: WidgetStateProperty.all(Colors.white),
                                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (stateFinalizarCompra is Carregando) {
                                                return;
                                              }

                                              salvar(dados);
                                            },
                                            child: stateFinalizarCompra is Carregando
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
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
                        SafeArea(
                          child: InkWell(
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
