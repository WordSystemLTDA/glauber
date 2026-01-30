// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competidores.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompetidoresModelo _$CompetidoresModeloFromJson(Map<String, dynamic> json) => CompetidoresModelo(
      id: json['id'] as String,
      nome: json['nome'] as String,
      apelido: json['apelido'] as String,
      nomeCidade: json['nomeCidade'] as String,
      siglaEstado: json['siglaEstado'] as String,
      ativo: json['ativo'] as String,
      idProva: json['idProva'] as String,
      jaExistente: json['jaExistente'] as bool?,
      idParceiroTrocado: json['idParceiroTrocado'] as String?,
      celular: json['celular'] as String?,
      hccabeceira: json['hccabeceira'] as String?,
      hcpezeiro: json['hcpezeiro'] as String?,
    );

Map<String, dynamic> _$CompetidoresModeloToJson(CompetidoresModelo instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'apelido': instance.apelido,
      'nomeCidade': instance.nomeCidade,
      'siglaEstado': instance.siglaEstado,
      'ativo': instance.ativo,
      'idProva': instance.idProva,
      'jaExistente': instance.jaExistente,
      'idParceiroTrocado': instance.idParceiroTrocado,
      'celular': instance.celular,
      'hccabeceira': instance.hccabeceira,
      'hcpezeiro': instance.hcpezeiro,
    };
