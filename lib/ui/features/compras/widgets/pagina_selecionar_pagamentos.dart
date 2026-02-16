import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/compras_servico.dart';
import 'package:provadelaco/domain/models/compras/compras.dart';
import 'package:provadelaco/ui/core/ui/app_bar_sombra.dart';
import 'package:provadelaco/ui/features/compras/widgets/card_compras.dart';
import 'package:provadelaco/ui/features/compras/widgets/modal_pagar_inscricoes.dart';
import 'package:provider/provider.dart';

class PaginaSelecionarPagamentos extends StatefulWidget {
  const PaginaSelecionarPagamentos({super.key});

  @override
  State<PaginaSelecionarPagamentos> createState() => _PaginaSelecionarPagamentosState();
}

class _PaginaSelecionarPagamentosState extends State<PaginaSelecionarPagamentos> {
  ValueNotifier<List<ComprasModelo>> inscricoes = ValueNotifier([]);
  ValueNotifier<bool> carregando = ValueNotifier(true);
  List<ComprasModelo> comprasPagamentos = [];
  bool selecionarVariasInscricoes = false;

  @override
  void initState() {
    super.initState();
    listar();
  }

  void listar() async {
    await context.read<ComprasServico>().listarSomenteInscricoes(1).then((value) {
      inscricoes.value = value;
    }).whenComplete(() {
      carregando.value = false;
    });
  }

