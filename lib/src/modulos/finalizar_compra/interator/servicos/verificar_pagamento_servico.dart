abstract interface class VerificarPagamentoServico {
  Future<bool> verificarPagamento(String txid, String idFormaPagamento);
  Future<bool> verificarPagamentoGerado(String txid, String idFormaPagamento);
}
