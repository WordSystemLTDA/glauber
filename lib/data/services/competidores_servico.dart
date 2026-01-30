import 'dart:convert';

import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';

class CompetidoresServico {
  final DioClient client;

  CompetidoresServico(this.client);

  Future<List<CompetidoresModelo>> listarCompetidores(String? idCabeceira, UsuarioModelo? usuario, String pesquisa, String idProva) async {
    var idCliente = usuario != null ? usuario.id : 0;
    var url = 'compras/listar_clientes.php?pesquisa=$pesquisa&id_prova=$idProva&id_cliente=$idCliente&id_cabeceira=$idCabeceira';

    var response = await client.dio.get(url);
    var jsonData = jsonDecode(response.data);
    var dados = jsonData['dados'];
    var sucesso = jsonData['sucesso'];

    if (sucesso == true) {
      return List<CompetidoresModelo>.from(dados.map((elemento) {
        return CompetidoresModelo.fromJson(elemento);
      }));
    } else {
      return [];
    }
  }

  Future<List<CompetidoresModelo>> listarBancoCompetidores(String? idCabeceira, UsuarioModelo? usuario, String pesquisa, String idProva) async {
    var idCliente = usuario != null ? usuario.id : 0;
    var url = 'compras/listar_clientes_sorteio.php?pesquisa=$pesquisa&id_prova=$idProva&id_cliente=$idCliente&id_cabeceira=$idCabeceira';

    var response = await client.dio.get(url);
    var jsonData = jsonDecode(response.data);
    var dados = jsonData['dados'];
    var sucesso = jsonData['sucesso'];

    if (sucesso == true) {
      return List<CompetidoresModelo>.from(dados.map((elemento) {
        return CompetidoresModelo.fromJson(elemento);
      }));
    } else {
      return [];
    }
  }
}
