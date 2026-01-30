// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ParceirosCompraModelo {
  final String id;
  String nomeParceiro;
  String idParceiro;
  final String idProva;
  final String nomeProva;
  final String nomeModalidade;
  final String idModalidade;
  final String nomeCidade;
  final String siglaEstado;
  String parceiroTemCompra;

  ParceirosCompraModelo({
    required this.id,
    required this.nomeParceiro,
    required this.idParceiro,
    required this.idProva,
    required this.nomeProva,
    required this.nomeModalidade,
    required this.idModalidade,
    required this.nomeCidade,
    required this.siglaEstado,
    required this.parceiroTemCompra,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomeParceiro': nomeParceiro,
      'idParceiro': idParceiro,
      'idProva': idProva,
      'nomeProva': nomeProva,
      'nomeModalidade': nomeModalidade,
      'idModalidade': idModalidade,
      'nomeCidade': nomeCidade,
      'siglaEstado': siglaEstado,
      'parceiroTemCompra': parceiroTemCompra,
    };
  }

  factory ParceirosCompraModelo.fromMap(Map<String, dynamic> map) {
    return ParceirosCompraModelo(
      id: map['id'] as String,
      nomeParceiro: map['nomeParceiro'] as String,
      idParceiro: map['idParceiro'] as String,
      idProva: map['idProva'] as String,
      nomeProva: map['nomeProva'] as String,
      nomeModalidade: map['nomeModalidade'] as String,
      idModalidade: map['idModalidade'] as String,
      nomeCidade: map['nomeCidade'] as String,
      siglaEstado: map['siglaEstado'] as String,
      parceiroTemCompra: map['parceiroTemCompra'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParceirosCompraModelo.fromJson(String source) => ParceirosCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
