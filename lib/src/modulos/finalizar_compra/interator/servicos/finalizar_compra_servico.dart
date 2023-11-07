import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/formulario_compra_modelo.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/retorno_compra_modelo.dart';

abstract interface class FinalizarCompraServico {
  Future<RetornoCompraModelo> inserir(FormularioCompraModelo dados);
}
