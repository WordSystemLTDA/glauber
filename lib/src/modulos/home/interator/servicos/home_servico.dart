import 'package:glauber/src/modulos/home/interator/modelos/home_modelo.dart';

abstract interface class HomeServico {
  Future<HomeModelo> listar();
}
