// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/domain/models/prova_parceiros_modelo.dart';

class ModeloProvaAoVivo {
  final String id;
  final String nome;
  final List<ProvaParceirosModelos> ordemDeEntradas;

  ModeloProvaAoVivo({required this.id, required this.nome, required this.ordemDeEntradas});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'ordemDeEntradas': ordemDeEntradas.map((x) => x.toMap()).toList(),
    };
  }

  factory ModeloProvaAoVivo.fromMap(Map<String, dynamic> map) {
    return ModeloProvaAoVivo(
      id: map['id'] as String,
      nome: map['nome'] as String,
      ordemDeEntradas: List<ProvaParceirosModelos>.from(
        (map['ordemDeEntradas'] as List<dynamic>).map<ProvaParceirosModelos>(
          (x) => ProvaParceirosModelos.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeloProvaAoVivo.fromJson(String source) => ModeloProvaAoVivo.fromMap(json.decode(source) as Map<String, dynamic>);
}
