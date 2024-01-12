import 'dart:convert';

class AgendaModelo {
  final dynamic id;
  final dynamic startTime;
  final dynamic endTime;
  final dynamic color;
  final dynamic subject;
  final dynamic cliente;
  final dynamic medico;
  final dynamic valor;

  const AgendaModelo({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.subject,
    required this.cliente,
    required this.medico,
    required this.valor,
  });

  factory AgendaModelo.fromJson(String source) => AgendaModelo.fromMap(json.decode(source) as Map<String, dynamic>);

  factory AgendaModelo.fromMap(Map<String, dynamic> map) {
    return AgendaModelo(
      id: map['id'] as dynamic,
      startTime: map['startTime'] as dynamic,
      endTime: map['endTime'] as dynamic,
      color: map['color'] as dynamic,
      subject: map['subject'] as dynamic,
      cliente: map['cliente'] as dynamic,
      medico: map['medico'] as dynamic,
      valor: map['valor'] as dynamic,
    );
  }

  @override
  int get hashCode {
    return id.hashCode ^ startTime.hashCode ^ endTime.hashCode ^ color.hashCode ^ subject.hashCode ^ cliente.hashCode ^ medico.hashCode ^ valor.hashCode;
  }

  @override
  bool operator ==(covariant AgendaModelo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.color == color &&
        other.subject == subject &&
        other.cliente == cliente &&
        other.medico == medico &&
        other.valor == valor;
  }

  AgendaModelo copyWith({
    dynamic id,
    dynamic startTime,
    dynamic endTime,
    dynamic color,
    dynamic subject,
    dynamic cliente,
    dynamic medico,
    dynamic valor,
  }) {
    return AgendaModelo(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      subject: subject ?? this.subject,
      cliente: cliente ?? this.cliente,
      medico: medico ?? this.medico,
      valor: valor ?? this.valor,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'subject': subject,
      'cliente': cliente,
      'medico': medico,
      'valor': valor,
    };
  }

  @override
  String toString() {
    return 'AgendaModelo(id: $id, startTime: $startTime, endTime: $endTime, color: $color, subject: $subject, cliente: $cliente, medico: $medico, valor: $valor)';
  }
}
