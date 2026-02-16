import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/ordermdeentrada_servico.dart';
import 'package:provadelaco/domain/models/prova_parceiros_modelo.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';

class OrdemDeEntradaProvaStore extends ChangeNotifier {
  final OrdemDeEntradaServico _servico;

  OrdemDeEntradaProvaStore(this._servico) : super();

  List<ProvaParceirosModelos> ordemdeentradas = [];
  List<Map<String, String>> somatoriasDisponiveis = [];
  ProvaParceirosModelos? quemEstaCorrendoAgora;

  bool carregando = false;
  bool carregandoMais = false;

  void listar(UsuarioModelo? usuario, String idProva) async {
    carregando = true;
    notifyListeners();

    var (:lista, :quemEstaCorrendoAgora) = await _servico.listarPorProva(usuario, idProva);

    ordemdeentradas = lista;
    this.quemEstaCorrendoAgora = quemEstaCorrendoAgora;
    carregando = false;
    notifyListeners();
  }

  Future<void> listarPorListaCompeticao(UsuarioModelo? usuario, String idListaCompeticao, String idEmpresa, String idEvento, String pesquisa, {String somatoria = '', int pagina = 0}) async {
    // printb(idListaCompeticao);
    if (pagina == 0) {
      carregando = true;
    } else {
      carregandoMais = true;
    }
    notifyListeners();

    var result = await _servico.listarPorListaCompeticao(
        usuario, idListaCompeticao, idEmpresa, idEvento, pesquisa,
        somatoria: somatoria, pagina: pagina);
    
    List<ProvaParceirosModelos> lista = result.lista;
    
    if (pagina == 0) {
      ordemdeentradas = lista;
      somatoriasDisponiveis = result.somatoriasDisponiveis;
    } else {
      ordemdeentradas.addAll(lista);
    }
    
    if (pagina == 0) {
      carregando = false;
    } else {
      carregandoMais = false;
    }
    notifyListeners();
  }
}
