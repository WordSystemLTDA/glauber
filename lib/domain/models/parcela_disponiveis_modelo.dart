import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ParcelaDisponiveisModelo {
  int parcela;

  ParcelaDisponiveisModelo({
    required this.parcela,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'parcela': parcela,
    };
  }

  factory ParcelaDisponiveisModelo.fromMap(Map<String, dynamic> map) {
    return ParcelaDisponiveisModelo(
      parcela: map['parcela'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParcelaDisponiveisModelo.fromJson(String source) => ParcelaDisponiveisModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
