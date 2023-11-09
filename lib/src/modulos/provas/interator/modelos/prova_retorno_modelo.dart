// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:glauber/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:glauber/src/modulos/provas/interator/modelos/prova_modelo.dart';

class ProvaRetornoModelo {
  final bool sucesso;
  final List<ProvaModelo> provas;
  final List<NomesCabeceiraModelo> nomesCabeceira;
  final EventoModelo evento;

  ProvaRetornoModelo({required this.provas, required this.nomesCabeceira, required this.evento, required this.sucesso});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sucesso': sucesso,
      'provas': provas.map((x) => x.toMap()).toList(),
      'nomesCabeceira': nomesCabeceira.map((x) => x.toMap()).toList(),
      'evento': evento.toMap(),
    };
  }

  factory ProvaRetornoModelo.fromMap(Map<String, dynamic> map) {
    return ProvaRetornoModelo(
      sucesso: map['sucesso'] as bool,
      provas: List<ProvaModelo>.from(
        (map['provas'] as List<dynamic>).map<ProvaModelo>(
          (x) => ProvaModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      nomesCabeceira: List<NomesCabeceiraModelo>.from(
        (map['nomesCabeceira'] as List<dynamic>).map<NomesCabeceiraModelo>(
          (x) => NomesCabeceiraModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      evento: EventoModelo.fromMap(map['evento'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvaRetornoModelo.fromJson(String source) => ProvaRetornoModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
