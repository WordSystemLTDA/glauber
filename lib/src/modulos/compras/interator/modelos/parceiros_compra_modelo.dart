// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ParceirosCompraModelo {
  final String id;
  String nomeParceiro;
  final String nomeProva;
  final String nomeModalidade;

  ParceirosCompraModelo({
    required this.id,
    required this.nomeParceiro,
    required this.nomeProva,
    required this.nomeModalidade,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomeParceiro': nomeParceiro,
      'nomeProva': nomeProva,
      'nomeModalidade': nomeModalidade,
    };
  }

  factory ParceirosCompraModelo.fromMap(Map<String, dynamic> map) {
    return ParceirosCompraModelo(
      id: map['id'] as String,
      nomeParceiro: map['nomeParceiro'] as String,
      nomeProva: map['nomeProva'] as String,
      nomeModalidade: map['nomeModalidade'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParceirosCompraModelo.fromJson(String source) => ParceirosCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
