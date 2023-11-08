import 'dart:convert';

class DadosProvasModelo {
  final String valor;

  DadosProvasModelo({required this.valor});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'valor': valor,
    };
  }

  factory DadosProvasModelo.fromMap(Map<String, dynamic> map) {
    return DadosProvasModelo(
      valor: map['valor'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DadosProvasModelo.fromJson(String source) => DadosProvasModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
