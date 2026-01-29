import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/config/config_modelo.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/domain/models/categoria_modelo.dart';
import 'package:provadelaco/src/domain/models/confirmar_parceiros_modelo.dart';
import 'package:provadelaco/src/domain/models/evento_modelo.dart';
import 'package:provadelaco/src/domain/models/home_modelo.dart';
import 'package:provadelaco/src/domain/models/propaganda_modelo.dart';

class HomeServico {
  final IHttpClient client;

  HomeServico(this.client);

  Future<HomeModelo> listar(int categoria) async {
    var url = 'home/listar.php?categoria=$categoria';

    var response = await client.get(url: url);

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

  Future<RetornoConfirmarParceirosModelo> listarConfirmarParceiros(String idcliente) async {
    var url = 'home/listar_parceiros_aguardando_confirmacao.php?id_cliente=$idcliente';

    var response = await client.get(url: url);

    var jsonData = jsonDecode(response.data);

    List<ConfirmarParceirosModelo> lacarpe = jsonData['lacarpe'] != null
        ? List<ConfirmarParceirosModelo>.from(jsonData['lacarpe'].map((elemento) {
            return ConfirmarParceirosModelo.fromMap(elemento);
          }))
        : [];

    List<ConfirmarParceirosModelo> lacarcabeca = jsonData['lacarcabeca'] != null
        ? List<ConfirmarParceirosModelo>.from(jsonData['lacarcabeca'].map((elemento) {
            return ConfirmarParceirosModelo.fromMap(elemento);
          }))
        : [];

    return RetornoConfirmarParceirosModelo(
      lacarcabeca: lacarcabeca,
      lacarpe: lacarpe,
    );
  }

  Future<({String mensagem, bool sucesso})> confirmarParceiro(ParceirosModelo parceiro, String idprovas, String idcliente, UsuarioModelo? usuario) async {
    var url = 'home/aceitar_parceiro.php';

    var campos = {
      'idparceiro': parceiro.idparceiro,
      'idvendasparceiro': parceiro.idvendasparceiro,
      'idvincularparceiros': parceiro.id,
      'modalidade': parceiro.modalidade,
      'idprovas': idprovas,
      'id_cliente': idcliente,
      'usuario': usuario == null ? {} : usuario.toMap(),
    };

    var response = await client.post(url: url, body: campos);
    var jsonData = response.data;

    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso: sucesso, mensagem: mensagem);
  }

  Future<({String mensagem, bool sucesso})> recusarParceiro(ParceirosModelo parceiro, String idcliente) async {
    var url = 'home/recusar_parceiro.php';

    var campos = {
      'idparceiro': parceiro.idparceiro,
      'idvincularparceiros': parceiro.id,
      'modalidade': parceiro.modalidade,
      'id_cliente': idcliente,
    };

    var response = await client.post(url: url, body: campos);
    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    String mensagem = jsonData['mensagem'];

    return (sucesso: sucesso, mensagem: mensagem);
  }
}
