// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ComprasModelo {
  final String id;
  final String valorIngresso;
  final String valorTaxa;
  final String valorDesconto;
  final String valorTotal;
  final String status;
  final String codigoQr;
  final String idCliente;
  final String dataCompra;
  final String horaCompra;
  final String pago;
  final String nomeProva;

  ComprasModelo({
    required this.id,
    required this.valorIngresso,
    required this.valorTaxa,
    required this.valorDesconto,
    required this.valorTotal,
    required this.status,
    required this.codigoQr,
    required this.idCliente,
    required this.dataCompra,
    required this.horaCompra,
    required this.pago,
    required this.nomeProva,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'valorIngresso': valorIngresso,
      'valorTaxa': valorTaxa,
      'valorDesconto': valorDesconto,
      'valorTotal': valorTotal,
      'status': status,
      'codigoQr': codigoQr,
      'idCliente': idCliente,
      'dataCompra': dataCompra,
      'horaCompra': horaCompra,
      'pago': pago,
      'nomeProva': nomeProva,
    };
  }

  factory ComprasModelo.fromMap(Map<String, dynamic> map) {
    return ComprasModelo(
      id: map['id'] as String,
      valorIngresso: map['valorIngresso'] as String,
      valorTaxa: map['valorTaxa'] as String,
      valorDesconto: map['valorDesconto'] as String,
      valorTotal: map['valorTotal'] as String,
      status: map['status'] as String,
      codigoQr: map['codigoQr'] as String,
      idCliente: map['idCliente'] as String,
      dataCompra: map['dataCompra'] as String,
      horaCompra: map['horaCompra'] as String,
      pago: map['pago'] as String,
      nomeProva: map['nomeProva'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ComprasModelo.fromJson(String source) => ComprasModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
