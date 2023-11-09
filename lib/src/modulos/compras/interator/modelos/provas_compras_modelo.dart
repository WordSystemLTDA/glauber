// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProvasComprasModelo {
  final String nomeCabeceira;
  final String nomeProva;
  final String total;

  ProvasComprasModelo({required this.nomeCabeceira, required this.nomeProva, required this.total});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nomeCabeceira': nomeCabeceira,
      'nomeProva': nomeProva,
      'total': total,
    };
  }

  factory ProvasComprasModelo.fromMap(Map<String, dynamic> map) {
    return ProvasComprasModelo(
      nomeCabeceira: map['nomeCabeceira'] as String,
      nomeProva: map['nomeProva'] as String,
      total: map['total'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvasComprasModelo.fromJson(String source) => ProvasComprasModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
