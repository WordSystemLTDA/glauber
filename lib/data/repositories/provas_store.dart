import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';
import 'package:provadelaco/domain/models/animal/modelo_animal.dart';
import 'package:provadelaco/domain/models/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/domain/models/pagamentos_modelo.dart';
import 'package:provadelaco/domain/models/evento/evento_modelo.dart';
import 'package:provadelaco/data/servicos/prova_sevico.dart';
import 'package:provadelaco/domain/models/modalidade_prova_modelo.dart';

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
