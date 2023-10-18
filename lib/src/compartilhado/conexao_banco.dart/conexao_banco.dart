class ConexaoBanco {
  String servidor = 'http://192.168.2.129/api_glauber';
  // String servidor = '';

  urlCadastrar() {
    return '$servidor/cadastramento/cadastrar.php';
  }

  urlLogin() {
    return '$servidor/login/login.php';
  }
}
