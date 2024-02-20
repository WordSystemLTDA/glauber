import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/competidores_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/competidores_servico.dart';

class CompetidoresServicoImpl implements CompetidoresServico {
  final IHttpClient client;

  CompetidoresServicoImpl(this.client);

  @override
  Future<List<CompetidoresModelo>> listarCompetidores(String pesquisa) async {
    var url = 'compras/listar_clientes.php?pesquisa=$pesquisa';

    var response = await client.get(url: url);
    var jsonData = jsonDecode(response.data);
    var dados = jsonData['dados'];
    var sucesso = jsonData['sucesso'];

    if (sucesso == true) {
      return List<CompetidoresModelo>.from(dados.map((elemento) {
        return CompetidoresModelo.fromMap(elemento);
      }));
    } else {
      return [];
    }
  }
}
