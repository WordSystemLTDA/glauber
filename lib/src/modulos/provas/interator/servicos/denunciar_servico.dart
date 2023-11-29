abstract interface class DenunciarServico {
  Future<bool> denunciar(String idEvento, String idEmpresa, String nome, String celular, String mensagem);
}
