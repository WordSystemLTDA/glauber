class ConexoesBanco {
  // String servidor = 'http://192.168.2.129/api_glauber';
  String servidor = 'http://192.168.2.115/sistema/api_glauber';

  urlCadastrar() {
    return '$servidor/autenticacao/cadastro/cadastrar.php';
  }

  urlLogin() {
    return '$servidor/autenticacao/login/login.php';
  }
}
