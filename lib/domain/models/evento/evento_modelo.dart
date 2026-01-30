// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/domain/models/modelo_banners_carrossel.dart';

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
  final String descricao1;
  final String descricao2;
  final String numero;
  final String bairro;
  final String complemento;
  final String longitude;
  final String latitude;
  final String nomeCidade;
  final String nomeEmpresa;
  final String liberacaoDeCompra;
  final List<ModeloBannersCarrossel> bannersCarrossel;

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
    required this.descricao1,
    required this.descricao2,
    required this.numero,
    required this.bairro,
    required this.complemento,
    required this.longitude,
    required this.latitude,
    required this.nomeCidade,
    required this.nomeEmpresa,
    required this.liberacaoDeCompra,
    required this.bannersCarrossel,
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
      'descricao1': descricao1,
      'descricao2': descricao2,
      'numero': numero,
      'bairro': bairro,
      'complemento': complemento,
      'longitude': longitude,
      'latitude': latitude,
      'nomeCidade': nomeCidade,
      'nomeEmpresa': nomeEmpresa,
      'liberacaoDeCompra': liberacaoDeCompra,
      'bannersCarrossel': bannersCarrossel.map((x) => x.toMap()).toList(),
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
      descricao1: map['descricao1'] as String,
      descricao2: map['descricao2'] as String,
      numero: map['numero'] as String,
      bairro: map['bairro'] as String,
      complemento: map['complemento'] as String,
      longitude: map['longitude'] as String,
      latitude: map['latitude'] as String,
      nomeCidade: map['nomeCidade'] as String,
      nomeEmpresa: map['nomeEmpresa'] as String,
      liberacaoDeCompra: map['liberacaoDeCompra'] as String,
      bannersCarrossel: List<ModeloBannersCarrossel>.from(
        (map['bannersCarrossel'] as List<dynamic>).map<ModeloBannersCarrossel>(
          (x) => ModeloBannersCarrossel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventoModelo.fromJson(String source) => EventoModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
