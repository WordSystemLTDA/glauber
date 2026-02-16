// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:provadelaco/domain/models/parceiros_compra_modelo.dart';
import 'package:provadelaco/domain/models/prova/prova.dart';

class ComprasModelo extends Equatable {
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
  final String idEmpresa;
  final String nomeEvento;
  final String dataEvento;
  final String horaInicio;
  final String horaInicioF;
  final String parcelas;
  final String tipodevenda;
  final String horaTermino;
  final String numeroCelular;
  final String formaPagamento;
  final String idFormaPagamento;
  final String quandoInscricaoNaoPaga;
  final String mensagemQuandoInscricaoNaoPaga;
  // final String permitirEditarParceiros;
  final String permVincularParceiro;
  final String? pixVencido;
  final List<ProvaModelo> provas;
  final List<ParceirosCompraModelo> parceiros;
  final String? idCabeceira;
  final String reembolso;

  ComprasModelo({
    required this.id,
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
    required this.nomeEmpresa,
    required this.idEvento,
    required this.idEmpresa,
    required this.nomeEvento,
    required this.dataEvento,
    required this.horaInicio,
    required this.horaInicioF,
    required this.parcelas,
    required this.tipodevenda,
    required this.horaTermino,
    required this.numeroCelular,
    required this.formaPagamento,
    required this.idFormaPagamento,
    required this.quandoInscricaoNaoPaga,
    required this.mensagemQuandoInscricaoNaoPaga,
    required this.permVincularParceiro,
    this.pixVencido,
    required this.provas,
    required this.parceiros,
    this.idCabeceira,
    this.reembolso = 'Não',
  });

  Map<String, dynamic> toMap() {
    return {
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
      'idEmpresa': idEmpresa,
      'nomeEvento': nomeEvento,
      'dataEvento': dataEvento,
      'horaInicio': horaInicio,
      'horaInicioF': horaInicioF,
      'parcelas': parcelas,
      'tipodevenda': tipodevenda,
      'horaTermino': horaTermino,
      'numeroCelular': numeroCelular,
      'formaPagamento': formaPagamento,
      'idFormaPagamento': idFormaPagamento,
      'quandoInscricaoNaoPaga': quandoInscricaoNaoPaga,
      'mensagemQuandoInscricaoNaoPaga': mensagemQuandoInscricaoNaoPaga,
      'permVincularParceiro': permVincularParceiro,
      'pixVencido': pixVencido,
      'provas': provas.map((x) => x.toMap()).toList(),
      'parceiros': parceiros.map((x) => x.toMap()).toList(),
      'idCabeceira': idCabeceira,
      'reembolso': reembolso,
    };
  }

