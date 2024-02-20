// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';

class RetornoListaCompraModelo {
  final String id;
  final String nomeProva;
  final String nomeEvento;
  final List<ComprasModelo> compras;

  RetornoListaCompraModelo({
    required this.id,
    required this.nomeProva,
    required this.nomeEvento,
    required this.compras,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomeProva': nomeProva,
      'nomeEvento': nomeEvento,
      'compras': compras.map((x) => x.toMap()).toList(),
    };
  }

  factory RetornoListaCompraModelo.fromMap(Map<String, dynamic> map) {
    return RetornoListaCompraModelo(
      id: map['id'] as String,
      nomeProva: map['nomeProva'] as String,
      nomeEvento: map['nomeEvento'] as String,
      compras: List<ComprasModelo>.from(
        (map['compras'] as List<dynamic>).map<ComprasModelo>(
          (x) => ComprasModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RetornoListaCompraModelo.fromJson(String source) => RetornoListaCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
