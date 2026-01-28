// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/domain/models/retorno_lista_compra_modelo.dart';

class RetornoComprasModelo {
  final List<RetornoListaCompraModelo> anteriores;
  final List<RetornoListaCompraModelo> atuais;
  final List<RetornoListaCompraModelo> canceladas;

  RetornoComprasModelo({required this.anteriores, required this.atuais, required this.canceladas});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'anteriores': anteriores.map((x) => x.toMap()).toList(),
      'atuais': atuais.map((x) => x.toMap()).toList(),
      'canceladas': canceladas.map((x) => x.toMap()).toList(),
    };
  }

  factory RetornoComprasModelo.fromMap(Map<String, dynamic> map) {
    return RetornoComprasModelo(
      anteriores: List<RetornoListaCompraModelo>.from(
        (map['anteriores'] as List<dynamic>).map<RetornoListaCompraModelo>(
          (x) => RetornoListaCompraModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      atuais: List<RetornoListaCompraModelo>.from(
        (map['atuais'] as List<dynamic>).map<RetornoListaCompraModelo>(
          (x) => RetornoListaCompraModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      canceladas: List<RetornoListaCompraModelo>.from(
        (map['canceladas'] as List<dynamic>).map<RetornoListaCompraModelo>(
          (x) => RetornoListaCompraModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RetornoComprasModelo.fromJson(String source) => RetornoComprasModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
