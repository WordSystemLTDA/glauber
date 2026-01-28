import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/domain/models/modelo_animal.dart';
import 'package:provadelaco/src/domain/models/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/domain/models/pagamentos_modelo.dart';
import 'package:provadelaco/src/domain/models/evento_modelo.dart';
import 'package:provadelaco/src/data/servicos/prova_sevico_impl.dart';
import 'package:provadelaco/src/domain/models/modalidade_prova_modelo.dart';

class ProvasStore extends ChangeNotifier {
  final ProvaServico _provaServico;

  ProvasStore(this._provaServico) : super();

  List<ModalidadeProvaModelo> provas = [];
  EventoModelo? evento;
  ModeloAnimal? animalPadrao;
  List<NomesCabeceiraModelo>? nomesCabeceira = [];
  List<PagamentosModelo>? pagamentosDisponiveis = [];

  bool carregando = false;

  void listar(UsuarioModelo? usuario, String idEvento, String tipo) async {
    carregando = true;
    notifyListeners();

    var resposta = await _provaServico.listar(usuario, idEvento, tipo);

    provas = resposta.provas;
    evento = resposta.evento;
    animalPadrao = resposta.animalPadrao;
    nomesCabeceira = resposta.nomesCabeceira;
    pagamentosDisponiveis = resposta.pagamentoDisponiveis;
    carregando = false;
    notifyListeners();
  }
}
