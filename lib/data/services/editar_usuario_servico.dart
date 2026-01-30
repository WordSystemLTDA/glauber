import 'dart:convert';

import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/formulario_editar_usuario_modelo.dart';

class EditarUsuarioServico {
  final DioClient client;

  EditarUsuarioServico(this.client);

  Future<(bool, String)> editarUsuario(FormularioEditarUsuarioModelo dados) async {
    var url = 'clientes/editar.php';

    var campos = {
      ...dados.toMap(),
    };

    final response = await client.dio.post(
      url,
      data: jsonEncode(campos),
    );

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];
    String mensagem = result['mensagem'];

    if (response.statusCode == 200 && sucesso == true) {
      return (sucesso, mensagem);
    } else {
      return (false, mensagem);
    }
  }
}
