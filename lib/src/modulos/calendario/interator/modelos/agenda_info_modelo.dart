import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AgendaInfoModelo {
  String link;
  AgendaInfoModelo({
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'link': link,
    };
  }

  factory AgendaInfoModelo.fromMap(Map<String, dynamic> map) {
    return AgendaInfoModelo(
      link: map['link'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AgendaInfoModelo.fromJson(String source) => AgendaInfoModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
