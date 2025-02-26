// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modalidade_prova_modelo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModalidadeProvaModelo _$ModalidadeProvaModeloFromJson(
        Map<String, dynamic> json) =>
    ModalidadeProvaModelo(
      modalidade: json['modalidade'] as String,
      nomemodalidade: json['nomemodalidade'] as String,
      provas: (json['provas'] as List<dynamic>)
          .map((e) => ProvaModelo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModalidadeProvaModeloToJson(
        ModalidadeProvaModelo instance) =>
    <String, dynamic>{
      'modalidade': instance.modalidade,
      'nomemodalidade': instance.nomemodalidade,
      'provas': instance.provas,
    };
