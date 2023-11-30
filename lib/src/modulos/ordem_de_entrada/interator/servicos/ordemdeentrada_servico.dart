import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/ordem_de_entrada_modelo.dart';

abstract interface class OrdemDeEntradaServico {
  Future<List<OrdemDeEntradaModelo>> listar(UsuarioModelo? usuario);
  Future<bool> baixarPDF(String idVenda);
}
