import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/ordermdeentrada_servico.dart';
import 'package:provadelaco/domain/models/ordem_de_entrada_modelo.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';

class OrdemDeEntradaStore extends ChangeNotifier {
  final OrdemDeEntradaServico _servico;

  OrdemDeEntradaStore(this._servico) : super();

  List<OrdemDeEntradaModelo> ordemdeentradas = [];

  void listar(UsuarioModelo? usuario) async {
    List<OrdemDeEntradaModelo> lista = await _servico.listar(usuario);

    ordemdeentradas = lista;
    notifyListeners();
  }
}
