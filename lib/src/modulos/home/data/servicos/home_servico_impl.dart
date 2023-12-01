import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/config/config_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/categoria_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/home_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/propaganda_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/servicos/home_servico.dart';

class HomeServicoImpl implements HomeServico {
  final IHttpClient client;

  HomeServicoImpl(this.client);

  @override
  Future<HomeModelo> listar(int categoria) async {
    var url = 'home/listar.php?categoria=$categoria';

    var response = await client.post(url: url, body: jsonEncode(''));

    var jsonData = jsonDecode(response.data);
    bool sucesso = jsonData['sucesso'];

    List<EventoModelo> eventosTopo = jsonData['eventosTopo'] != null
        ? List<EventoModelo>.from(jsonData['eventosTopo'].map((elemento) {
            return EventoModelo.fromMap(elemento);
          }))
        : [];

    List<EventoModelo> eventos = jsonData['eventos'] != null
        ? List<EventoModelo>.from(jsonData['eventos'].map((elemento) {
            return EventoModelo.fromMap(elemento);
          }))
        : [];

    List<PropagandaModelo> propagandas = List<PropagandaModelo>.from(jsonData['propagandas'].map((elemento) {
      return PropagandaModelo.fromMap(elemento);
    }));

    List<CategoriaModelo> categorias = List<CategoriaModelo>.from(jsonData['categorias'].map((elemento) {
      return CategoriaModelo.fromMap(elemento);
    }));

    ConfigModelo dadosConfig = ConfigModelo.fromMap(jsonData['dadosConfig']);

    return HomeModelo(
      sucesso: sucesso,
      eventos: eventos,
      propagandas: propagandas,
      dadosConfig: dadosConfig,
      categorias: categorias,
      eventosTopo: eventosTopo,
    );
  }
}
