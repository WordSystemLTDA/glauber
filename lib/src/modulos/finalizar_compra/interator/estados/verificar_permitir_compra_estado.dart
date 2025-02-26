// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/permitir_compra_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

sealed class VerificarPermitirCompraEstado {}

class VerificarPermitirCompraEstadoInicial implements VerificarPermitirCompraEstado {}

class VerificandoPermitirCompra implements VerificarPermitirCompraEstado {
  final String idProvaVerificando;
  final String? idCabeceiraVerificando;

  VerificandoPermitirCompra({
    required this.idProvaVerificando,
    required this.idCabeceiraVerificando,
  });
}

class SucessoAoVerificarPermitirCompra implements VerificarPermitirCompraEstado {
  final PermitirCompraModelo permitirCompraModelo;
  final ProvaModelo provaModelo;
  final EventoModelo eventoModelo;
  final String? idCabeceira;

  SucessoAoVerificarPermitirCompra({
    required this.permitirCompraModelo,
    required this.provaModelo,
    required this.eventoModelo,
    required this.idCabeceira,
  });
}

class ErroAoVerificarPermitirCompra implements VerificarPermitirCompraEstado {
  final Exception erro;

  ErroAoVerificarPermitirCompra({required this.erro});
}
