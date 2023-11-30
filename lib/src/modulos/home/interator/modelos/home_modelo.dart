// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/essencial/providers/versoes/versoes_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/categoria_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';

class HomeModelo {
  final bool sucesso;
  final List<EventoModelo> eventos;
  final List<EventoModelo> propagandas;
  final VersoesModelo versoes;
  final List<CategoriaModelo> categorias;

  HomeModelo({
    required this.sucesso,
    required this.eventos,
    required this.propagandas,
    required this.versoes,
    required this.categorias,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sucesso': sucesso,
      'eventos': eventos.map((x) => x.toMap()).toList(),
      'propagandas': propagandas.map((x) => x.toMap()).toList(),
      'versoes': versoes.toMap(),
      'categorias': categorias.map((x) => x.toMap()).toList(),
    };
  }

  factory HomeModelo.fromMap(Map<String, dynamic> map) {
    return HomeModelo(
      sucesso: map['sucesso'] as bool,
      eventos: List<EventoModelo>.from(
        (map['eventos'] as List<dynamic>).map<EventoModelo>(
          (x) => EventoModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      propagandas: List<EventoModelo>.from(
        (map['propagandas'] as List<dynamic>).map<EventoModelo>(
          (x) => EventoModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      versoes: VersoesModelo.fromMap(map['versoes'] as Map<String, dynamic>),
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
