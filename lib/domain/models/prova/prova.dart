// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:provadelaco/domain/models/animal/animal.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/domain/models/permitir_compra_modelo.dart';

class ProvaModelo {
  final String id;
  final String nomeProva;
  final String valor;
  final String hcMinimo;
  final String hcMaximo;
  final String avulsa;
  final String quantMinima;
  final String quantMaxima;
  final PermitirCompraModelo permitirCompra;
  final String permitirSorteio;
  final String habilitarAoVivo;
  final String idListaCompeticao;
  final String? liberarReembolso;
  final String? descricao;
  final String? somatoriaHandicaps;
  final bool? sorteio;
  final String permitirEditarParceiros;
  final ModeloAnimal? animalSelecionado;
  String? nomeCabeceira;
  String? idCabeceira;
  List<CompetidoresModelo>? competidores;
  String? idmodalidade;

  ProvaModelo({
    required this.id,
    required this.nomeProva,
    required this.valor,
    required this.hcMinimo,
    required this.hcMaximo,
    required this.avulsa,
    required this.quantMinima,
    required this.quantMaxima,
    required this.permitirCompra,
    required this.permitirSorteio,
    required this.habilitarAoVivo,
    required this.idListaCompeticao,
    this.liberarReembolso = 'Não',
    this.descricao,
    this.somatoriaHandicaps,
    this.sorteio,
    required this.permitirEditarParceiros,
    this.animalSelecionado,
    this.nomeCabeceira,
    this.idCabeceira,
    this.competidores,
    this.idmodalidade,
  });



  ProvaModelo copyWith({
    String? id,
    String? nomeProva,
    String? valor,
    String? hcMinimo,
    String? hcMaximo,
    String? avulsa,
    String? quantMinima,
    String? quantMaxima,
    PermitirCompraModelo? permitirCompra,
    String? permitirSorteio,
    String? habilitarAoVivo,
    String? idListaCompeticao,
    ValueGetter<String?>? liberarReembolso,
    ValueGetter<String?>? descricao,
    ValueGetter<String?>? somatoriaHandicaps,
    ValueGetter<bool?>? sorteio,
    String? permitirEditarParceiros,
    ValueGetter<ModeloAnimal?>? animalSelecionado,
    ValueGetter<String?>? nomeCabeceira,
    ValueGetter<String?>? idCabeceira,
    ValueGetter<List<CompetidoresModelo>?>? competidores,
    ValueGetter<String?>? idmodalidade,
  }) {
    return ProvaModelo(
      id: id ?? this.id,
      nomeProva: nomeProva ?? this.nomeProva,
      valor: valor ?? this.valor,
      hcMinimo: hcMinimo ?? this.hcMinimo,
      hcMaximo: hcMaximo ?? this.hcMaximo,
      avulsa: avulsa ?? this.avulsa,
      quantMinima: quantMinima ?? this.quantMinima,
      quantMaxima: quantMaxima ?? this.quantMaxima,
      permitirCompra: permitirCompra ?? this.permitirCompra,
      permitirSorteio: permitirSorteio ?? this.permitirSorteio,
      habilitarAoVivo: habilitarAoVivo ?? this.habilitarAoVivo,
      idListaCompeticao: idListaCompeticao ?? this.idListaCompeticao,
      liberarReembolso: liberarReembolso != null ? liberarReembolso() : this.liberarReembolso,
      descricao: descricao != null ? descricao() : this.descricao,
      somatoriaHandicaps: somatoriaHandicaps != null ? somatoriaHandicaps() : this.somatoriaHandicaps,
      sorteio: sorteio != null ? sorteio() : this.sorteio,
      permitirEditarParceiros: permitirEditarParceiros ?? this.permitirEditarParceiros,
      animalSelecionado: animalSelecionado != null ? animalSelecionado() : this.animalSelecionado,
      nomeCabeceira: nomeCabeceira != null ? nomeCabeceira() : this.nomeCabeceira,
      idCabeceira: idCabeceira != null ? idCabeceira() : this.idCabeceira,
      competidores: competidores != null ? competidores() : this.competidores,
      idmodalidade: idmodalidade != null ? idmodalidade() : this.idmodalidade,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeProva': nomeProva,
      'valor': valor,
      'hcMinimo': hcMinimo,
      'hcMaximo': hcMaximo,
      'avulsa': avulsa,
      'quantMinima': quantMinima,
      'quantMaxima': quantMaxima,
      'permitirCompra': permitirCompra.toMap(),
      'permitirSorteio': permitirSorteio,
      'habilitarAoVivo': habilitarAoVivo,
      'idListaCompeticao': idListaCompeticao,
      'liberarReembolso': liberarReembolso,
      'descricao': descricao,
      'somatoriaHandicaps': somatoriaHandicaps,
      'sorteio': sorteio,
      'permitirEditarParceiros': permitirEditarParceiros,
      'animalSelecionado': animalSelecionado?.toMap(),
      'nomeCabeceira': nomeCabeceira,
      'idCabeceira': idCabeceira,
      'competidores': competidores?.map((x) => x.toMap()).toList(),
      'idmodalidade': idmodalidade,
    };
  }

