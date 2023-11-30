import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/versoes/versoes_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/home_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/servicos/home_servico.dart';

class HomeServicoImpl implements HomeServico {
  final IHttpClient client;

  HomeServicoImpl(this.client);

  @override
  Future<HomeModelo> listar() async {
    var url = 'home/listar.php';

    var response = await client.post(url: url, body: jsonEncode(''));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    List<EventoModelo> eventos = jsonData['eventos'] != null
        ? List<EventoModelo>.from(jsonData['eventos'].map((elemento) {
            return EventoModelo.fromMap(elemento);
          }))
        : [];

    List<EventoModelo> propagandas = List<EventoModelo>.from(jsonData['propagandas'].map((elemento) {
      return EventoModelo.fromMap(elemento);
    }));

    VersoesModelo versoes = VersoesModelo.fromMap(jsonData['dadosVersoes']);

    if (response.statusCode == 200 && sucesso == true) {
      return HomeModelo(sucesso: sucesso, eventos: eventos, propagandas: propagandas, versoes: versoes);
    } else {
      return HomeModelo(sucesso: sucesso, eventos: eventos, propagandas: propagandas, versoes: versoes);
    }
  }
}
