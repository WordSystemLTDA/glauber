// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/dados_provas_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/pagamentos_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/parcela_disponiveis_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/valor_adicional_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';

class ListarInformacoesModelo {
  final DadosProvasModelo prova;
  final EventoModelo evento;
  final String taxaCartao;
  final List<ParcelaDisponiveisModelo> parcelasDisponiveisCartao;
  final List<PagamentosModelo> pagamentos;
  final ValorAdicionalModelo? valorAdicional;
  final String? valorDescontoPorProva;
  final String ativoPagamento;
  final String pagamentoPix;
  final String tempoCancel;

  ListarInformacoesModelo({
    required this.prova,
    required this.evento,
    required this.taxaCartao,
    required this.parcelasDisponiveisCartao,
    required this.pagamentos,
    this.valorAdicional,
    this.valorDescontoPorProva,
    required this.ativoPagamento,
    required this.pagamentoPix,
    required this.tempoCancel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prova': prova.toMap(),
      'evento': evento.toMap(),
      'taxaCartao': taxaCartao,
      'parcelasDisponiveisCartao': parcelasDisponiveisCartao.map((x) => x.toMap()).toList(),
      'pagamentos': pagamentos.map((x) => x.toMap()).toList(),
      'valorAdicional': valorAdicional?.toMap(),
      'valorDescontoPorProva': valorDescontoPorProva,
      'ativoPagamento': ativoPagamento,
      'pagamentoPix': pagamentoPix,
      'tempoCancel': tempoCancel,
    };
  }

  factory ListarInformacoesModelo.fromMap(Map<String, dynamic> map) {
    return ListarInformacoesModelo(
      prova: DadosProvasModelo.fromMap(map['prova'] as Map<String, dynamic>),
      evento: EventoModelo.fromMap(map['evento'] as Map<String, dynamic>),
      taxaCartao: map['taxaCartao'] as String,
      parcelasDisponiveisCartao: List<ParcelaDisponiveisModelo>.from(
        (map['parcelasDisponiveisCartao'] as List<dynamic>).map<ParcelaDisponiveisModelo>(
          (x) => ParcelaDisponiveisModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      pagamentos: List<PagamentosModelo>.from(
        (map['pagamentos'] as List<dynamic>).map<PagamentosModelo>(
          (x) => PagamentosModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      valorAdicional: map['valorAdicional'] != null ? ValorAdicionalModelo.fromMap(map['valorAdicional'] as Map<String, dynamic>) : null,
      valorDescontoPorProva: map['valorDescontoPorProva'] != null ? map['valorDescontoPorProva'] as String : null,
      ativoPagamento: map['ativoPagamento'] as String,
      pagamentoPix: map['pagamentoPix'] as String,
      tempoCancel: map['tempoCancel'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListarInformacoesModelo.fromJson(String source) => ListarInformacoesModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
