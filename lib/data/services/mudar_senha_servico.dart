import 'dart:convert';

import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';

class MudarSenhaServico {
  final DioClient client;

  MudarSenhaServico(this.client);

  Future<bool> mudarSenha(UsuarioModelo? usuario, String senha) async {
    var url = 'clientes/mudar_senha.php';

    if (usuario == null) {
      return false;
    }

    var campos = {
      "id": usuario.id,
      "senha": senha,
    };

    var response = await client.dio.post(url, data: jsonEncode(campos));

    Map result = jsonDecode(response.data);
    bool sucesso = result['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return sucesso;
    } else {
      return false;
    }
  }
}
