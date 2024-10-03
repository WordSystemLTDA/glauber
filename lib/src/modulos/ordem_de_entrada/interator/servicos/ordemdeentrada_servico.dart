import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/ordem_de_entrada_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/prova_parceiros_modelo.dart';

abstract interface class OrdemDeEntradaServico {
  Future<List<OrdemDeEntradaModelo>> listar(UsuarioModelo? usuario);
  Future<List<ProvaParceirosModelos>> listarPorProva(UsuarioModelo? usuario, String idProva);
  Future<List<ProvaParceirosModelos>> listarPorListaCompeticao(UsuarioModelo? usuario, String idListaCompeticao, String idEmpresa, String idEvento);
  Future<bool> baixarPDF(String idVenda);
}
