// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/parceiros_modelo.dart';

class OrdemDeEntradaModelo {
  final String id;
  final String idProva;
  final String nomeEvento;
  final String nomeProva;
  final String nomeCliente;

  final List<ParceirosModelos> parceiros;

  OrdemDeEntradaModelo({
    required this.id,
    required this.idProva,
    required this.nomeEvento,
    required this.nomeProva,
    required this.nomeCliente,
    required this.parceiros,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idProva': idProva,
      'nomeEvento': nomeEvento,
      'nomeProva': nomeProva,
      'nomeCliente': nomeCliente,
      'parceiros': parceiros.map((x) => x.toMap()).toList(),
    };
  }

  factory OrdemDeEntradaModelo.fromMap(Map<String, dynamic> map) {
    return OrdemDeEntradaModelo(
      id: map['id'] as String,
      idProva: map['idProva'] as String,
      nomeEvento: map['nomeEvento'] as String,
      nomeProva: map['nomeProva'] as String,
      nomeCliente: map['nomeCliente'] as String,
      parceiros: List<ParceirosModelos>.from(
        (map['parceiros'] as List<dynamic>).map<ParceirosModelos>(
          (x) => ParceirosModelos.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrdemDeEntradaModelo.fromJson(String source) => OrdemDeEntradaModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
