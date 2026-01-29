import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/verificar_permitir_compra_estado.dart';
import 'package:provadelaco/src/domain/models/evento_modelo.dart';
import 'package:provadelaco/src/data/servicos/prova_sevico.dart';
import 'package:provadelaco/src/domain/models/prova_modelo.dart';

class VerificarPermitirCompraProvedor extends ChangeNotifier {
  final ProvaServico _servico;

  VerificarPermitirCompraProvedor(this._servico) : super();

  bool carregando = true;

  Future<SucessoAoVerificarPermitirCompra> verificarPermitirCompra(
    ProvaModelo provaModelo,
    EventoModelo eventoModelo,
    String idEvento,
    String idProva,
    UsuarioModelo usuario,
    String? idCabeceira,
    bool jaExisteCarrinho,
    String quantidadeCarrinho,
  ) async {
    if (jaExisteCarrinho) {
      return SucessoAoVerificarPermitirCompra(
        provaModelo: provaModelo,
        eventoModelo: eventoModelo,
        idCabeceira: idCabeceira,
        permitirCompraModelo: provaModelo.permitirCompra,
      );
    }

    carregando = true;
    notifyListeners();

    var permitirCompra = await _servico.permitirAdicionarCompra(idEvento, idProva, usuario, idCabeceira, quantidadeCarrinho);

    carregando = false;
    notifyListeners();

    return SucessoAoVerificarPermitirCompra(
      provaModelo: provaModelo,
      eventoModelo: eventoModelo,
      idCabeceira: idCabeceira,
      permitirCompraModelo: permitirCompra,
    );
  }
}
