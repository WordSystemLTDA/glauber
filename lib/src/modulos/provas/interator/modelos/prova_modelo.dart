// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/competidores_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/permitir_compra_modelo.dart';

// ignore: must_be_immutable
class ProvaModelo extends Equatable {
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
  final String? descricao;
  final String? somatoriaHandicaps;
  final bool? sorteio;

  String? nomeCabeceira;
  String? idCabeceira;
  List<CompetidoresModelo>? competidores;

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
    this.descricao,
    this.somatoriaHandicaps,
    this.sorteio,
    this.nomeCabeceira,
    this.idCabeceira,
    this.competidores,
  });

  @override
  List<Object?> get props => [
        id,
        nomeProva,
        valor,
        hcMinimo,
        hcMaximo,
        avulsa,
        quantMinima,
        quantMaxima,
        permitirCompra,
        somatoriaHandicaps,
        nomeCabeceira,
        idCabeceira,
        competidores,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      'descricao': descricao,
      'somatoriaHandicaps': somatoriaHandicaps,
      'sorteio': sorteio,
      'nomeCabeceira': nomeCabeceira,
      'idCabeceira': idCabeceira,
      'competidores': competidores?.map((x) => x.toMap()).toList(),
    };
  }

  factory ProvaModelo.fromMap(Map<String, dynamic> map) {
    return ProvaModelo(
      id: map['id'] as String,
      nomeProva: map['nomeProva'] as String,
      valor: map['valor'] as String,
      hcMinimo: map['hcMinimo'] as String,
      hcMaximo: map['hcMaximo'] as String,
      avulsa: map['avulsa'] as String,
      quantMinima: map['quantMinima'] as String,
      quantMaxima: map['quantMaxima'] as String,
      permitirCompra: PermitirCompraModelo.fromMap(map['permitirCompra'] as Map<String, dynamic>),
      permitirSorteio: map['permitirSorteio'] as String,
      habilitarAoVivo: map['habilitarAoVivo'] as String,
      descricao: map['descricao'] != null ? map['descricao'] as String : null,
      somatoriaHandicaps: map['somatoriaHandicaps'] != null ? map['somatoriaHandicaps'] as String : null,
      sorteio: map['sorteio'] != null ? map['sorteio'] as bool : null,
      nomeCabeceira: map['nomeCabeceira'] != null ? map['nomeCabeceira'] as String : null,
      idCabeceira: map['idCabeceira'] != null ? map['idCabeceira'] as String : null,
      competidores: map['competidores'] != null
          ? List<CompetidoresModelo>.from(
              (map['competidores'] as List<int>).map<CompetidoresModelo?>(
                (x) => CompetidoresModelo.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvaModelo.fromJson(String source) => ProvaModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
