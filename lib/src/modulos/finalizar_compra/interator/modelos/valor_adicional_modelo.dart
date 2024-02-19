import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ValorAdicionalModelo {
  final String titulo;
  final String valor;
  final String tipo;

  ValorAdicionalModelo({
    required this.titulo,
    required this.valor,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'titulo': titulo,
      'valor': valor,
      'tipo': tipo,
    };
  }

  factory ValorAdicionalModelo.fromMap(Map<String, dynamic> map) {
    return ValorAdicionalModelo(
      titulo: map['titulo'] as String,
      valor: map['valor'] as String,
      tipo: map['tipo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ValorAdicionalModelo.fromJson(String source) => ValorAdicionalModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
