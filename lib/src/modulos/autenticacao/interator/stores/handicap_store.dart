import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/handicap_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/handicap_servico.dart';

class HandiCapStore extends ValueNotifier<HandiCapEstado> {
  final HandiCapServico _handiCapServico;

  HandiCapStore(this._handiCapServico) : super(HandiCapEstadoInicial());

  void listar() async {
    value = HandiCapCarregando();

    _handiCapServico.listar().then((dados) {
      value = HandiCapCarregado(handicaps: dados);
    }).onError((error, stackTrace) {
      value = HandiCapErro(erro: Exception(error));
    });
  }
}
