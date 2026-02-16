// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:provadelaco/domain/models/animal/animal.dart';
import 'package:provadelaco/domain/models/evento/evento.dart';
import 'package:provadelaco/domain/models/modalidade_prova_modelo.dart';
import 'package:provadelaco/domain/models/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/domain/models/pagamentos_modelo.dart';

class ProvaRetornoModelo {
  final bool sucesso;
  final List<ModalidadeProvaModelo> provas;
  final List<NomesCabeceiraModelo> nomesCabeceira;
  final EventoModelo evento;
  final ModeloAnimal? animalPadrao;
  final List<PagamentosModelo> pagamentoDisponiveis;

  ProvaRetornoModelo({
    required this.sucesso,
    required this.provas,
    required this.nomesCabeceira,
    required this.evento,
    this.animalPadrao,
    required this.pagamentoDisponiveis,
  });



  ProvaRetornoModelo copyWith({
    bool? sucesso,
    List<ModalidadeProvaModelo>? provas,
    List<NomesCabeceiraModelo>? nomesCabeceira,
    EventoModelo? evento,
    ValueGetter<ModeloAnimal?>? animalPadrao,
    List<PagamentosModelo>? pagamentoDisponiveis,
  }) {
    return ProvaRetornoModelo(
      sucesso: sucesso ?? this.sucesso,
      provas: provas ?? this.provas,
      nomesCabeceira: nomesCabeceira ?? this.nomesCabeceira,
      evento: evento ?? this.evento,
      animalPadrao: animalPadrao != null ? animalPadrao() : this.animalPadrao,
      pagamentoDisponiveis: pagamentoDisponiveis ?? this.pagamentoDisponiveis,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sucesso': sucesso,
      'provas': provas.map((x) => x.toMap()).toList(),
      'nomesCabeceira': nomesCabeceira.map((x) => x.toMap()).toList(),
      'evento': evento.toMap(),
      'animalPadrao': animalPadrao?.toMap(),
      'pagamentoDisponiveis': pagamentoDisponiveis.map((x) => x.toMap()).toList(),
    };
  }

  factory ProvaRetornoModelo.fromMap(Map<String, dynamic> map) {
    return ProvaRetornoModelo(
      sucesso: map['sucesso'] ?? false,
      provas: List<ModalidadeProvaModelo>.from(map['provas']?.map((x) => ModalidadeProvaModelo.fromMap(x))),
      nomesCabeceira: List<NomesCabeceiraModelo>.from(map['nomesCabeceira']?.map((x) => NomesCabeceiraModelo.fromMap(x))),
      evento: EventoModelo.fromMap(map['evento']),
      animalPadrao: map['animalPadrao'] != null ? ModeloAnimal.fromMap(map['animalPadrao']) : null,
      pagamentoDisponiveis: List<PagamentosModelo>.from(map['pagamentoDisponiveis']?.map((x) => PagamentosModelo.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvaRetornoModelo.fromJson(String source) => ProvaRetornoModelo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProvaRetornoModelo(sucesso: $sucesso, provas: $provas, nomesCabeceira: $nomesCabeceira, evento: $evento, animalPadrao: $animalPadrao, pagamentoDisponiveis: $pagamentoDisponiveis)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProvaRetornoModelo &&
      other.sucesso == sucesso &&
      listEquals(other.provas, provas) &&
      listEquals(other.nomesCabeceira, nomesCabeceira) &&
      other.evento == evento &&
      other.animalPadrao == animalPadrao &&
      listEquals(other.pagamentoDisponiveis, pagamentoDisponiveis);
  }

  @override
  int get hashCode {
    return sucesso.hashCode ^
      provas.hashCode ^
      nomesCabeceira.hashCode ^
      evento.hashCode ^
      animalPadrao.hashCode ^
      pagamentoDisponiveis.hashCode;
  }
}
