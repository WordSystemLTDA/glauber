// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PropagandaModelo {
  final String id;
  final String nome;
  final String foto;
  final String tipoServico;
  final String idEmpresa;
  final String nomeEmpresa;
  final String instagram;
  final String codigoVideo;
  final String celular;
  final String obs;

  PropagandaModelo({
    required this.id,
    required this.nome,
    required this.foto,
    required this.tipoServico,
    required this.idEmpresa,
    required this.nomeEmpresa,
    required this.instagram,
    required this.codigoVideo,
    required this.celular,
    required this.obs,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'foto': foto,
      'tipoServico': tipoServico,
      'idEmpresa': idEmpresa,
      'nomeEmpresa': nomeEmpresa,
      'instagram': instagram,
      'codigoVideo': codigoVideo,
      'celular': celular,
      'obs': obs,
    };
  }

  factory PropagandaModelo.fromMap(Map<String, dynamic> map) {
    return PropagandaModelo(
      id: map['id'] as String,
      nome: map['nome'] as String,
      foto: map['foto'] as String,
      tipoServico: map['tipoServico'] as String,
      idEmpresa: map['idEmpresa'] as String,
      nomeEmpresa: map['nomeEmpresa'] as String,
      instagram: map['instagram'] as String,
      codigoVideo: map['codigoVideo'] as String,
      celular: map['celular'] as String,
      obs: map['obs'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PropagandaModelo.fromJson(String source) => PropagandaModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
