import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/permitir_compra_modelo.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';
import 'package:provadelaco/domain/models/evento/evento_modelo.dart';
import 'package:provadelaco/data/servicos/prova_sevico.dart';
import 'package:provadelaco/domain/models/prova/prova_modelo.dart';

class VerificarPermitirCompraProvedor extends ChangeNotifier {
  final ProvaServico _servico;

  VerificarPermitirCompraProvedor(this._servico) : super();

  bool carregando = true;

  Future<({ProvaModelo provaModelo, EventoModelo eventoModelo, String? idCabeceira, PermitirCompraModelo permitirCompra})> verificarPermitirCompra(
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
      return (
        provaModelo: provaModelo,
        eventoModelo: eventoModelo,
        idCabeceira: idCabeceira,
        permitirCompra: provaModelo.permitirCompra,
      );
    }

    carregando = true;
    notifyListeners();

    var permitirCompra = await _servico.permitirAdicionarCompra(idEvento, idProva, usuario, idCabeceira, quantidadeCarrinho);

    carregando = false;
    notifyListeners();

    return (
      provaModelo: provaModelo,
      eventoModelo: eventoModelo,
      idCabeceira: idCabeceira,
      permitirCompra: permitirCompra,
    );
  }
}
