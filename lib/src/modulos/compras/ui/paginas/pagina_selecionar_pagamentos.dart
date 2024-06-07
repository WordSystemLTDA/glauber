import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/card_compras.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/modal_pagar_inscricoes.dart';
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
  bool selecionarVariasInscricoes = true;

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

  @override
  Widget build(BuildContext context) {
    // print(comprasPagamentos.where((element) => num.parse(element.valorTaxa) > 0).length);
    var somaValorTotal = (num.parse(comprasPagamentos
                .fold(
                  ComprasModelo(
                    id: "187",
                    permVincularParceiro: '',
                    idEmpresa: '1',
                    valorIngresso: "0.00",
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
                    horaInicioF: "09:00 AM",
                    horaTermino: "19:00:00",
                    idEvento: '1',
                    nomeEmpresa: 'Nome empresa',
                    numeroCelular: "(44) 99921-3336",
                    formaPagamento: "Pix Mercado Pago",
                    permitirEditarParceiros: '',
                    idFormaPagamento: "1",
                    quandoInscricaoNaoPaga: "mostrar_qrcode_pix",
                    mensagemQuandoInscricaoNaoPaga: "",
                    parceiros: [],
                    provas: [],
                    valorFiliacao: '0',
                  ),
                  (previousValue, element) => ComprasModelo(
                    id: "187",
                    permVincularParceiro: '',
                    idEmpresa: '1',
                    valorIngresso: "0.00",
                    valorTaxa: "0.00",
                    valorDesconto: "0.00",
                    valorTotal: (num.parse(previousValue.valorTotal) + num.parse(element.valorTotal)).toString(),
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
                    horaInicioF: "09:00 AM",
                    horaTermino: "19:00:00",
                    idEvento: '1',
                    nomeEmpresa: 'Nome empresa',
                    numeroCelular: "(44) 99921-3336",
                    formaPagamento: "Pix Mercado Pago",
                    permitirEditarParceiros: '',
                    idFormaPagamento: "1",
                    quandoInscricaoNaoPaga: "mostrar_qrcode_pix",
                    mensagemQuandoInscricaoNaoPaga: "",
                    parceiros: [],
                    provas: [],
                    valorFiliacao: '0',
                  ),
                )
                .valorTotal) -
            ((comprasPagamentos.where((element) => num.parse(element.valorTaxa) > 0).length > 1
                        ? num.parse(comprasPagamentos.where((element) => num.parse(element.valorTaxa) > 0).first.valorTaxa)
                        : 0) *
                    comprasPagamentos.where((element) => num.parse(element.valorTaxa) > 0).length -
                1))
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
              );
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
                setState(() {
                  selecionarVariasInscricoes = !selecionarVariasInscricoes;
                });
              },
              child: Row(
                children: [
                  Checkbox(
                    value: selecionarVariasInscricoes,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selecionarVariasInscricoes = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    width: 300,
                    child: Text('Selecionar várias inscrições da mesma prova automaticamente.'),
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

                            // log('opa', error: inscricoesValue.map((e) => e.toMap()));

                            return Padding(
                              padding: EdgeInsets.only(bottom: inscricoesValue.lastWhere((element) => element.nomeProva == item.nomeProva).id == item.id ? 20 : 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (inscricoesValue.firstWhere((element) => element.nomeProva == item.nomeProva).id == item.id) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5, left: 2),
                                      child: Text(item.nomeProva),
                                    ),
                                  ],
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
                                        if (selecionarVariasInscricoes) {
                                          setState(() {
                                            comprasPagamentos.removeWhere((element) => element.nomeProva == compra.nomeProva);
                                          });
                                        } else {
                                          setState(() {
                                            comprasPagamentos.remove(compra);
                                          });
                                        }
                                      } else {
                                        if (selecionarVariasInscricoes) {
                                          setState(() {
                                            comprasPagamentos.addAll(inscricoesValue.where((element) => element.nomeProva == compra.nomeProva));
                                          });
                                        } else {
                                          setState(() {
                                            comprasPagamentos.add(compra);
                                          });
                                        }
                                      }
                                    },
                                  ),
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