  factory ComprasModelo.fromMap(Map<String, dynamic> map) {
    return ComprasModelo(
      id: map['id'] ?? '',
      valorIngresso: map['valorIngresso'] ?? '',
      valorTaxa: map['valorTaxa'] ?? '',
      valorDesconto: map['valorDesconto'] ?? '',
      valorTotal: map['valorTotal'] ?? '',
      valorFiliacao: map['valorFiliacao'] ?? '',
      status: map['status'] ?? '',
      codigoQr: map['codigoQr'] ?? '',
      codigoPIX: map['codigoPIX'] ?? '',
      idCliente: map['idCliente'] ?? '',
      dataCompra: map['dataCompra'] ?? '',
      horaCompra: map['horaCompra'] ?? '',
      pago: map['pago'] ?? '',
      nomeProva: map['nomeProva'] ?? '',
      nomeEmpresa: map['nomeEmpresa'] ?? '',
      idEvento: map['idEvento'] ?? '',
      idEmpresa: map['idEmpresa'] ?? '',
      nomeEvento: map['nomeEvento'] ?? '',
      dataEvento: map['dataEvento'] ?? '',
      horaInicio: map['horaInicio'] ?? '',
      horaInicioF: map['horaInicioF'] ?? '',
      parcelas: map['parcelas'] ?? '',
      tipodevenda: map['tipodevenda'] ?? '',
      horaTermino: map['horaTermino'] ?? '',
      numeroCelular: map['numeroCelular'] ?? '',
      formaPagamento: map['formaPagamento'] ?? '',
      idFormaPagamento: map['idFormaPagamento'] ?? '',
      quandoInscricaoNaoPaga: map['quandoInscricaoNaoPaga'] ?? '',
      mensagemQuandoInscricaoNaoPaga: map['mensagemQuandoInscricaoNaoPaga'] ?? '',
      permVincularParceiro: map['permVincularParceiro'] ?? '',
      pixVencido: map['pixVencido'],
      provas: List<ProvaModelo>.from(map['provas']?.map((x) => ProvaModelo.fromMap(x))),
      parceiros: List<ParceirosCompraModelo>.from(map['parceiros']?.map((x) => ParceirosCompraModelo.fromMap(x))),
      idCabeceira: map['idCabeceira'],
      reembolso: map['reembolso'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ComprasModelo.fromJson(String source) => ComprasModelo.fromMap(json.decode(source));

  @override
  List<Object?> get props {
    return [
      id,
      valorIngresso,
      valorTaxa,
      valorDesconto,
      valorTotal,
      valorFiliacao,
      status,
      codigoQr,
      codigoPIX,
      idCliente,
      dataCompra,
      horaCompra,
      pago,
      nomeProva,
      nomeEmpresa,
      idEvento,
      idEmpresa,
      nomeEvento,
      dataEvento,
      horaInicio,
      horaInicioF,
      parcelas,
      tipodevenda,
      horaTermino,
      numeroCelular,
      formaPagamento,
      idFormaPagamento,
      quandoInscricaoNaoPaga,
      mensagemQuandoInscricaoNaoPaga,
      permVincularParceiro,
      pixVencido,
      provas,
      parceiros,
      idCabeceira,
      reembolso,
    ];
  }

  ComprasModelo copyWith({
    String? id,
    String? valorIngresso,
    String? valorTaxa,
    String? valorDesconto,
    String? valorTotal,
    String? valorFiliacao,
    String? status,
    String? codigoQr,
    String? codigoPIX,
    String? idCliente,
    String? dataCompra,
    String? horaCompra,
    String? pago,
    String? nomeProva,
    String? nomeEmpresa,
    String? idEvento,
    String? idEmpresa,
    String? nomeEvento,
    String? dataEvento,
    String? horaInicio,
    String? horaInicioF,
    String? parcelas,
    String? tipodevenda,
    String? horaTermino,
    String? numeroCelular,
    String? formaPagamento,
    String? idFormaPagamento,
    String? quandoInscricaoNaoPaga,
    String? mensagemQuandoInscricaoNaoPaga,
    String? permVincularParceiro,
    ValueGetter<String?>? pixVencido,
    List<ProvaModelo>? provas,
    List<ParceirosCompraModelo>? parceiros,
    ValueGetter<String?>? idCabeceira,
    String? reembolso,
  }) {
    return ComprasModelo(
      id: id ?? this.id,
      valorIngresso: valorIngresso ?? this.valorIngresso,
      valorTaxa: valorTaxa ?? this.valorTaxa,
      valorDesconto: valorDesconto ?? this.valorDesconto,
      valorTotal: valorTotal ?? this.valorTotal,
      valorFiliacao: valorFiliacao ?? this.valorFiliacao,
      status: status ?? this.status,
      codigoQr: codigoQr ?? this.codigoQr,
      codigoPIX: codigoPIX ?? this.codigoPIX,
      idCliente: idCliente ?? this.idCliente,
      dataCompra: dataCompra ?? this.dataCompra,
      horaCompra: horaCompra ?? this.horaCompra,
      pago: pago ?? this.pago,
      nomeProva: nomeProva ?? this.nomeProva,
      nomeEmpresa: nomeEmpresa ?? this.nomeEmpresa,
      idEvento: idEvento ?? this.idEvento,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      nomeEvento: nomeEvento ?? this.nomeEvento,
      dataEvento: dataEvento ?? this.dataEvento,
      horaInicio: horaInicio ?? this.horaInicio,
      horaInicioF: horaInicioF ?? this.horaInicioF,
      parcelas: parcelas ?? this.parcelas,
      tipodevenda: tipodevenda ?? this.tipodevenda,
      horaTermino: horaTermino ?? this.horaTermino,
      numeroCelular: numeroCelular ?? this.numeroCelular,
      formaPagamento: formaPagamento ?? this.formaPagamento,
      idFormaPagamento: idFormaPagamento ?? this.idFormaPagamento,
      quandoInscricaoNaoPaga: quandoInscricaoNaoPaga ?? this.quandoInscricaoNaoPaga,
      mensagemQuandoInscricaoNaoPaga: mensagemQuandoInscricaoNaoPaga ?? this.mensagemQuandoInscricaoNaoPaga,
      permVincularParceiro: permVincularParceiro ?? this.permVincularParceiro,
      pixVencido: pixVencido != null ? pixVencido() : this.pixVencido,
      provas: provas ?? this.provas,
      parceiros: parceiros ?? this.parceiros,
      idCabeceira: idCabeceira != null ? idCabeceira() : this.idCabeceira,
      reembolso: reembolso ?? this.reembolso,
    );
  }

  @override
  String toString() {
    return 'ComprasModelo(id: $id, valorIngresso: $valorIngresso, valorTaxa: $valorTaxa, valorDesconto: $valorDesconto, valorTotal: $valorTotal, valorFiliacao: $valorFiliacao, status: $status, codigoQr: $codigoQr, codigoPIX: $codigoPIX, idCliente: $idCliente, dataCompra: $dataCompra, horaCompra: $horaCompra, pago: $pago, nomeProva: $nomeProva, nomeEmpresa: $nomeEmpresa, idEvento: $idEvento, idEmpresa: $idEmpresa, nomeEvento: $nomeEvento, dataEvento: $dataEvento, horaInicio: $horaInicio, horaInicioF: $horaInicioF, parcelas: $parcelas, tipodevenda: $tipodevenda, horaTermino: $horaTermino, numeroCelular: $numeroCelular, formaPagamento: $formaPagamento, idFormaPagamento: $idFormaPagamento, quandoInscricaoNaoPaga: $quandoInscricaoNaoPaga, mensagemQuandoInscricaoNaoPaga: $mensagemQuandoInscricaoNaoPaga, permVincularParceiro: $permVincularParceiro, pixVencido: $pixVencido, provas: $provas, parceiros: $parceiros, idCabeceira: $idCabeceira, reembolso: $reembolso)';
  }
}
