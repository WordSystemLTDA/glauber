// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

class ComprasModelo {
  final String id;
  final String valorIngresso;
  final String valorTaxa;
  final String valorDesconto;
  final String valorTotal;
  final String valorFiliacao;
  final String status;
  final String codigoQr;
  final String codigoPIX;
  final String idCliente;
  final String dataCompra;
  final String horaCompra;
  String pago;
  final String nomeProva;
  final String nomeEmpresa;
  final String idEvento;
  final String nomeEvento;
  final String dataEvento;
  final String horaInicio;
  final String horaInicioF;
  final String horaTermino;
  final String numeroCelular;
  final String formaPagamento;
  final String idFormaPagamento;
  final String quandoInscricaoNaoPaga;
  final String mensagemQuandoInscricaoNaoPaga;
  final List<ProvaModelo> provas;

  ComprasModelo({
    required this.id,
    required this.nomeEmpresa,
    required this.valorIngresso,
    required this.valorTaxa,
    required this.valorDesconto,
    required this.valorTotal,
    required this.valorFiliacao,
    required this.status,
    required this.codigoQr,
    required this.codigoPIX,
    required this.idCliente,
    required this.dataCompra,
    required this.horaCompra,
    required this.pago,
    required this.nomeProva,
    required this.nomeEvento,
    required this.idEvento,
    required this.dataEvento,
    required this.horaInicio,
    required this.horaInicioF,
    required this.horaTermino,
    required this.formaPagamento,
    required this.idFormaPagamento,
    required this.quandoInscricaoNaoPaga,
    required this.mensagemQuandoInscricaoNaoPaga,
    required this.numeroCelular,
    required this.provas,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'valorIngresso': valorIngresso,
      'valorTaxa': valorTaxa,
      'valorDesconto': valorDesconto,
      'valorTotal': valorTotal,
      'valorFiliacao': valorFiliacao,
      'status': status,
      'codigoQr': codigoQr,
      'codigoPIX': codigoPIX,
      'idCliente': idCliente,
      'dataCompra': dataCompra,
      'horaCompra': horaCompra,
      'pago': pago,
      'nomeProva': nomeProva,
      'nomeEmpresa': nomeEmpresa,
      'idEvento': idEvento,
      'nomeEvento': nomeEvento,
      'dataEvento': dataEvento,
      'horaInicio': horaInicio,
      'horaInicioF': horaInicioF,
      'horaTermino': horaTermino,
      'numeroCelular': numeroCelular,
      'formaPagamento': formaPagamento,
      'idFormaPagamento': idFormaPagamento,
      'quandoInscricaoNaoPaga': quandoInscricaoNaoPaga,
      'mensagemQuandoInscricaoNaoPaga': mensagemQuandoInscricaoNaoPaga,
      'provas': provas.map((x) => x.toMap()).toList(),
    };
  }

  factory ComprasModelo.fromMap(Map<String, dynamic> map) {
    return ComprasModelo(
      id: map['id'] as String,
      valorIngresso: map['valorIngresso'] as String,
      valorTaxa: map['valorTaxa'] as String,
      valorDesconto: map['valorDesconto'] as String,
      valorTotal: map['valorTotal'] as String,
      valorFiliacao: map['valorFiliacao'] as String,
      status: map['status'] as String,
      codigoQr: map['codigoQr'] as String,
      codigoPIX: map['codigoPIX'] as String,
      idCliente: map['idCliente'] as String,
      dataCompra: map['dataCompra'] as String,
      horaCompra: map['horaCompra'] as String,
      pago: map['pago'] as String,
      nomeProva: map['nomeProva'] as String,
      nomeEmpresa: map['nomeEmpresa'] as String,
      idEvento: map['idEvento'] as String,
      nomeEvento: map['nomeEvento'] as String,
      dataEvento: map['dataEvento'] as String,
      horaInicio: map['horaInicio'] as String,
      horaInicioF: map['horaInicioF'] as String,
      horaTermino: map['horaTermino'] as String,
      numeroCelular: map['numeroCelular'] as String,
      formaPagamento: map['formaPagamento'] as String,
      idFormaPagamento: map['idFormaPagamento'] as String,
      quandoInscricaoNaoPaga: map['quandoInscricaoNaoPaga'] as String,
      mensagemQuandoInscricaoNaoPaga: map['mensagemQuandoInscricaoNaoPaga'] as String,
      provas: List<ProvaModelo>.from(
        (map['provas'] as List<dynamic>).map<ProvaModelo>(
          (x) => ProvaModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ComprasModelo.fromJson(String source) => ComprasModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
