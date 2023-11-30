import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class VersoesModelo {
  String versaoAppAndroid;
  String versaoAppIos;
  String linkAtualizacaoAndroid;
  String linkAtualizacaoIos;

  VersoesModelo({
    required this.versaoAppAndroid,
    required this.versaoAppIos,
    required this.linkAtualizacaoAndroid,
    required this.linkAtualizacaoIos,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'versaoAppAndroid': versaoAppAndroid,
      'versaoAppIos': versaoAppIos,
      'linkAtualizacaoAndroid': linkAtualizacaoAndroid,
      'linkAtualizacaoIos': linkAtualizacaoIos,
    };
  }

  factory VersoesModelo.fromMap(Map<String, dynamic> map) {
    return VersoesModelo(
      versaoAppAndroid: map['versaoAppAndroid'] as String,
      versaoAppIos: map['versaoAppIos'] as String,
      linkAtualizacaoAndroid: map['linkAtualizacaoAndroid'] as String,
      linkAtualizacaoIos: map['linkAtualizacaoIos'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VersoesModelo.fromJson(String source) => VersoesModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
