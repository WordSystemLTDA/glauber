import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/ordem_de_entrada_modelo.dart';

abstract interface class OrdemDeEntradaServico {
  Future<List<OrdemDeEntradaModelo>> listar();
  Future<bool> baixarPDF(String idVenda);
}
