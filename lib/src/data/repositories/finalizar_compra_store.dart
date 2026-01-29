import 'package:flutter/material.dart';
import 'package:provadelaco/src/domain/models/retorno_compra_modelo.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/data/servicos/finalizar_compra_servico.dart';
import 'package:provadelaco/src/domain/models/formulario_compra_modelo.dart';
import 'package:provadelaco/src/domain/models/formulario_editar_compra_modelo.dart';

class FinalizarCompraStore extends ChangeNotifier {
  final FinalizarCompraServico _servico;

  FinalizarCompraStore(this._servico) : super();

  bool carregando = false;

  Future<({DadosRetornoCompraModelo? dados, String mensagem})> editar(UsuarioModelo? usuario, FormularioEditarCompraModelo dados) async {
    carregando = true;
    notifyListeners();

    var dadosRetorno = await _servico.editar(usuario, dados);

    carregando = true;
    notifyListeners();

    return (dados: dadosRetorno.dados, mensagem: dadosRetorno.mensagem);
  }

  Future<({DadosRetornoCompraModelo? dados, String mensagem})> inserir(UsuarioModelo? usuario, FormularioCompraModelo dados) async {
    carregando = true;
    notifyListeners();

    var dadosRetorno = await _servico.inserir(usuario, dados);

    carregando = true;
    notifyListeners();

    return (dados: dadosRetorno.dados, mensagem: dadosRetorno.mensagem);
  }
}
