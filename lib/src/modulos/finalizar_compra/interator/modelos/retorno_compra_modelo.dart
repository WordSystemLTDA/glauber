// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RetornoCompraModelo {
  final bool sucesso;
  final String mensagem;
  final DadosRetornoCompraModelo dados;

  RetornoCompraModelo({required this.sucesso, required this.mensagem, required this.dados});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sucesso': sucesso,
      'mensagem': mensagem,
      'dados': dados.toMap(),
    };
  }

  factory RetornoCompraModelo.fromMap(Map<String, dynamic> map) {
    return RetornoCompraModelo(
      sucesso: map['sucesso'] as bool,
      mensagem: map['mensagem'] as String,
      dados: DadosRetornoCompraModelo.fromMap(map['dados'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory RetornoCompraModelo.fromJson(String source) => RetornoCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}

class DadosRetornoCompraModelo {
  final String txid;
  final String codigoPix;
  final String idProva;
  final String idEmpresa;
  final String idCompra;

  DadosRetornoCompraModelo({required this.txid, required this.codigoPix, required this.idProva, required this.idEmpresa, required this.idCompra});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'txid': txid,
      'codigoPix': codigoPix,
      'idProva': idProva,
      'idEmpresa': idEmpresa,
      'idCompra': idCompra,
    };
  }

  factory DadosRetornoCompraModelo.fromMap(Map<String, dynamic> map) {
    return DadosRetornoCompraModelo(
      txid: map['txid'] as String,
      codigoPix: map['codigoPix'] as String,
      idProva: map['idProva'] as String,
      idEmpresa: map['idEmpresa'] as String,
      idCompra: map['idCompra'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DadosRetornoCompraModelo.fromJson(String source) => DadosRetornoCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
