// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RetornoGerarPagamentos {
  final String codigoPIX;
  final String idCliente;
  final String txid;

  RetornoGerarPagamentos({
    required this.codigoPIX,
    required this.idCliente,
    required this.txid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigoPIX': codigoPIX,
      'idCliente': idCliente,
      'txid': txid,
    };
  }

  factory RetornoGerarPagamentos.fromMap(Map<String, dynamic> map) {
    return RetornoGerarPagamentos(
      codigoPIX: map['codigoPIX'] as String,
      idCliente: map['idCliente'] as String,
      txid: map['txid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RetornoGerarPagamentos.fromJson(String source) => RetornoGerarPagamentos.fromMap(json.decode(source) as Map<String, dynamic>);
}
