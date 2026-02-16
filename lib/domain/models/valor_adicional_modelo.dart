import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ValorAdicionalModelo {
  final String titulo;
  final String valor;
  final String tipo;
  final String pago;

  ValorAdicionalModelo({
    required this.titulo,
    required this.valor,
    required this.tipo,
    required this.pago,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'valor': valor,
      'tipo': tipo,
      'pago': pago,
    };
  }

  factory ValorAdicionalModelo.fromMap(Map<String, dynamic> map) {
    return ValorAdicionalModelo(
      titulo: map['titulo'] ?? '',
      valor: map['valor'] ?? '',
      tipo: map['tipo'] ?? '',
      pago: map['pago'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ValorAdicionalModelo.fromJson(String source) => ValorAdicionalModelo.fromMap(json.decode(source));

  ValorAdicionalModelo copyWith({
    String? titulo,
    String? valor,
    String? tipo,
    String? pago,
  }) {
    return ValorAdicionalModelo(
      titulo: titulo ?? this.titulo,
      valor: valor ?? this.valor,
      tipo: tipo ?? this.tipo,
      pago: pago ?? this.pago,
    );
  }

  @override
  String toString() {
    return 'ValorAdicionalModelo(titulo: $titulo, valor: $valor, tipo: $tipo, pago: $pago)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ValorAdicionalModelo &&
      other.titulo == titulo &&
      other.valor == valor &&
      other.tipo == tipo &&
      other.pago == pago;
  }

  @override
  int get hashCode {
    return titulo.hashCode ^
      valor.hashCode ^
      tipo.hashCode ^
      pago.hashCode;
  }
}
