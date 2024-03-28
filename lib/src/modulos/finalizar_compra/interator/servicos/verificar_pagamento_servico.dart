abstract interface class VerificarPagamentoServico {
  Future<bool> verificarPagamento(String idVenda, String idFormaPagamento);
  Future<bool> verificarPagamentoGerado(String txid, String idFormaPagamento);
}
