// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_modelo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaModelo _$ProvaModeloFromJson(Map<String, dynamic> json) => ProvaModelo(
      id: json['id'] as String,
      nomeProva: json['nomeProva'] as String,
      valor: json['valor'] as String,
      hcMinimo: json['hcMinimo'] as String,
      hcMaximo: json['hcMaximo'] as String,
      avulsa: json['avulsa'] as String,
      quantMinima: json['quantMinima'] as String,
      quantMaxima: json['quantMaxima'] as String,
      permitirCompra: PermitirCompraModelo.fromJson(
          json['permitirCompra'] as Map<String, dynamic>),
      permitirSorteio: json['permitirSorteio'] as String,
      habilitarAoVivo: json['habilitarAoVivo'] as String,
      idListaCompeticao: json['idListaCompeticao'] as String,
      liberarReembolso: json['liberarReembolso'] as String? ?? 'Não',
      descricao: json['descricao'] as String?,
      somatoriaHandicaps: json['somatoriaHandicaps'] as String?,
      sorteio: json['sorteio'] as bool?,
      permitirEditarParceiros: json['permitirEditarParceiros'] as String,
      animalSelecionado: json['animalSelecionado'] == null
          ? null
          : ModeloAnimal.fromJson(
              json['animalSelecionado'] as Map<String, dynamic>),
      nomeCabeceira: json['nomeCabeceira'] as String?,
      idCabeceira: json['idCabeceira'] as String?,
      competidores: (json['competidores'] as List<dynamic>?)
          ?.map((e) => CompetidoresModelo.fromJson(e as String))
          .toList(),
      idmodalidade: json['idmodalidade'] as String?,
    );

Map<String, dynamic> _$ProvaModeloToJson(ProvaModelo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nomeProva': instance.nomeProva,
      'valor': instance.valor,
      'hcMinimo': instance.hcMinimo,
      'hcMaximo': instance.hcMaximo,
      'avulsa': instance.avulsa,
      'quantMinima': instance.quantMinima,
      'quantMaxima': instance.quantMaxima,
      'permitirCompra': instance.permitirCompra,
      'permitirSorteio': instance.permitirSorteio,
      'habilitarAoVivo': instance.habilitarAoVivo,
      'idListaCompeticao': instance.idListaCompeticao,
      'liberarReembolso': instance.liberarReembolso,
      'descricao': instance.descricao,
      'somatoriaHandicaps': instance.somatoriaHandicaps,
      'sorteio': instance.sorteio,
      'permitirEditarParceiros': instance.permitirEditarParceiros,
      'animalSelecionado': instance.animalSelecionado,
      'nomeCabeceira': instance.nomeCabeceira,
      'idCabeceira': instance.idCabeceira,
      'competidores': instance.competidores,
      'idmodalidade': instance.idmodalidade,
    };
