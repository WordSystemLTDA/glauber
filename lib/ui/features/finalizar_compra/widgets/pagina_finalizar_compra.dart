import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/data/repositories/finalizar_compra_repository.dart';
import 'package:provadelaco/data/repositories/listar_informacoes_repository.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/domain/models/cartao/cartao.dart';
import 'package:provadelaco/domain/models/formulario_compra_modelo.dart';
import 'package:provadelaco/domain/models/formulario_editar_compra_modelo.dart';
import 'package:provadelaco/domain/models/listar_informacoes_modelo.dart';
import 'package:provadelaco/domain/models/prova/prova.dart';
import 'package:provadelaco/domain/models/retorno_compra_modelo.dart';
import 'package:provadelaco/routing/routes.dart';
import 'package:provadelaco/ui/core/ui/app_bar_sombra.dart';
import 'package:provadelaco/ui/core/ui/termos_de_uso.dart';
import 'package:provadelaco/ui/features/finalizar_compra/widgets/card_cartao.dart';
import 'package:provadelaco/ui/features/finalizar_compra/widgets/modal_parcelamento_filiacao.dart';
import 'package:provadelaco/ui/features/finalizar_compra/widgets/modal_selecionar_cartao.dart';
import 'package:provadelaco/ui/features/finalizar_compra/widgets/pagina_sucesso_compra.dart';
import 'package:provider/provider.dart';

class PaginaFinalizarCompraArgumentos {
  final List<ProvaModelo> provas;
  final String idEvento;
  bool? editarVenda;
  final String? idVenda;
  final String? metodoPagamento;

  PaginaFinalizarCompraArgumentos({
    required this.provas,
    required this.idEvento,
    this.idVenda,
    this.metodoPagamento,
    this.editarVenda,
  });
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
  int? parcelasFiliacao;
  final GlobalKey _rodapeKey = GlobalKey();
  double _alturaRodape = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var listarInformacoesStore = context.read<ListarInformacoesStore>();
      var usuarioProvider = context.read<UsuarioProvider>();

