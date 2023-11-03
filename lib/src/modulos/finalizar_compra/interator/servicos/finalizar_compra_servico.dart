import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/finalizar_compra_modelo.dart';

abstract interface class FinalizarCompraServico {
  Future<(bool, String)> inserir(FinalizarCompraModelo dados);
}