  factory ProvaModelo.fromMap(Map<String, dynamic> map) {
    return ProvaModelo(
      id: map['id'] ?? '',
      nomeProva: map['nomeProva'] ?? '',
      valor: map['valor'] ?? '',
      hcMinimo: map['hcMinimo'] ?? '',
      hcMaximo: map['hcMaximo'] ?? '',
      avulsa: map['avulsa'] ?? '',
      quantMinima: map['quantMinima'] ?? '',
      quantMaxima: map['quantMaxima'] ?? '',
      permitirCompra: PermitirCompraModelo.fromMap(map['permitirCompra']),
      permitirSorteio: map['permitirSorteio'] ?? '',
      habilitarAoVivo: map['habilitarAoVivo'] ?? '',
      idListaCompeticao: map['idListaCompeticao'] ?? '',
      liberarReembolso: map['liberarReembolso'],
      descricao: map['descricao'],
      somatoriaHandicaps: map['somatoriaHandicaps'],
      sorteio: map['sorteio'],
      permitirEditarParceiros: map['permitirEditarParceiros'] ?? '',
      animalSelecionado: map['animalSelecionado'] != null ? ModeloAnimal.fromMap(map['animalSelecionado']) : null,
      nomeCabeceira: map['nomeCabeceira'],
      idCabeceira: map['idCabeceira'],
      competidores: map['competidores'] != null ? List<CompetidoresModelo>.from(map['competidores']?.map((x) => CompetidoresModelo.fromMap(x))) : null,
      idmodalidade: map['idmodalidade'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvaModelo.fromJson(String source) => ProvaModelo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProvaModelo(id: $id, nomeProva: $nomeProva, valor: $valor, hcMinimo: $hcMinimo, hcMaximo: $hcMaximo, avulsa: $avulsa, quantMinima: $quantMinima, quantMaxima: $quantMaxima, permitirCompra: $permitirCompra, permitirSorteio: $permitirSorteio, habilitarAoVivo: $habilitarAoVivo, idListaCompeticao: $idListaCompeticao, liberarReembolso: $liberarReembolso, descricao: $descricao, somatoriaHandicaps: $somatoriaHandicaps, sorteio: $sorteio, permitirEditarParceiros: $permitirEditarParceiros, animalSelecionado: $animalSelecionado, nomeCabeceira: $nomeCabeceira, idCabeceira: $idCabeceira, competidores: $competidores, idmodalidade: $idmodalidade)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProvaModelo &&
      other.id == id &&
      other.nomeProva == nomeProva &&
      other.valor == valor &&
      other.hcMinimo == hcMinimo &&
      other.hcMaximo == hcMaximo &&
      other.avulsa == avulsa &&
      other.quantMinima == quantMinima &&
      other.quantMaxima == quantMaxima &&
      other.permitirCompra == permitirCompra &&
      other.permitirSorteio == permitirSorteio &&
      other.habilitarAoVivo == habilitarAoVivo &&
      other.idListaCompeticao == idListaCompeticao &&
      other.liberarReembolso == liberarReembolso &&
      other.descricao == descricao &&
      other.somatoriaHandicaps == somatoriaHandicaps &&
      other.sorteio == sorteio &&
      other.permitirEditarParceiros == permitirEditarParceiros &&
      other.animalSelecionado == animalSelecionado &&
      other.nomeCabeceira == nomeCabeceira &&
      other.idCabeceira == idCabeceira &&
      listEquals(other.competidores, competidores) &&
      other.idmodalidade == idmodalidade;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nomeProva.hashCode ^
      valor.hashCode ^
      hcMinimo.hashCode ^
      hcMaximo.hashCode ^
      avulsa.hashCode ^
      quantMinima.hashCode ^
      quantMaxima.hashCode ^
      permitirCompra.hashCode ^
      permitirSorteio.hashCode ^
      habilitarAoVivo.hashCode ^
      idListaCompeticao.hashCode ^
      liberarReembolso.hashCode ^
      descricao.hashCode ^
      somatoriaHandicaps.hashCode ^
      sorteio.hashCode ^
      permitirEditarParceiros.hashCode ^
      animalSelecionado.hashCode ^
      nomeCabeceira.hashCode ^
      idCabeceira.hashCode ^
      competidores.hashCode ^
      idmodalidade.hashCode;
  }
}
