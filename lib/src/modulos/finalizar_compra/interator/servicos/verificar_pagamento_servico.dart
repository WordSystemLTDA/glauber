abstract interface class VerificarPagamentoServico {
  Future<bool> verificarPagamento(String idVenda, String idFormaPagamento);
}
