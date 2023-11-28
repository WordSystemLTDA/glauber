import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/modulos/perfil/interator/modelos/formulario_editar_usuario_modelo.dart';
import 'package:provadelaco/src/modulos/perfil/interator/servicos/editar_usuario_servico.dart';

class EditarUsuarioServicoImpl implements EditarUsuarioServico {
  final IHttpClient client;

  EditarUsuarioServicoImpl(this.client);

  @override
  Future<(bool, String)> editarUsuario(FormularioEditarUsuarioModelo dados) async {
    var url = 'clientes/editar.php';

    var campos = {
      ...dados.toMap(),
    };

    final response = await client.post(
      url: url,
      body: jsonEncode(campos),
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
