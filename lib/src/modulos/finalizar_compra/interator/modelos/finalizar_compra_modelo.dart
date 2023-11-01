class FinalizarCompraModelo {
  final String idProva;
  final String idFormaPagamento;
  final String valorIngresso;
  final String valorTaxa;
  final String valorDesconto;
  final String valorTotal;
  final String txid;
  final String codigoPix;
  final String tipoDeVenda;

  FinalizarCompraModelo({
    required this.idProva,
    required this.idFormaPagamento,
    required this.valorIngresso,
    required this.valorTaxa,
    required this.valorDesconto,
    required this.valorTotal,
    required this.txid,
    required this.codigoPix,
    required this.tipoDeVenda,
  });
}
