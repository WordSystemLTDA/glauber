// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/essencial/providers/config/config_modelo.dart';
import 'package:provadelaco/src/domain/models/categoria_modelo.dart';
import 'package:provadelaco/src/domain/models/evento_modelo.dart';
import 'package:provadelaco/src/domain/models/propaganda_modelo.dart';

class HomeModelo {
  final bool sucesso;
  final ConfigModelo dadosConfig;
  final List<EventoModelo> eventosTopo;
  final List<EventoModelo> eventos;
  final List<PropagandaModelo> propagandas;
  final List<CategoriaModelo> categorias;

  HomeModelo({
    required this.sucesso,
    required this.dadosConfig,
    required this.eventosTopo,
    required this.eventos,
    required this.propagandas,
    required this.categorias,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sucesso': sucesso,
      'eventosTopo': eventosTopo.map((x) => x.toMap()).toList(),
      'eventos': eventos.map((x) => x.toMap()).toList(),
      'propagandas': propagandas.map((x) => x.toMap()).toList(),
      'dadosConfig': dadosConfig.toMap(),
      'categorias': categorias.map((x) => x.toMap()).toList(),
    };
  }

  factory HomeModelo.fromMap(Map<String, dynamic> map) {
    return HomeModelo(
      sucesso: map['sucesso'] as bool,
      dadosConfig: ConfigModelo.fromMap(map['dadosConfig'] as Map<String, dynamic>),
      eventosTopo: List<EventoModelo>.from(
        (map['eventosTopo'] as List<dynamic>).map<EventoModelo>(
          (x) => EventoModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      eventos: List<EventoModelo>.from(
        (map['eventos'] as List<dynamic>).map<EventoModelo>(
          (x) => EventoModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      propagandas: List<PropagandaModelo>.from(
        (map['propagandas'] as List<dynamic>).map<PropagandaModelo>(
          (x) => PropagandaModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      categorias: List<CategoriaModelo>.from(
        (map['categorias'] as List<dynamic>).map<CategoriaModelo>(
          (x) => CategoriaModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeModelo.fromJson(String source) => HomeModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
