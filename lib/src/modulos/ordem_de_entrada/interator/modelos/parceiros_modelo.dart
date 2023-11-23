// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ParceirosModelos {
  final String id;
  final String somatoria;
  final String numeroDaInscricao;
  final String nomeCliente;

  ParceirosModelos({required this.id, required this.somatoria, required this.numeroDaInscricao, required this.nomeCliente});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'somatoria': somatoria,
      'numeroDaInscricao': numeroDaInscricao,
      'nomeCliente': nomeCliente,
    };
  }

  factory ParceirosModelos.fromMap(Map<String, dynamic> map) {
    return ParceirosModelos(
      id: map['id'] as String,
      somatoria: map['somatoria'] as String,
      numeroDaInscricao: map['numeroDaInscricao'] as String,
      nomeCliente: map['nomeCliente'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParceirosModelos.fromJson(String source) => ParceirosModelos.fromMap(json.decode(source) as Map<String, dynamic>);
}
