import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/animais/modelos/modelo_animal.dart';

class ServicoAnimais {
  final IHttpClient client;
  final UsuarioProvider usuarioProvedor;

  ServicoAnimais(this.client, this.usuarioProvedor);

  Future<List<ModeloAnimal>> listar(String pesquisa) async {
    var idCliente = usuarioProvedor.usuario!.id!;
    var url = "animais/listar.php?id_cliente=$idCliente&pesquisa=$pesquisa";

    var response = await client.get(url: url);

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    if (response.statusCode == 200 && sucesso == true) {
      return List<ModeloAnimal>.from(jsonData['dados'].map((elemento) {
        return ModeloAnimal.fromMap(elemento);
      }));
    } else {
      return [];
    }
  }

  Future<(bool, String)> inserir(
    String nome,
    String dataNascimento,
    String sexo,
    String raca,
    String cidade,
    String foto,
    String idProprietario,
  ) async {
    var idCliente = usuarioProvedor.usuario!.id!;

    var url = 'animais/inserir.php';

    var campos = {
      'nome_do_animal': nome,
      'data_nasci_animal': dataNascimento,
      'sexo': sexo,
      'raca_do_animal': raca,
      'id_cidade': cidade,
      'foto': foto,
      'id_usuario_lanc': idCliente,
      'id_proprietario': idProprietario == '0' ? idCliente : idProprietario,
    };

    Response response = await client.post(url: url, body: jsonEncode(campos));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso, mensagem);
  }
}
