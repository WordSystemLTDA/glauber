import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/data/servicos/ordermdeentrada_servico_impl.dart';
import 'package:provadelaco/src/domain/models/ordem_de_entrada_modelo.dart';

class OrdemDeEntradaStore extends ChangeNotifier {
  final OrdemDeEntradaServicoImpl _servico;

  OrdemDeEntradaStore(this._servico) : super();

  List<OrdemDeEntradaModelo> ordemdeentradas = [];

  void listar(UsuarioModelo? usuario) async {
    List<OrdemDeEntradaModelo> lista = await _servico.listar(usuario);

    ordemdeentradas = lista;
    notifyListeners();
  }
}
