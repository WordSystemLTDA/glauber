// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permitir_compra_modelo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermitirCompraModelo _$PermitirCompraModeloFromJson(Map<String, dynamic> json) => PermitirCompraModelo(
      liberado: json['liberado'] as bool,
      mensagem: json['mensagem'] as String,
      rota: json['rota'] as String?,
      tituloAcao: json['tituloAcao'] as String?,
      quantMaximaAvulsa: json['quantMaximaAvulsa'] as String?,
      quantParceiros: json['quantParceiros'] as String?,
      permVincularParceiro: json['permVincularParceiro'] as String?,
      competidoresJaSelecionados: (json['competidoresJaSelecionados'] as List<dynamic>?)?.map((e) => CompetidoresModelo2.fromJson(e as Map<String, dynamic>)).toList(),
      idCabeceiraInvalido: json['idCabeceiraInvalido'] as String?,
    );

Map<String, dynamic> _$PermitirCompraModeloToJson(PermitirCompraModelo instance) => <String, dynamic>{
      'liberado': instance.liberado,
      'mensagem': instance.mensagem,
      'rota': instance.rota,
      'tituloAcao': instance.tituloAcao,
      'quantMaximaAvulsa': instance.quantMaximaAvulsa,
      'quantParceiros': instance.quantParceiros,
      'permVincularParceiro': instance.permVincularParceiro,
      'competidoresJaSelecionados': instance.competidoresJaSelecionados,
      'idCabeceiraInvalido': instance.idCabeceiraInvalido,
    };
