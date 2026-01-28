import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/domain/models/modelo_animal.dart';

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
        return ModeloAnimal.fromJson(elemento);
      }));
    } else {
      return [];
    }
  }

  Future<({bool sucesso, String mensagem})> inserir({
    required String nome,
    required String dataNascimento,
    required String sexo,
    required String padrao,
    required String raca,
    required String foto,
    required String idProprietario,
  }) async {
    var idCliente = usuarioProvedor.usuario!.id!;

    var url = 'animais/inserir.php';

    var formData = FormData.fromMap({
      'nome_do_animal': nome,
      'data_nasci_animal': dataNascimento,
      'sexo': sexo,
      'padrao': padrao,
      'raca_do_animal': raca,
      'foto': foto.isEmpty ? '' : await MultipartFile.fromFile(foto, filename: 'foto.jpg'),
      'id_usuario_lanc': idCliente,
      'id_proprietario': idProprietario == '0' ? idCliente : idProprietario,
    });

    Response response = await client.post(url: url, body: formData);

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso: sucesso, mensagem: mensagem);
  }

  Future<({bool sucesso, String mensagem})> editar({
    required String id,
    required String nome,
    required String dataNascimento,
    required String sexo,
    required String padrao,
    required String raca,
    required String foto,
    required String fotoedicao,
    required String idProprietario,
  }) async {
    var idCliente = usuarioProvedor.usuario!.id!;

    var url = 'animais/editar.php';

    var formData = FormData.fromMap({
      'id_animal': id,
      'nome_do_animal': nome,
      'data_nasci_animal': dataNascimento,
      'sexo': sexo,
      'padrao': padrao,
      'raca_do_animal': raca,
      'foto': foto.isEmpty ? fotoedicao : await MultipartFile.fromFile(foto, filename: 'foto.jpg'),
      'id_usuario_lanc': idCliente,
      'id_proprietario': idProprietario == '0' ? idCliente : idProprietario,
    });

    Response response = await client.post(url: url, body: formData);

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso: sucesso, mensagem: mensagem);
  }

  Future<({bool sucesso, String mensagem})> excluir(String idAnimal) async {
    var idCliente = usuarioProvedor.usuario!.id!;

    var url = 'animais/excluir.php';

    var formData = {
      'id_animal': idAnimal,
      'id_usuario_lanc': idCliente,
    };

    Response response = await client.post(url: url, body: formData);

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso: sucesso, mensagem: mensagem);
  }
}
