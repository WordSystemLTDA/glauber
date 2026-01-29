import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/data/servicos/ordermdeentrada_servico.dart';
import 'package:provadelaco/src/domain/models/prova_parceiros_modelo.dart';

class OrdemDeEntradaProvaStore extends ChangeNotifier {
  final OrdemDeEntradaServico _servico;

  OrdemDeEntradaProvaStore(this._servico) : super();

  List<ProvaParceirosModelos> ordemdeentradas = [];

  bool carregando = false;

  void listar(UsuarioModelo? usuario, String idProva) async {
    carregando = true;
    notifyListeners();

    List<ProvaParceirosModelos> lista = await _servico.listarPorProva(usuario, idProva);

    ordemdeentradas = lista;
    carregando = false;
    notifyListeners();
  }

  void listarPorListaCompeticao(UsuarioModelo? usuario, String idListaCompeticao, String idEmpresa, String idEvento) async {
    carregando = true;
    notifyListeners();

    List<ProvaParceirosModelos> lista = await _servico.listarPorListaCompeticao(usuario, idListaCompeticao, idEmpresa, idEvento);

    ordemdeentradas = lista;
    carregando = false;
    notifyListeners();
  }
}
