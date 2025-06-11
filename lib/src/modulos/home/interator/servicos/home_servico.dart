import 'package:provadelaco/src/modulos/home/interator/modelos/confirmar_parceiros_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/home_modelo.dart';

abstract interface class HomeServico {
  Future<HomeModelo> listar(int categoria);
  Future<RetornoConfirmarParceirosModelo> listarConfirmarParceiros(String idcliente);
}
