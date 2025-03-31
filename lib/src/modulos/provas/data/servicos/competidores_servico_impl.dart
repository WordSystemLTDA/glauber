import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/competidores_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/competidores_servico.dart';

class CompetidoresServicoImpl implements CompetidoresServico {
  final IHttpClient client;

  CompetidoresServicoImpl(this.client);

  @override
  Future<List<CompetidoresModelo>> listarCompetidores(String? idCabeceira, UsuarioModelo? usuario, String pesquisa, String idProva) async {
    var idCliente = usuario != null ? usuario.id : 0;
    var url = 'compras/listar_clientes.php?pesquisa=$pesquisa&id_prova=$idProva&id_cliente=$idCliente&id_cabeceira=$idCabeceira';

    var response = await client.get(url: url);
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

  @override
  Future<List<CompetidoresModelo>> listarBancoCompetidores(String? idCabeceira, UsuarioModelo? usuario, String pesquisa, String idProva) async {
    var idCliente = usuario != null ? usuario.id : 0;
    var url = 'compras/listar_clientes_sorteio.php?pesquisa=$pesquisa&id_prova=$idProva&id_cliente=$idCliente&id_cabeceira=$idCabeceira';

    var response = await client.get(url: url);
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
