abstract interface class AutenticacaoServico {
  Future<bool> verificar();
  Future<bool> entrar(String email, String senha);
  Future<List<dynamic>> cadastrar(String nome, String email, String senha);
}
