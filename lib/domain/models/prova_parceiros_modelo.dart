// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProvaParceirosModelos {
  final String id;
  final String somatoria;
  final String numeroDaInscricao;
  final String sorteio;
  final String sorteiocabeceira;
  final String sorteiopezeiro;
  final String boi1;
  final String boi2;
  final String boi3;
  final String boi4;
  final String finalT;
  final String medio;
  final String ranking;
  final String classificacao;
  final String idClienteCabeceira;
  final String idClientePezeiro;
  final String nomeClienteCabeceira;
  final String nomeClientePezeiro;

  ProvaParceirosModelos({
    required this.id,
    required this.somatoria,
    required this.numeroDaInscricao,
    required this.sorteio,
    required this.sorteiocabeceira,
    required this.sorteiopezeiro,
    required this.boi1,
    required this.boi2,
    required this.boi3,
    required this.boi4,
    required this.finalT,
    required this.medio,
    required this.ranking,
    required this.classificacao,
    required this.idClienteCabeceira,
    required this.idClientePezeiro,
    required this.nomeClienteCabeceira,
    required this.nomeClientePezeiro,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'somatoria': somatoria,
      'numeroDaInscricao': numeroDaInscricao,
      'sorteio': sorteio,
      'sorteiocabeceira': sorteiocabeceira,
      'sorteiopezeiro': sorteiopezeiro,
      'boi1': boi1,
      'boi2': boi2,
      'boi3': boi3,
      'boi4': boi4,
      'finalT': finalT,
      'medio': medio,
      'ranking': ranking,
      'classificacao': classificacao,
      'idClienteCabeceira': idClienteCabeceira,
      'idClientePezeiro': idClientePezeiro,
      'nomeClienteCabeceira': nomeClienteCabeceira,
      'nomeClientePezeiro': nomeClientePezeiro,
    };
  }

  factory ProvaParceirosModelos.fromMap(Map<String, dynamic> map) {
    return ProvaParceirosModelos(
      id: map['id'] ?? '',
      somatoria: map['somatoria'] ?? '',
      numeroDaInscricao: map['numeroDaInscricao'] ?? '',
      sorteio: map['sorteio'] ?? '',
      sorteiocabeceira: map['sorteiocabeceira'] ?? '',
      sorteiopezeiro: map['sorteiopezeiro'] ?? '',
      boi1: map['boi1'] ?? '',
      boi2: map['boi2'] ?? '',
      boi3: map['boi3'] ?? '',
      boi4: map['boi4'] ?? '',
      finalT: map['finalT'] ?? '',
      medio: map['medio'] ?? '',
      ranking: map['ranking'] ?? '',
      classificacao: map['classificacao'] ?? '',
      idClienteCabeceira: map['idClienteCabeceira'] ?? '',
      idClientePezeiro: map['idClientePezeiro'] ?? '',
      nomeClienteCabeceira: map['nomeClienteCabeceira'] ?? '',
      nomeClientePezeiro: map['nomeClientePezeiro'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvaParceirosModelos.fromJson(String source) => ProvaParceirosModelos.fromMap(json.decode(source));

  ProvaParceirosModelos copyWith({
    String? id,
    String? somatoria,
    String? numeroDaInscricao,
    String? sorteio,
    String? sorteiocabeceira,
    String? sorteiopezeiro,
    String? boi1,
    String? boi2,
    String? boi3,
    String? boi4,
    String? finalT,
    String? medio,
    String? ranking,
    String? classificacao,
    String? idClienteCabeceira,
    String? idClientePezeiro,
    String? nomeClienteCabeceira,
    String? nomeClientePezeiro,
  }) {
    return ProvaParceirosModelos(
      id: id ?? this.id,
      somatoria: somatoria ?? this.somatoria,
      numeroDaInscricao: numeroDaInscricao ?? this.numeroDaInscricao,
      sorteio: sorteio ?? this.sorteio,
      sorteiocabeceira: sorteiocabeceira ?? this.sorteiocabeceira,
      sorteiopezeiro: sorteiopezeiro ?? this.sorteiopezeiro,
      boi1: boi1 ?? this.boi1,
      boi2: boi2 ?? this.boi2,
      boi3: boi3 ?? this.boi3,
      boi4: boi4 ?? this.boi4,
      finalT: finalT ?? this.finalT,
      medio: medio ?? this.medio,
      ranking: ranking ?? this.ranking,
      classificacao: classificacao ?? this.classificacao,
      idClienteCabeceira: idClienteCabeceira ?? this.idClienteCabeceira,
      idClientePezeiro: idClientePezeiro ?? this.idClientePezeiro,
      nomeClienteCabeceira: nomeClienteCabeceira ?? this.nomeClienteCabeceira,
      nomeClientePezeiro: nomeClientePezeiro ?? this.nomeClientePezeiro,
    );
  }

  @override
  String toString() {
    return 'ProvaParceirosModelos(id: $id, somatoria: $somatoria, numeroDaInscricao: $numeroDaInscricao, sorteio: $sorteio, sorteiocabeceira: $sorteiocabeceira, sorteiopezeiro: $sorteiopezeiro, boi1: $boi1, boi2: $boi2, boi3: $boi3, boi4: $boi4, finalT: $finalT, medio: $medio, ranking: $ranking, classificacao: $classificacao, idClienteCabeceira: $idClienteCabeceira, idClientePezeiro: $idClientePezeiro, nomeClienteCabeceira: $nomeClienteCabeceira, nomeClientePezeiro: $nomeClientePezeiro)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProvaParceirosModelos &&
        other.id == id &&
        other.somatoria == somatoria &&
        other.numeroDaInscricao == numeroDaInscricao &&
        other.sorteio == sorteio &&
        other.sorteiocabeceira == sorteiocabeceira &&
        other.sorteiopezeiro == sorteiopezeiro &&
        other.boi1 == boi1 &&
        other.boi2 == boi2 &&
        other.boi3 == boi3 &&
        other.boi4 == boi4 &&
        other.finalT == finalT &&
        other.medio == medio &&
        other.ranking == ranking &&
        other.classificacao == classificacao &&
        other.idClienteCabeceira == idClienteCabeceira &&
        other.idClientePezeiro == idClientePezeiro &&
        other.nomeClienteCabeceira == nomeClienteCabeceira &&
        other.nomeClientePezeiro == nomeClientePezeiro;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        somatoria.hashCode ^
        numeroDaInscricao.hashCode ^
        sorteio.hashCode ^
        sorteiocabeceira.hashCode ^
        sorteiopezeiro.hashCode ^
        boi1.hashCode ^
        boi2.hashCode ^
        boi3.hashCode ^
        boi4.hashCode ^
        finalT.hashCode ^
        medio.hashCode ^
        ranking.hashCode ^
        classificacao.hashCode ^
        idClienteCabeceira.hashCode ^
        idClientePezeiro.hashCode ^
        nomeClienteCabeceira.hashCode ^
        nomeClientePezeiro.hashCode;
  }
}
