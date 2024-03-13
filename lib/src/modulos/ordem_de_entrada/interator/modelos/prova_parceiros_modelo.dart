// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProvaParceirosModelos {
  final String id;
  final String somatoria;
  final String numeroDaInscricao;
  final String sorteio;
  final String boi1;
  final String boi2;
  final String boi3;
  final String boi4;
  final String finalT;
  final String medio;
  final String idClienteCabeceira;
  final String idClientePezeiro;
  final String nomeClienteCabeceira;
  final String nomeClientePezeiro;

  ProvaParceirosModelos({
    required this.id,
    required this.somatoria,
    required this.numeroDaInscricao,
    required this.sorteio,
    required this.boi1,
    required this.boi2,
    required this.boi3,
    required this.boi4,
    required this.finalT,
    required this.medio,
    required this.idClienteCabeceira,
    required this.idClientePezeiro,
    required this.nomeClienteCabeceira,
    required this.nomeClientePezeiro,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'somatoria': somatoria,
      'numeroDaInscricao': numeroDaInscricao,
      'sorteio': sorteio,
      'boi1': boi1,
      'boi2': boi2,
      'boi3': boi3,
      'boi4': boi4,
      'finalT': finalT,
      'medio': medio,
      'idClienteCabeceira': idClienteCabeceira,
      'idClientePezeiro': idClientePezeiro,
      'nomeClienteCabeceira': nomeClienteCabeceira,
      'nomeClientePezeiro': nomeClientePezeiro,
    };
  }

  factory ProvaParceirosModelos.fromMap(Map<String, dynamic> map) {
    return ProvaParceirosModelos(
      id: map['id'] as String,
      somatoria: map['somatoria'] as String,
      numeroDaInscricao: map['numeroDaInscricao'] as String,
      sorteio: map['sorteio'] as String,
      boi1: map['boi1'] as String,
      boi2: map['boi2'] as String,
      boi3: map['boi3'] as String,
      boi4: map['boi4'] as String,
      finalT: map['finalT'] as String,
      medio: map['medio'] as String,
      idClienteCabeceira: map['idClienteCabeceira'] as String,
      idClientePezeiro: map['idClientePezeiro'] as String,
      nomeClienteCabeceira: map['nomeClienteCabeceira'] as String,
      nomeClientePezeiro: map['nomeClientePezeiro'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvaParceirosModelos.fromJson(String source) => ProvaParceirosModelos.fromMap(json.decode(source) as Map<String, dynamic>);
}
