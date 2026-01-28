// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/domain/models/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/domain/models/evento_modelo.dart';
import 'package:provadelaco/src/domain/models/modelo_prova_ao_vivo.dart';

class ModeloProvaAoVivoRetorno {
  final List<ModeloProvaAoVivo> listaCompeticao;
  final List<NomesCabeceiraModelo> nomesCabeceira;
  final EventoModelo evento;

  ModeloProvaAoVivoRetorno({required this.listaCompeticao, required this.nomesCabeceira, required this.evento});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'listaCompeticao': listaCompeticao.map((x) => x.toMap()).toList(),
      'nomesCabeceira': nomesCabeceira.map((x) => x.toMap()).toList(),
      'evento': evento.toMap(),
    };
  }

  factory ModeloProvaAoVivoRetorno.fromMap(Map<String, dynamic> map) {
    return ModeloProvaAoVivoRetorno(
      listaCompeticao: List<ModeloProvaAoVivo>.from(
        (map['listaCompeticao'] as List<dynamic>).map<ModeloProvaAoVivo>(
          (x) => ModeloProvaAoVivo.fromMap(x as Map<String, dynamic>),
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

  factory ModeloProvaAoVivoRetorno.fromJson(String source) => ModeloProvaAoVivoRetorno.fromMap(json.decode(source) as Map<String, dynamic>);
}
