import 'dart:convert';

import 'package:glauber/src/essencial/network/http_cliente.dart';
import 'package:glauber/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:glauber/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:glauber/src/modulos/provas/interator/modelos/prova_retorno_modelo.dart';
import 'package:glauber/src/modulos/provas/interator/servicos/prova_servico.dart';

class ProvaServicoImpl implements ProvaServico {
  final IHttpClient client;

  ProvaServicoImpl(this.client);

  @override
  Future<ProvaRetornoModelo> listar(String idEvento) async {
    var url = 'provas/listar.php?id_evento=$idEvento';

    var response = await client.get(url: url);

    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];

    EventoModelo evento = EventoModelo.fromMap(jsonData['evento']);

    List<ProvaModelo> provas = List<ProvaModelo>.from(jsonData['provas'].map((elemento) {
      return ProvaModelo.fromMap(elemento);
    }));

    if (response.statusCode == 200 && sucesso == true) {
      return ProvaRetornoModelo(sucesso: sucesso, provas: provas, evento: evento);
    } else {
      return Future.error('');
    }
  }
}
