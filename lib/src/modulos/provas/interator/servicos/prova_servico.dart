import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/permitir_compra_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_retorno_modelo.dart';

abstract interface class ProvaServico {
  Future<ProvaRetornoModelo> listar(UsuarioModelo? usuario, String idEvento, String tipo);
  Future<PermitirCompraModelo> permitirAdicionarCompra(String idEvento, String idProva, UsuarioModelo? usuario, String idCabeceira);
}
