import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/verificar_permitir_compra_estado.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/prova_servico.dart';

class VerificarPermitirCompraProvedor extends ValueNotifier<VerificarPermitirCompraEstado> {
  final ProvaServico _servico;

  VerificarPermitirCompraProvedor(this._servico) : super(VerificarPermitirCompraEstadoInicial());

  void verificarPermitirCompra(
      ProvaModelo provaModelo, EventoModelo eventoModelo, String idEvento, String idProva, UsuarioModelo usuario, String idCabeceira, bool jaExisteCarrinho) async {
    value = VerificandoPermitirCompra(idProvaVerificando: idProva, idCabeceiraVerificando: idCabeceira);

    if (jaExisteCarrinho) {
      value = SucessoAoVerificarPermitirCompra(
        provaModelo: provaModelo,
        eventoModelo: eventoModelo,
        idCabeceira: idCabeceira,
        permitirCompraModelo: provaModelo.permitirCompra,
      );
    } else {
      var permitirCompra = await _servico.permitirAdicionarCompra(idEvento, idProva, usuario, idCabeceira);

      value = SucessoAoVerificarPermitirCompra(
        provaModelo: provaModelo,
        eventoModelo: eventoModelo,
        idCabeceira: idCabeceira,
        permitirCompraModelo: permitirCompra,
      );
    }
  }
}
