import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/cartao_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/listar_cartoes_servico.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListarCartoesServicoImpl implements ListarCartoesServico {
  final IHttpClient client;

  ListarCartoesServicoImpl(this.client);

  @override
  Future<List<CartaoModelo>> listarCartoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartoesSalvos = prefs.getString('cartoesSalvos');

    // print(cartoesSalvosLista);
    if (cartoesSalvos != null) {
      List<dynamic> cartoesSalvosLista = jsonDecode(cartoesSalvos);

      List<CartaoModelo> cartoes = List<CartaoModelo>.from(cartoesSalvosLista.map((elemento) {
        return CartaoModelo.fromMap(jsonDecode(elemento));
      }));

      return cartoes;
    }

    return [];
  }

  @override
  Future<bool> excluirCartao(CartaoModelo cartao) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartoesSalvos = prefs.getString('cartoesSalvos');

    // print(cartoesSalvosLista);
    if (cartoesSalvos != null) {
      List<dynamic> cartoesSalvosLista = jsonDecode(cartoesSalvos);

      List<CartaoModelo> cartoes = List<CartaoModelo>.from(cartoesSalvosLista.map((elemento) {
        return CartaoModelo.fromMap(jsonDecode(elemento));
      }));

      var retornoExclusaoCartao = cartoes.remove(cartao);

      String cartaoString = json.encode(cartoes);
      prefs.setString('cartoesSalvos', cartaoString);

      return retornoExclusaoCartao;
    }

    return false;
  }
}
