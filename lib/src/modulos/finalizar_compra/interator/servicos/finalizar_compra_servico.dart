import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/formulario_compra_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/retorno_compra_modelo.dart';

abstract interface class FinalizarCompraServico {
  Future<RetornoCompraModelo> inserir(UsuarioModelo? usuario, FormularioCompraModelo dados);
}
