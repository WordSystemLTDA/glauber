import 'package:provadelaco/src/essencial/usuario_modelo.dart';

abstract interface class MudarSenhaServico {
  Future<bool> mudarSenha(UsuarioModelo? usuario, String senha);
}
