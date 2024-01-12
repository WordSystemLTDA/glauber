import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/cartao_modelo.dart';

abstract interface class ListarCartoesServico {
  Future<List<CartaoModelo>> listarCartoes();
  Future<bool> excluirCartao(CartaoModelo cartao);
}
