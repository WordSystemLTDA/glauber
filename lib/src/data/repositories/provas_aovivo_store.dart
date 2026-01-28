import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/domain/models/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/domain/models/evento_modelo.dart';
import 'package:provadelaco/src/data/servicos/prova_sevico_impl.dart';
import 'package:provadelaco/src/domain/models/modelo_prova_ao_vivo.dart';

class ProvasAoVivoStore extends ChangeNotifier {
  final ProvaServico _provaServico;

  ProvasAoVivoStore(this._provaServico);

  bool carregando = false;
  List<ModeloProvaAoVivo> listaCompeticao = [];
  EventoModelo? evento;
  List<NomesCabeceiraModelo>? nomesCabeceira = [];

  Future<void> listar(UsuarioModelo? usuario, String idEmpresa, String idEvento) async {
    carregando = true;
    notifyListeners();

    var resposta = await _provaServico.listarAoVivo(usuario, idEmpresa, idEvento);

    listaCompeticao = resposta.listaCompeticao;
    evento = resposta.evento;
    nomesCabeceira = resposta.nomesCabeceira;
    carregando = false;
    notifyListeners();
  }
}
