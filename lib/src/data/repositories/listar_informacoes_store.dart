import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/data/servicos/listar_informacoes_servico_impl.dart';
import 'package:provadelaco/src/domain/models/listar_informacoes_modelo.dart';
import 'package:provadelaco/src/domain/models/prova_modelo.dart';

class ListarInformacoesStore extends ChangeNotifier {
  final ListarInformacoesServicoImpl _servico;

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