  void selecionarInscricoesAutomaticamente(bool value) {
    setState(() {
      selecionarVariasInscricoes = value;
      if (value == true) {
        for (var element in inscricoes.value) {
          if (comprasPagamentos.contains(element) == false) {
            if (comprasPagamentos.isNotEmpty && element.idFormaPagamento != comprasPagamentos.firstOrNull?.idFormaPagamento) {
              return;
            }

            if (comprasPagamentos.isNotEmpty && element.idEvento != comprasPagamentos.firstOrNull?.idEvento) {
              return;
            }

            if (comprasPagamentos.isNotEmpty && element.idEmpresa != comprasPagamentos.firstOrNull?.idEmpresa) {
              return;
            }

            comprasPagamentos.add(element);
          }
        }
      } else {
        for (var element in inscricoes.value) {
          if (comprasPagamentos.contains(element)) {
            comprasPagamentos.remove(element);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;

    // print(comprasPagamentos.where((element) => num.parse(element.valorTaxa) > 0).length);
    var somaValorTotal = (num.parse(comprasPagamentos
                .fold(
                  ComprasModelo(
                    id: "187",
                    permVincularParceiro: '',
                    idEmpresa: '1',
                    valorIngresso: "0.00",
                    reembolso: '',
                    valorTaxa: "0.00",
                    valorDesconto: "0.00",
                    valorTotal: "0.00",
                    status: "Pendente",
                    codigoQr: "MTAwMDAwMDAwMDE4Nw==",
                    codigoPIX: "00020126330014br.gov.bcb.pix0111061528269505204000053039865406150.005802BR5911SAGL84237736011Santo Incio62240520mpqrinter7002336949763044DB5",
                    idCliente: "10",
                    dataCompra: "2024-01-08",
                    horaCompra: "13:16 PM",
                    pago: "Não",
                    nomeProva: "Sem nome prova",
                    nomeEvento: "Aniversário João Vitor Fadel",
                    dataEvento: "2023-12-16",
                    horaInicio: "09:00:00",
                    parcelas: '0',
                    tipodevenda: '',
                    horaInicioF: "09:00 AM",
                    horaTermino: "19:00:00",
                    idEvento: '1',
                    nomeEmpresa: 'Nome empresa',
                    numeroCelular: "(44) 99921-3336",
                    formaPagamento: "Pix Mercado Pago",
                    idFormaPagamento: "1",
                    quandoInscricaoNaoPaga: "mostrar_qrcode_pix",
                    mensagemQuandoInscricaoNaoPaga: "",
                    parceiros: const [],
                    provas: const [],
                    valorFiliacao: '0',
                    pixVencido: '',
                  ),
                  (previousValue, element) => ComprasModelo(
                    id: "187",
                    pixVencido: '',
                    reembolso: '',
                    permVincularParceiro: '',
                    idEmpresa: '1',
                    valorIngresso: "0.00",
                    valorTaxa: "0.00",
                    valorDesconto: "0.00",
                    valorTotal: element.tipodevenda == 'Filiação'
                        ? (num.parse(previousValue.valorTotal) + (num.parse(element.valorFiliacao) / (num.tryParse(element.parcelas) ?? 1))).toString()
                        : ((num.parse(previousValue.valorTotal) + num.parse(element.valorTotal))).toString(),
                    status: "Pendente",
                    codigoQr: "MTAwMDAwMDAwMDE4Nw==",
                    codigoPIX: "00020126330014br.gov.bcb.pix0111061528269505204000053039865406150.005802BR5911SAGL84237736011Santo Incio62240520mpqrinter7002336949763044DB5",
                    idCliente: "10",
                    dataCompra: "2024-01-08",
                    horaCompra: "13:16 PM",
                    pago: "Não",
                    nomeProva: "Sem nome prova",
                    parcelas: '0',
                    tipodevenda: '',
                    nomeEvento: "Aniversário João Vitor Fadel",
                    dataEvento: "2023-12-16",
                    horaInicio: "09:00:00",
                    horaInicioF: "09:00 AM",
                    horaTermino: "19:00:00",
                    idEvento: '1',
                    nomeEmpresa: 'Nome empresa',
                    numeroCelular: "(44) 99921-3336",
                    formaPagamento: "Pix Mercado Pago",
                    idFormaPagamento: "1",
                    quandoInscricaoNaoPaga: "mostrar_qrcode_pix",
                    mensagemQuandoInscricaoNaoPaga: "",
                    parceiros: const [],
                    provas: const [],
                    valorFiliacao: '0',
                  ),
                )
                .valorTotal) -
            ((comprasPagamentos.where((element) => num.parse(element.valorTaxa) > 0).length > 1
                    ? num.parse(comprasPagamentos.where((element) => num.parse(element.valorTaxa) > 0).first.valorTaxa)
                    : 0) *
                comprasPagamentos.where((element) => num.parse(element.valorTaxa) > 0).length))
        .toString();

    return Scaffold(
      appBar: const AppBarSombra(titulo: Text('Selecione as Inscrições')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: comprasPagamentos.isNotEmpty,
        child: SizedBox(
          height: 50,
          child: FloatingActionButton.extended(
            heroTag: null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            label: Text('Pagar ${comprasPagamentos.length} Inscrições - ${double.parse(somaValorTotal).obterReal()}'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ModalPagarInscricoes(
                    comprasPagamentos: comprasPagamentos,
                    aoVerificarPagamento: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ).then((value) {
                setState(() {
                  comprasPagamentos = [];
                });
              });
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: () {
                selecionarInscricoesAutomaticamente(!selecionarVariasInscricoes);
              },
              child: Row(
                children: [
                  Checkbox(
                    value: selecionarVariasInscricoes,
                    onChanged: (value) {
                      if (value != null) {
                        selecionarInscricoesAutomaticamente(value);
                      }
                    },
                  ),
                  SizedBox(
                    width: width - 50,
                    child: const Text('Selecionar as inscrições que pertencem na mesma empresa e tem a mesma forma de pagamento automaticamente.'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: carregando,
              builder: (context, carregandoValue, _) {
                return Visibility(
                  visible: !carregandoValue,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ValueListenableBuilder(
                    valueListenable: inscricoes,
                    builder: (context, inscricoesValue, _) {
                      return Visibility(
                        visible: inscricoesValue.isNotEmpty,
                        replacement: const Padding(
                          padding: EdgeInsets.only(bottom: 100.0),
                          child: Center(child: Text('Sem inscrições para gerar um pagamento.', textAlign: TextAlign.center)),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: inscricoesValue.length,
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70),
                          itemBuilder: (context, index) {
                            var item = inscricoesValue[index];

                            final bool ehFiliacao = item.tipodevenda == 'Filiação';

                            return Padding(
                              padding: EdgeInsets.only(bottom: inscricoesValue.lastWhere((element) => element.nomeEvento == item.nomeEvento).id == item.id ? 20 : 0),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (inscricoesValue.firstWhere((element) => element.nomeEvento == item.nomeEvento).id == item.id) ...[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5, left: 2),
                                          child: Text(item.nomeEvento),
                                        ),
                                      ],
                                      if (ehFiliacao) ...[
                                        IgnorePointer(
                                          child: Opacity(
                                            opacity: 0.7,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.orange, width: 2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Stack(
                                                children: [
                                                  CardCompras(
                                                    item: item,
                                                    modoTransferencia: false,
                                                    modoGerarPagamento: true,
                                                    comprasTransferencia: const [],
                                                    comprasPagamentos: comprasPagamentos,
                                                    aparecerNomeProva: true,
                                                    aoClicarParaTransferir: (compra) {},
                                                    aoClicarParaGerarPagamento: (compra) {},
                                                  ),
                                                  Positioned(
                                                    left: 8,
                                                    top: 4,
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange,
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: const Text(
                                                        'Filiação (automático)',
                                                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        CardCompras(
                                          item: item,
                                          modoTransferencia: false,
                                          modoGerarPagamento: true,
                                          comprasTransferencia: const [],
                                          comprasPagamentos: comprasPagamentos,
                                          aparecerNomeProva: true,
                                          aoClicarParaTransferir: (compra) {},
                                          aoClicarParaGerarPagamento: (compra) {
                                            if (comprasPagamentos.isNotEmpty) {
                                              if (compra.idEmpresa != comprasPagamentos.first.idEmpresa) {
                                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  showCloseIcon: true,
                                                  content: Text('Essa inscrição não pertence a mesma empresa da primeira inscrição que você selecionou.'),
                                                ));
                                                return;
                                              }

                                              if (compra.idFormaPagamento != comprasPagamentos.first.idFormaPagamento) {
                                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  showCloseIcon: true,
                                                  content: Text('Essa inscrição não é da mesma forma de pagamento da primeira inscrição que você selecionou.'),
                                                ));
                                                return;
                                              }
                                            }

                                            // Buscar filiações do mesmo evento
                                            final filiacoesDoEvento = inscricoesValue
                                                .where(
                                                  (e) => e.tipodevenda == 'Filiação' && e.idEvento == compra.idEvento && e.idEmpresa == compra.idEmpresa,
                                                )
                                                .toList();

                                            if (comprasPagamentos.contains(compra)) {
                                              setState(() {
                                                comprasPagamentos.remove(compra);

                                                // Se não há mais inscrições normais desse evento selecionadas, remover filiações também
                                                final temOutrasDoEvento = comprasPagamentos.any(
                                                  (e) => e.tipodevenda != 'Filiação' && e.idEvento == compra.idEvento,
                                                );
                                                if (!temOutrasDoEvento) {
                                                  for (var fil in filiacoesDoEvento) {
                                                    comprasPagamentos.remove(fil);
                                                  }
                                                }
                                              });
                                            } else {
                                              setState(() {
                                                comprasPagamentos.add(compra);

                                                // Auto-selecionar filiações do mesmo evento
                                                for (var fil in filiacoesDoEvento) {
                                                  if (!comprasPagamentos.contains(fil)) {
                                                    comprasPagamentos.add(fil);
                                                  }
                                                }
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (comprasPagamentos.contains(item)) ...[
                                    Positioned(
                                      right: 0,
                                      top: inscricoesValue.firstWhere((element) => element.nomeEvento == item.nomeEvento).id == item.id ? 20 : 0,
                                      child: Icon(
                                        Icons.check,
                                        color: ehFiliacao ? Colors.orange : Colors.green,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
