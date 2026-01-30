// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competidores_modelo2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompetidoresModelo2 _$CompetidoresModelo2FromJson(Map<String, dynamic> json) => CompetidoresModelo2(
      id: json['id'] as String,
      nome: json['nome'] as String,
      apelido: json['apelido'] as String,
      nomeCidade: json['nomeCidade'] as String,
      siglaEstado: json['siglaEstado'] as String,
      ativo: json['ativo'] as String,
      jaExistente: json['jaExistente'] as bool,
      idParceiroTrocado: json['idParceiroTrocado'] as String,
    );

Map<String, dynamic> _$CompetidoresModelo2ToJson(CompetidoresModelo2 instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'apelido': instance.apelido,
      'nomeCidade': instance.nomeCidade,
      'siglaEstado': instance.siglaEstado,
      'ativo': instance.ativo,
      'jaExistente': instance.jaExistente,
      'idParceiroTrocado': instance.idParceiroTrocado,
    };
