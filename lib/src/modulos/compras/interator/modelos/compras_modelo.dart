// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ComprasModelo {
  final String id;
  final String valorTotal;
  final String codigoQr;

  ComprasModelo({
    required this.id,
    required this.valorTotal,
    required this.codigoQr,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'valorTotal': valorTotal,
      'codigoQr': codigoQr,
    };
  }

  factory ComprasModelo.fromMap(Map<String, dynamic> map) {
    return ComprasModelo(
      id: map['id'] as String,
      valorTotal: map['valorTotal'] as String,
      codigoQr: map['codigoQr'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ComprasModelo.fromJson(String source) => ComprasModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
