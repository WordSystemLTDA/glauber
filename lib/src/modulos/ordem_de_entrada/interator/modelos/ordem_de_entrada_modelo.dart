// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrdemDeEntradaModelo {
  final String id;
  final String somatoria;
  final String numeroDaInscricao;
  final String nomeEmpresa;
  final String prova;
  final String numeroCelular;

  OrdemDeEntradaModelo({
    required this.id,
    required this.somatoria,
    required this.numeroDaInscricao,
    required this.nomeEmpresa,
    required this.prova,
    required this.numeroCelular,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'somatoria': somatoria,
      'numeroDaInscricao': numeroDaInscricao,
      'nomeEmpresa': nomeEmpresa,
      'prova': prova,
      'numeroCelular': numeroCelular,
    };
  }

  factory OrdemDeEntradaModelo.fromMap(Map<String, dynamic> map) {
    return OrdemDeEntradaModelo(
      id: map['id'] as String,
      somatoria: map['somatoria'] as String,
      numeroDaInscricao: map['numeroDaInscricao'] as String,
      nomeEmpresa: map['nomeEmpresa'] as String,
      prova: map['prova'] as String,
      numeroCelular: map['numeroCelular'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrdemDeEntradaModelo.fromJson(String source) => OrdemDeEntradaModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
