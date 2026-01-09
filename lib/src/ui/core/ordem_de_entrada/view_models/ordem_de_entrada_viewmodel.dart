import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/ordem_de_entrada_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/servicos/ordemdeentrada_servico.dart';

class OrdemDeEntradaViewmodel extends ChangeNotifier {
  final OrdemDeEntradaServico _servico;

  OrdemDeEntradaViewmodel(this._servico) : super();

  List<OrdemDeEntradaModelo> _ordemdeentradas = [];
  List<OrdemDeEntradaModelo> get ordemdeentradas => _ordemdeentradas;

  void listar(UsuarioModelo? usuario) async {
    List<OrdemDeEntradaModelo> result = await _servico.listar(usuario);

    _ordemdeentradas = result;
  }
}
