import 'dart:convert';

import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/cartao/cartao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListarCartoesServico {
  final DioClient client;

  ListarCartoesServico(this.client);

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
