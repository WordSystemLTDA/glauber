import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/prova_sevico.dart';
import 'package:provadelaco/domain/models/animal/animal.dart';
import 'package:provadelaco/domain/models/evento/evento.dart';
import 'package:provadelaco/domain/models/modalidade_prova_modelo.dart';
import 'package:provadelaco/domain/models/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/domain/models/pagamentos_modelo.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';

class ProvasProvedor extends ChangeNotifier {
  final ProvaServico _provaServico;

  ProvasProvedor(this._provaServico) : super();

  List<ModalidadeProvaModelo> provas = [];
  EventoModelo? evento;
  ModeloAnimal? animalPadrao;
  List<NomesCabeceiraModelo>? nomesCabeceira = [];
  List<PagamentosModelo>? pagamentosDisponiveis = [];

  ModeloAnimal? _animalSelecionado;
  ModeloAnimal? get animalSelecionado => _animalSelecionado;

  set animalSelecionado(ModeloAnimal? value) {
    _animalSelecionado = value;
    notifyListeners();
  }

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
