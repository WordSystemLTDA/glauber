import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';

abstract interface class ComprasServico {
  Future<List<ComprasModelo>> listar(UsuarioModelo? usuario, int pagina);
  Future<bool> baixarPDF(String idVenda);
}
