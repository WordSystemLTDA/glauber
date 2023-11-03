// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:glauber/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:glauber/src/modulos/provas/interator/modelos/prova_modelo.dart';

class ListarInformacoesModelo {
  final ProvaModelo prova;
  final EventoModelo evento;

  ListarInformacoesModelo({required this.prova, required this.evento});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prova': prova.toMap(),
      'evento': evento.toMap(),
    };
  }

  factory ListarInformacoesModelo.fromMap(Map<String, dynamic> map) {
    return ListarInformacoesModelo(
      prova: ProvaModelo.fromMap(map['prova'] as Map<String, dynamic>),
      evento: EventoModelo.fromMap(map['evento'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListarInformacoesModelo.fromJson(String source) => ListarInformacoesModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
