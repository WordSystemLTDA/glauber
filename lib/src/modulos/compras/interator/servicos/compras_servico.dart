import 'package:glauber/src/modulos/compras/interator/modelos/compras_modelo.dart';

abstract interface class ComprasServico {
  Future<List<ComprasModelo>> listar();
}
