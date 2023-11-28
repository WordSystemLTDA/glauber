import 'package:provadelaco/src/essencial/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';

abstract interface class ComprasServico {
  Future<List<ComprasModelo>> listar(UsuarioModelo? usuario);
  Future<bool> baixarPDF(String idVenda);
}
