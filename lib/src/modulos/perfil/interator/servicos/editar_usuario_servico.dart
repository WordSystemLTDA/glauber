import 'package:provadelaco/src/modulos/perfil/interator/modelos/formulario_editar_usuario_modelo.dart';

abstract interface class EditarUsuarioServico {
  Future<bool> editarUsuario(FormularioEditarUsuarioModelo dados);
}
