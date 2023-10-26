// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EventoModelo {
  final String id;
  final String nomeEvento;
  final String dataEvento;
  final String horaInicio;
  final String horaTermino;
  final String foto;

  EventoModelo({required this.id, required this.nomeEvento, required this.dataEvento, required this.horaInicio, required this.horaTermino, required this.foto});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomeEvento': nomeEvento,
      'dataEvento': dataEvento,
      'horaInicio': horaInicio,
      'horaTermino': horaTermino,
      'foto': foto,
    };
  }

  factory EventoModelo.fromMap(Map<String, dynamic> map) {
    return EventoModelo(
      id: map['id'] as String,
      nomeEvento: map['nomeEvento'] as String,
      dataEvento: map['dataEvento'] as String,
      horaInicio: map['horaInicio'] as String,
      horaTermino: map['horaTermino'] as String,
      foto: map['foto'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventoModelo.fromJson(String source) => EventoModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
