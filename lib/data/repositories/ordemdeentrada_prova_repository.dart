import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/ordermdeentrada_servico.dart';
import 'package:provadelaco/domain/models/prova_parceiros_modelo.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';

class OrdemDeEntradaProvaStore extends ChangeNotifier {
  final OrdemDeEntradaServico _servico;

  OrdemDeEntradaProvaStore(this._servico) : super();

  List<ProvaParceirosModelos> ordemdeentradas = [];
  ProvaParceirosModelos? quemEstaCorrendoAgora;

  bool carregando = false;

  void listar(UsuarioModelo? usuario, String idProva) async {
    carregando = true;
    notifyListeners();

    var (:lista, :quemEstaCorrendoAgora) = await _servico.listarPorProva(usuario, idProva);

    ordemdeentradas = lista;
    this.quemEstaCorrendoAgora = quemEstaCorrendoAgora;
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