      listarInformacoesStore
          .listarInformacoes(
        usuarioProvider.usuario,
        widget.argumentos.provas,
        widget.argumentos.idEvento,
        widget.argumentos.editarVenda ?? false,
        widget.argumentos.idVenda ?? '',
      )
          .then((response) {
        final primeiroMetodoPagamento = response.pagamentos.firstOrNull?.id ?? '0';

        if (!mounted) return;
        if (metodoPagamento != primeiroMetodoPagamento) {
          setState(() {
            metodoPagamento = primeiroMetodoPagamento;
            parcela = (metodoPagamento == '3') ? 1 : -1;
          });
        }

        // Mostrar modal de parcelamento de filiação se houver valor não pago
        if (response.valorAdicional != null && response.valorAdicional!.pago == 'Não') {
          _mostrarModalParcelamentoFiliacao(response);
        }
      });
    });
  }

  void _mostrarModalParcelamentoFiliacao(ListarInformacoesModelo dados) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ModalParcelamentoFiliacao(
        dados: dados,
        parcelasInicial: parcelasFiliacao,
        aoConfirmar: (parcelas) {
          setState(() => parcelasFiliacao = parcelas);
        },
      ),
    ).then((confirmado) {
      if (confirmado != true) {
        // Se não confirmou, volta para a tela de inscrição
        if (mounted) {
          Navigator.pop(context);
        }
      }
    });
  }

  bool permitirClickConcluir() {
    var finalizarCompraStore = context.read<FinalizarCompraStore>();
    if (finalizarCompraStore.carregando) return false;

    if (concorda && metodoPagamento != '0') {
      if (metodoPagamento == '3') {
        return cartaoSelecionado != null && parcela != -1;
      }
      return true;
    }
    return false;
  }

  void abrirTermosDeUso() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final height = MediaQuery.of(context).size.height * 0.9;
        return SizedBox(
          height: height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Termos de Uso e Contrato',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: TermosDeUso(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double retornarValorTotal(ListarInformacoesModelo dados) {
    double valorTotal = double.parse(dados.prova.valor) + double.parse(dados.prova.taxaProva);
    double desconto = double.parse(dados.valorDescontoPorProva ?? '0');

    if (metodoPagamento == '3') {
      valorTotal += double.parse(dados.taxaCartao);
    }

    if (dados.valorAdicional != null && dados.valorAdicional!.pago == 'Não') {
      double valorAdicionalBase = double.parse(dados.valorAdicional!.valor);
      if (dados.valorAdicional!.tipo == 'soma') {
        double totalAdicional = valorAdicionalBase;
        if (dados.valorAdicionalPorParcela != null && parcelasFiliacao != null && dados.valorAdicionalPorParcela!.containsKey(parcelasFiliacao.toString())) {
          totalAdicional = double.parse(dados.valorAdicionalPorParcela![parcelasFiliacao.toString()]!);
        }
        valorTotal += totalAdicional;
      } else if (dados.valorAdicional!.tipo == 'diminuir') {
        valorTotal -= valorAdicionalBase;
      }
    }
    return valorTotal - desconto;
  }

  void salvar(ListarInformacoesModelo dados) async {
    var finalizarCompraStore = context.read<FinalizarCompraStore>();
    var usuarioProvider = context.read<UsuarioProvider>();

    RetornoCompraModelo? dadosRetornoVar;
    String mensagemRetorno = '';

    if (widget.argumentos.editarVenda == true) {
      var (:dadosRetorno, :mensagem) = await finalizarCompraStore.editar(
        usuarioProvider.usuario,
        FormularioEditarCompraModelo(
          idVenda: widget.argumentos.idVenda ?? '',
          idEvento: widget.argumentos.idEvento,
          idProva: widget.argumentos.provas[0].id,
          idEmpresa: dados.evento.idEmpresa,
          idFormaPagamento: metodoPagamento,
          valorIngresso: dados.prova.valor,
          valorTaxa: dados.prova.taxaProva,
          valorTaxaCartao: metodoPagamento == '3' ? dados.taxaCartao : '0',
          valorDesconto: dados.valorDescontoPorProva ?? '0',
          valorTotal: retornarValorTotal(dados).toString(),
          temValorFiliacao: (() {
            double totalAdicional = double.tryParse(dados.valorAdicional?.valor ?? '0') ?? 0;
            if (dados.valorAdicionalPorParcela != null && parcelasFiliacao != null && dados.valorAdicionalPorParcela!.containsKey(parcelasFiliacao.toString())) {
              totalAdicional = double.parse(dados.valorAdicionalPorParcela![parcelasFiliacao.toString()]!);
            }
            return totalAdicional.toStringAsFixed(2);
          })(),
          filiacaoJaPaga: dados.valorAdicional?.pago,
          parcelasFiliacao: parcelasFiliacao,
          cartao: cartaoSelecionado,
        ),
      );
      dadosRetornoVar = dadosRetorno;
      mensagemRetorno = mensagem;
    } else {
      var (:dadosRetorno, :mensagem) = await finalizarCompraStore.inserir(
        usuarioProvider.usuario,
        FormularioCompraModelo(
          temValorFiliacao: (() {
            double totalAdicional = double.tryParse(dados.valorAdicional?.valor ?? '0') ?? 0;
            if (dados.valorAdicionalPorParcela != null && parcelasFiliacao != null && dados.valorAdicionalPorParcela!.containsKey(parcelasFiliacao.toString())) {
              totalAdicional = double.parse(dados.valorAdicionalPorParcela![parcelasFiliacao.toString()]!);
            }
            return totalAdicional.toStringAsFixed(2);
          })(),
          filiacaoJaPaga: dados.valorAdicional?.pago,
          parcelasFiliacao: parcelasFiliacao,
          provas: widget.argumentos.provas,
          idEvento: widget.argumentos.idEvento,
          idProva: widget.argumentos.provas[0].id,
          idEmpresa: dados.evento.idEmpresa,
          idFormaPagamento: metodoPagamento,
          valorIngresso: dados.prova.valor,
          valorTaxa: dados.prova.taxaProva,
          valorTaxaCartao: metodoPagamento == '3' ? dados.taxaCartao : '0',
          valorDesconto: dados.valorDescontoPorProva ?? '0',
          valorTotal: retornarValorTotal(dados).toString(),
          tipoDeVenda: "Venda",
          cartao: cartaoSelecionado,
        ),
      );
      dadosRetornoVar = dadosRetorno;
      mensagemRetorno = mensagem;
    }

    if (dadosRetornoVar != null && dadosRetornoVar.sucesso) {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRotas.sucessoCompra,
          arguments: PaginaSucessoCompraArgumentos(dados: dadosRetornoVar.dados, metodoPagamento: metodoPagamento),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagemRetorno), backgroundColor: Colors.red));
    }
  }

  void _atualizarAlturaRodape() {
    final contextRodape = _rodapeKey.currentContext;
    if (contextRodape == null) return;

    final novaAltura = contextRodape.size?.height ?? 0;
    if ((novaAltura - _alturaRodape).abs() > 1) {
      setState(() => _alturaRodape = novaAltura);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var listarStore = context.watch<ListarInformacoesStore>();
    var finalizarStore = context.watch<FinalizarCompraStore>();

    if (listarStore.carregando) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (listarStore.dados == null) return const Scaffold(body: Center(child: Text('Erro ao carregar.')));

    final dados = listarStore.dados!;
    WidgetsBinding.instance.addPostFrameCallback((_) => _atualizarAlturaRodape());

    return Scaffold(
      appBar: AppBarSombra(titulo: Text(widget.argumentos.editarVenda == true ? 'Editar Venda' : "Finalizar Compra")),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: _alturaRodape,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                children: [
                  if (_deveMostrarSelecaoPagamento(dados)) ...[
                    _buildSelecaoPagamento(dados, width),
                    const SizedBox(height: 20),
                  ],
                  _buildResumoGeral(dados),
                  if (metodoPagamento == '3') ...[
                    const SizedBox(height: 20),
                    _buildSelecaoParcelas(dados),
                    const SizedBox(height: 12),
                    CardCartao(
                      cartao: cartaoSelecionado ?? CartaoModelo(nomeCartao: '', numeroCartao: '', expiracaoCartao: '', cpfTitularCartao: ''),
                      aparecerSeta: true,
                      aparecerVazio: cartaoSelecionado == null,
                      tamanhoCard: width - 24,
                      aparecerSombra: 1,
                      aoClicar: () => showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        builder: (context) => ModalSelecionarCartao(
                          cartaoSelecionado: cartaoSelecionado,
                          parcela: parcela,
                          cartaoMemoria: cartaoMemoria,
                          aoMudarCartao: (c) => setState(() => cartaoSelecionado = c),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                key: _rodapeKey,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: _buildRodapeDetalhado(dados, finalizarStore),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _deveMostrarSelecaoPagamento(ListarInformacoesModelo dados) {
    final valor = dados.ativoPagamento.trim().toLowerCase();
    return valor == '1' || valor == 'sim' || valor == 's' || valor == 'true';
  }

  Widget _buildSelecaoPagamento(ListarInformacoesModelo dados, double width) {
    return Column(
      children: [
        const Text('Forma de Pagamento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          width: width,
          child: SegmentedButton<String>(
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: const Color(0xFFF71808),
              selectedForegroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              side: BorderSide(color: Colors.grey.shade300),
            ),
            segments: dados.pagamentos.map((p) => ButtonSegment(value: p.id, label: Text(p.nome))).toList(),
            selected: {metodoPagamento},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() {
              metodoPagamento = s.first;
              parcela = (metodoPagamento == '3') ? 1 : -1;
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildResumoGeral(ListarInformacoesModelo dados) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long, color: Color(0xFFF71808)),
              SizedBox(width: 10),
              Text('Resumo da Compra', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 20),

          // INFORMAÇÕES DO EVENTO
          Row(
            children: [
              const Icon(Icons.event, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dados.evento.nomeEvento,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                dados.evento.dataEvento,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
          ),
          const Divider(height: 24),

          // FILIAÇÃO EM DESTAQUE
          if (dados.valorAdicional != null) ...[
            InkWell(
              onTap: dados.valorAdicional!.pago == 'Não' ? () => _mostrarModalParcelamentoFiliacao(dados) : null,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: dados.valorAdicional!.pago == 'Não' ? Colors.blue.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: dados.valorAdicional!.pago == 'Não' ? Colors.blue.shade200 : Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.card_membership, color: dados.valorAdicional!.pago == 'Não' ? Colors.blue : Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Filiação', style: TextStyle(fontWeight: FontWeight.bold, color: dados.valorAdicional!.pago == 'Não' ? Colors.blue : Colors.green)),
                          if (dados.valorAdicional!.titulo.isNotEmpty) Text(dados.valorAdicional!.titulo, style: const TextStyle(fontSize: 12)),
                          if (parcelasFiliacao != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              (() {
                                double totalAd = double.parse(dados.valorAdicional!.valor);
                                if (dados.valorAdicionalPorParcela != null && dados.valorAdicionalPorParcela!.containsKey(parcelasFiliacao.toString())) {
                                  totalAd = double.parse(dados.valorAdicionalPorParcela![parcelasFiliacao.toString()]!);
                                }
                                final porParcela = totalAd / (parcelasFiliacao ?? 1);
                                return '${parcelasFiliacao}x de ${porParcela.obterReal()}';
                              })(),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ],
                      ),
                    ),
                    if (dados.valorAdicional!.pago == 'Não') ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            (() {
                              double totalAd = double.parse(dados.valorAdicional!.valor);
                              if (dados.valorAdicionalPorParcela != null && parcelasFiliacao != null && dados.valorAdicionalPorParcela!.containsKey(parcelasFiliacao.toString())) {
                                totalAd = double.parse(dados.valorAdicionalPorParcela![parcelasFiliacao.toString()]!);
                              }
                              return '${dados.valorAdicional!.tipo == 'soma' ? '+' : '-'} ${totalAd.obterReal()}';
                            })(),
                            style: TextStyle(fontWeight: FontWeight.bold, color: dados.valorAdicional!.pago == 'Não' ? Colors.blue : Colors.green),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      const Icon(Icons.warning, color: Colors.orange, size: 16),
                    ] else ...[
                      Text(
                        'Já pago',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      SizedBox(width: 10),
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // LISTA DE PROVAS COM COMPETIDORES
          const Text('Inscrições', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 10),
          ...widget.argumentos.provas.map((prova) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(prova.nomeProva, style: const TextStyle(fontWeight: FontWeight.w600))),
                        Text(double.parse(prova.valor).obterReal()),
                      ],
                    ),
                    if (prova.competidores != null && prova.competidores!.isNotEmpty)
                      ...prova.competidores!.map((c) => Padding(
                            padding: const EdgeInsets.only(left: 12, top: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    c.id == '0' ? 'Sorteio' : c.nome,
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSelecaoParcelas(ListarInformacoesModelo dados) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Parcelamento', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dados.parcelasDisponiveisCartao.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final p = dados.parcelasDisponiveisCartao[index];
              bool isSelected = parcela == p.parcela;
              return InkWell(
                onTap: () => setState(() => parcela = p.parcela),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF71808).withValues(alpha: 0.05) : Theme.of(context).cardColor,
                    border: Border.all(color: isSelected ? const Color(0xFFF71808) : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text('${p.parcela}x de ${(retornarValorTotal(dados) / p.parcela).obterReal()}')),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRodapeDetalhado(ListarInformacoesModelo dados, FinalizarCompraStore store) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _linhaPrecoRodape('Subtotal', double.parse(dados.prova.valor).obterReal()),
          if (metodoPagamento == '3') _linhaPrecoRodape('Taxa Cartão', "+ ${double.parse(dados.taxaCartao).obterReal()}", cor: Colors.blue),
          if (double.parse(dados.prova.taxaProva) > 0) _linhaPrecoRodape('Taxa Administrativa', "+ ${double.parse(dados.prova.taxaProva).obterReal()}", cor: Colors.blue),
          if (double.parse(dados.valorAdicional?.valor ?? '0') > 0 && dados.valorAdicional?.pago == 'Não')
            _linhaPrecoRodape(
              'Filiação',
              (() {
                double totalAd = double.parse(dados.valorAdicional!.valor);
                if (dados.valorAdicionalPorParcela != null && parcelasFiliacao != null && dados.valorAdicionalPorParcela!.containsKey(parcelasFiliacao.toString())) {
                  totalAd = double.parse(dados.valorAdicionalPorParcela![parcelasFiliacao.toString()]!);
                }
                final porParcela = totalAd / (parcelasFiliacao ?? 1);
                return '+ ${parcelasFiliacao}x de ${porParcela.obterReal()}';
              })(),
              cor: Colors.blue,
            ),
          if (double.parse(dados.valorDescontoPorProva ?? '0') > 0) _linhaPrecoRodape('Desconto', "- ${double.parse(dados.valorDescontoPorProva!).obterReal()}", cor: Colors.green),
          const Divider(height: 16),
          _linhaPrecoRodape('Total', retornarValorTotal(dados).obterReal(), negrito: true, tamanho: 18, cor: const Color(0xFFF71808)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: permitirClickConcluir() ? const Color(0xFFF71808) : Colors.grey.shade300,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: permitirClickConcluir() ? () => salvar(dados) : null,
              child: store.carregando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'CLIQUE AQUI PARA FINALIZAR A COMPRA',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => setState(() => concorda = !concorda),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: concorda ? const Color(0xFFF71808).withValues(alpha: 0.06) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: concorda ? const Color(0xFFF71808) : Colors.grey.shade300,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: concorda,
                    activeColor: const Color(0xFFF71808),
                    onChanged: (v) => setState(() => concorda = v ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13, height: 1.35),
                          children: [
                            const TextSpan(text: 'Li e aceito os '),
                            TextSpan(
                              text: 'Termos de Uso e Contrato',
                              style: const TextStyle(
                                color: Color(0xFFF71808),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = abrirTermosDeUso,
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Abrir Termos',
                    onPressed: abrirTermosDeUso,
                    icon: const Icon(Icons.open_in_new, size: 18, color: Color(0xFFF71808)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _linhaPrecoRodape(String label, String valor, {Color? cor, bool negrito = false, double tamanho = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: tamanho, fontWeight: negrito ? FontWeight.bold : FontWeight.normal)),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: tamanho, fontWeight: FontWeight.bold, color: cor),
            ),
          ),
        ],
      ),
    );
  }
}
