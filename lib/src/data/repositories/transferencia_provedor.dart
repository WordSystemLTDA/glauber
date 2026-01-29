import 'package:flutter/material.dart';
import 'package:provadelaco/src/data/servicos/compras_servico.dart';
import 'package:provadelaco/src/domain/models/compras_modelo.dart';

class TransferenciaProvedor extends ChangeNotifier {
  final ComprasServico _comprasServico;

  TransferenciaProvedor(this._comprasServico) : super();

  bool carregando = false;

  Future<({bool sucesso, String mensagem})> transferirCompras(List<ComprasModelo> comprasTransferencia, String novoCliente) async {
    carregando = true;
    notifyListeners();

    var (:sucesso, :mensagem) = await _comprasServico.transferirCompras(comprasTransferencia, novoCliente);

    carregando = false;
    notifyListeners();

    return (sucesso: sucesso, mensagem: mensagem);
  }
}
