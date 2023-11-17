// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EventoModelo {
  final String id;
  final String idEmpresa;
  final String nomeEvento;
  final String dataEvento;
  final String horaInicio;
  final String horaTermino;
  final String foto;
  final String cep;
  final String endereco;
  final String numero;
  final String bairro;
  final String complemento;
  final String nomeCidade;
  final String nomeEmpresa;
  final String liberacaoDeCompra;

  EventoModelo({
    required this.id,
    required this.idEmpresa,
    required this.nomeEvento,
    required this.dataEvento,
    required this.horaInicio,
    required this.horaTermino,
    required this.foto,
    required this.cep,
    required this.endereco,
    required this.numero,
    required this.bairro,
    required this.complemento,
    required this.nomeCidade,
    required this.nomeEmpresa,
    required this.liberacaoDeCompra,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idEmpresa': idEmpresa,
      'nomeEvento': nomeEvento,
      'dataEvento': dataEvento,
      'horaInicio': horaInicio,
      'horaTermino': horaTermino,
      'foto': foto,
      'cep': cep,
      'endereco': endereco,
      'numero': numero,
      'bairro': bairro,
      'complemento': complemento,
      'nomeCidade': nomeCidade,
      'nomeEmpresa': nomeEmpresa,
      'liberacaoDeCompra': liberacaoDeCompra,
    };
  }

  factory EventoModelo.fromMap(Map<String, dynamic> map) {
    return EventoModelo(
      id: map['id'] as String,
      idEmpresa: map['idEmpresa'] as String,
      nomeEvento: map['nomeEvento'] as String,
      dataEvento: map['dataEvento'] as String,
      horaInicio: map['horaInicio'] as String,
      horaTermino: map['horaTermino'] as String,
      foto: map['foto'] as String,
      cep: map['cep'] as String,
      endereco: map['endereco'] as String,
      numero: map['numero'] as String,
      bairro: map['bairro'] as String,
      complemento: map['complemento'] as String,
      nomeCidade: map['nomeCidade'] as String,
      nomeEmpresa: map['nomeEmpresa'] as String,
      liberacaoDeCompra: map['liberacaoDeCompra'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventoModelo.fromJson(String source) => EventoModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
