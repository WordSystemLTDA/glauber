import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AgendaInfoModelo {
  String link;
  String tituloNotificacao;
  String corpoNotificacao;
  String erroAgendarNotificacao;
  String tituloAgendarNotificacao;
  String tituloAbrirLink;

  AgendaInfoModelo({
    required this.link,
    required this.tituloNotificacao,
    required this.corpoNotificacao,
    required this.erroAgendarNotificacao,
    required this.tituloAgendarNotificacao,
    required this.tituloAbrirLink,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'link': link,
      'tituloNotificacao': tituloNotificacao,
      'corpoNotificacao': corpoNotificacao,
      'erroAgendarNotificacao': erroAgendarNotificacao,
      'tituloAgendarNotificacao': tituloAgendarNotificacao,
      'tituloAbrirLink': tituloAbrirLink,
    };
  }

  factory AgendaInfoModelo.fromMap(Map<String, dynamic> map) {
    return AgendaInfoModelo(
      link: map['link'] as String,
      tituloNotificacao: map['tituloNotificacao'] as String,
      corpoNotificacao: map['corpoNotificacao'] as String,
      erroAgendarNotificacao: map['erroAgendarNotificacao'] as String,
      tituloAgendarNotificacao: map['tituloAgendarNotificacao'] as String,
      tituloAbrirLink: map['tituloAbrirLink'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AgendaInfoModelo.fromJson(String source) => AgendaInfoModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
