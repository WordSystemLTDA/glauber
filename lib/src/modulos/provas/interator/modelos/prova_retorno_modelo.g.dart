// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_retorno_modelo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaRetornoModelo _$ProvaRetornoModeloFromJson(Map<String, dynamic> json) =>
    ProvaRetornoModelo(
      sucesso: json['sucesso'] as bool,
      provas: (json['provas'] as List<dynamic>)
          .map((e) => ModalidadeProvaModelo.fromJson(e as Map<String, dynamic>))
          .toList(),
      nomesCabeceira: (json['nomesCabeceira'] as List<dynamic>)
          .map((e) => NomesCabeceiraModelo.fromJson(e as String))
          .toList(),
      pagamentoDisponiveis: (json['pagamentoDisponiveis'] as List<dynamic>)
          .map((e) => PagamentosModelo.fromJson(e as String))
          .toList(),
      evento: EventoModelo.fromJson(json['evento'] as String),
    );

Map<String, dynamic> _$ProvaRetornoModeloToJson(ProvaRetornoModelo instance) =>
    <String, dynamic>{
      'sucesso': instance.sucesso,
      'provas': instance.provas,
      'nomesCabeceira': instance.nomesCabeceira,
      'evento': instance.evento,
      'pagamentoDisponiveis': instance.pagamentoDisponiveis,
    };
