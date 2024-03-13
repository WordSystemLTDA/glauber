import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/parceiros_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/prova_parceiros_modelo.dart';

abstract interface class OrdemDeEntradaServico {
  Future<List<ParceirosModelos>> listar(UsuarioModelo? usuario);
  Future<List<ProvaParceirosModelos>> listarPorProva(UsuarioModelo? usuario, String idProva);
  Future<bool> baixarPDF(String idVenda);
}
