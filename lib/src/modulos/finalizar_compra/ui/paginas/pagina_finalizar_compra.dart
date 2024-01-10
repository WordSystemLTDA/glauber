import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/dados_fakes.dart';
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
import 'package:provadelaco/src/modulos/finalizar_compra/ui/widgets/card_cartao.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaginaFinalizarCompraArgumentos {
  final List<ProvaModelo> provas;
  final String idEvento;

  PaginaFinalizarCompraArgumentos({required this.provas, required this.idEvento});
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
  int parcela = 0;
  int cartaoSelecionado = 0;

  TextEditingController nomeCartaoController = TextEditingController();
  TextEditingController numeroCartaoController = TextEditingController();
  TextEditingController expiracaoCartaoController = TextEditingController();
  TextEditingController cpfCartaoController = TextEditingController();
  TextEditingController codigoCartaoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var finalizarCompraStore = context.read<FinalizarCompraStore>();
      var listarInformacoesStore = context.read<ListarInformacoesStore>();

      listarInformacoesStore.listarInformacoes(widget.argumentos.provas, widget.argumentos.idEvento);

      finalizarCompraStore.addListener(() {
        FinalizarCompraEstado state = finalizarCompraStore.value;

        if (state is CompraRealizadaComSucesso) {
          if (mounted) {
            Navigator.pushReplacementNamed(
              context,
              AppRotas.sucessoCompra,
              arguments: PaginaSucessoCompraArgumentos(dados: state.dados, metodoPagamento: metodoPagamento),
            );
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
        provas: widget.argumentos.provas,
        idEvento: widget.argumentos.idEvento,
        idProva: widget.argumentos.provas[0].id,
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

  void abrirModalCartoes() {
    var width = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: width,
                  height: 40,
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        showModalBottomSheet(
                          showDragHandle: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                              },
                              child: SizedBox(
                                width: width,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 10,
                                    bottom: MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                  child: SafeArea(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            controller: nomeCartaoController,
                                            decoration: const InputDecoration(
                                              hintText: 'Seu nome',
                                              label: Text('Nome do Cartão'),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            keyboardType: TextInputType.number,
                                            controller: numeroCartaoController,
                                            decoration: const InputDecoration(
                                              hintText: '1234 1234 1234 1234',
                                              label: Text('Número do Cartão'),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            keyboardType: TextInputType.number,
                                            controller: expiracaoCartaoController,
                                            decoration: const InputDecoration(
                                              hintText: '06/2025',
                                              label: Text('Expiração do Cartão'),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              CpfInputFormatter(),
                                            ],
                                            controller: cpfCartaoController,
                                            decoration: const InputDecoration(
                                              hintText: '123.123.123-12',
                                              label: Text('CPF do titular do Cartão'),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: const MaterialStatePropertyAll(Colors.green),
                                                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                                                shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                  ),
                                                ),
                                              ),
                                              child: const Text('Salvar'),
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll(Colors.green),
                        foregroundColor: const MaterialStatePropertyAll(Colors.white),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text('Adicionar um cartão'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return CardCartao(
                      selecionado: index == cartaoSelecionado,
                      aoClicar: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          showDragHandle: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                              },
                              child: SizedBox(
                                width: width,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 10,
                                    bottom: MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                  child: SafeArea(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            controller: codigoCartaoController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: '1234',
                                              label: Text('Código de Segurança'),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                setState(() {
                                                  codigoCartaoController.text = '';
                                                  cartaoSelecionado = index;
                                                });
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: const MaterialStatePropertyAll(Colors.green),
                                                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                                                shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                  ),
                                                ),
                                              ),
                                              child: const Text('OK'),
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      ),
                                    ),
                                  ),
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
            ],
          ),
        );
      },
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
          ListarInformacoesModelo dados = state is CarregandoInformacoes
              ? DadosFakes.dadosFakesFinalizarCompra
              : state is CarregadoInformacoes
                  ? state.dados
                  : DadosFakes.dadosFakesFinalizarCompra;

          if (state is ErroAoListar) {
            return const Text('Erro');
          }

          return Skeletonizer(
            enabled: state is CarregandoInformacoes,
            child: Padding(
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
                              for (var i = 0; i < dados.pagamentos.length; i++)
                                ButtonSegment(
                                  value: dados.pagamentos[i].id,
                                  tooltip: dados.pagamentos[i].nome,
                                  label: Text(
                                    dados.pagamentos[i].nome,
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
                      if (metodoPagamento == '3') ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            height: 55,
                            child: ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 5);
                              },
                              itemCount: 7,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: parcela == index ? Colors.green : Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      if (parcela == index) {
                                        setState(() {
                                          parcela = -1;
                                        });
                                      } else {
                                        setState(() {
                                          parcela = index;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            index == 0 ? 'Crédito á vista' : '${index}x de ${(150 / index).obterReal()}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            (150).obterReal(),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              CardCartao(
                                aparecerSeta: true,
                                aparecerVazio: cartaoSelecionado == 0,
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
                      if (double.parse(dados.prova.taxaProva) != 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Taxa Admin.',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "+ ${Utils.coverterEmReal.format(double.parse(dados.prova.taxaProva))}",
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
                                      Utils.coverterEmReal.format(double.parse(dados.prova.valor.toString()) + double.parse(dados.prova.taxaProva)),
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

                                            salvar(dados);
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
          );
        },
      ),
    );
  }
}
