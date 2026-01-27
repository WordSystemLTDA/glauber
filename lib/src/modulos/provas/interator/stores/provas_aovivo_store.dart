import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/modelo_prova_ao_vivo.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/prova_servico.dart';

class ProvasAoVivoStore extends ChangeNotifier {
  final ProvaServico _provaServico;

  ProvasAoVivoStore(this._provaServico);

  bool carregando = false;
  List<ModeloProvaAoVivo> listaCompeticao = [];
  EventoModelo? evento;
  List<NomesCabeceiraModelo>? nomesCabeceira = [];

  void listar(UsuarioModelo? usuario, String idEmpresa, String idEvento) async {
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
