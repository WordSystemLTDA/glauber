import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:provadelaco/domain/models/prova/prova.dart';

class ModalidadeProvaModelo {
  final String modalidade;
  final String nomemodalidade;
  final List<ProvaModelo> provas;

  ModalidadeProvaModelo({
    required this.modalidade,
    required this.nomemodalidade,
    required this.provas,
  });

  ModalidadeProvaModelo copyWith({
    String? modalidade,
    String? nomemodalidade,
    List<ProvaModelo>? provas,
  }) {
    return ModalidadeProvaModelo(
      modalidade: modalidade ?? this.modalidade,
      nomemodalidade: nomemodalidade ?? this.nomemodalidade,
      provas: provas ?? this.provas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'modalidade': modalidade,
      'nomemodalidade': nomemodalidade,
      'provas': provas.map((x) => x.toMap()).toList(),
    };
  }

  factory ModalidadeProvaModelo.fromMap(Map<String, dynamic> map) {
    return ModalidadeProvaModelo(
      modalidade: map['modalidade'] ?? '',
      nomemodalidade: map['nomemodalidade'] ?? '',
      provas: List<ProvaModelo>.from(map['provas']?.map((x) => ProvaModelo.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ModalidadeProvaModelo.fromJson(String source) => ModalidadeProvaModelo.fromMap(json.decode(source));

  @override
  String toString() => 'ModalidadeProvaModelo(modalidade: $modalidade, nomemodalidade: $nomemodalidade, provas: $provas)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ModalidadeProvaModelo &&
      other.modalidade == modalidade &&
      other.nomemodalidade == nomemodalidade &&
      listEquals(other.provas, provas);
  }

  @override
  int get hashCode => modalidade.hashCode ^ nomemodalidade.hashCode ^ provas.hashCode;
}
