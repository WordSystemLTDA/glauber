// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provadelaco/domain/models/prova_parceiros_modelo.dart';

class ModeloProvaAoVivo {
  final String id;
  final String nome;
  final ProvaParceirosModelos? quemEstaCorrendoAgora;
  final List<ProvaParceirosModelos> ordemDeEntradas;

  ModeloProvaAoVivo({
    required this.id,
    required this.nome,
    this.quemEstaCorrendoAgora,
    required this.ordemDeEntradas,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'quemEstaCorrendoAgora': quemEstaCorrendoAgora?.toMap(),
      'ordemDeEntradas': ordemDeEntradas.map((x) => x.toMap()).toList(),
    };
  }

  factory ModeloProvaAoVivo.fromMap(Map<String, dynamic> map) {
    return ModeloProvaAoVivo(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      quemEstaCorrendoAgora: map['quemEstaCorrendoAgora'] != null ? ProvaParceirosModelos.fromMap(map['quemEstaCorrendoAgora']) : null,
      ordemDeEntradas: List<ProvaParceirosModelos>.from(map['ordemDeEntradas']?.map((x) => ProvaParceirosModelos.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeloProvaAoVivo.fromJson(String source) => ModeloProvaAoVivo.fromMap(json.decode(source));

  ModeloProvaAoVivo copyWith({
    String? id,
    String? nome,
    ValueGetter<ProvaParceirosModelos?>? quemEstaCorrendoAgora,
    List<ProvaParceirosModelos>? ordemDeEntradas,
  }) {
    return ModeloProvaAoVivo(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      quemEstaCorrendoAgora: quemEstaCorrendoAgora != null ? quemEstaCorrendoAgora() : this.quemEstaCorrendoAgora,
      ordemDeEntradas: ordemDeEntradas ?? this.ordemDeEntradas,
    );
  }

  @override
  String toString() {
    return 'ModeloProvaAoVivo(id: $id, nome: $nome, quemEstaCorrendoAgora: $quemEstaCorrendoAgora, ordemDeEntradas: $ordemDeEntradas)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ModeloProvaAoVivo &&
        other.id == id &&
        other.nome == nome &&
        other.quemEstaCorrendoAgora == quemEstaCorrendoAgora &&
        listEquals(other.ordemDeEntradas, ordemDeEntradas);
  }

  @override
  int get hashCode {
    return id.hashCode ^ nome.hashCode ^ quemEstaCorrendoAgora.hashCode ^ ordemDeEntradas.hashCode;
  }
}
