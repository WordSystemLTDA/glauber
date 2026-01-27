import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/listar_informacoes_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/listar_informacoes_servico.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

class ListarInformacoesStore extends ChangeNotifier {
  final ListarInformacoesServico _servico;

  ListarInformacoesStore(this._servico);

  bool carregando = false;
  ListarInformacoesModelo? dados;

  Future<ListarInformacoesModelo> listarInformacoes(UsuarioModelo? usuario, List<ProvaModelo> provas, String idEvento, bool editando, String idVenda) async {
    carregando = true;
    notifyListeners();

    var (sucesso, mensagem, result) = await _servico.listarInformacoes(usuario, provas, idEvento, editando, idVenda);

    dados = result;

    carregando = true;
    notifyListeners();

    return result;
  }
}
