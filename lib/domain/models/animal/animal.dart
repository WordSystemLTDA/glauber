// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


part 'animal.g.dart';

class ModeloAnimal {
  final String id;
  final String nomedoanimal;
  final String datanascianimal;
  final String sexo;
  final String padrao;
  final String racadoanimal;
  final String foto;
  final bool soupropietario;

  ModeloAnimal({
    required this.id,
    required this.nomedoanimal,
    required this.datanascianimal,
    required this.sexo,
    required this.padrao,
    required this.racadoanimal,
    required this.foto,
    required this.soupropietario,
  });


  ModeloAnimal copyWith({
    String? id,
    String? nomedoanimal,
    String? datanascianimal,
    String? sexo,
    String? padrao,
    String? racadoanimal,
    String? foto,
    bool? soupropietario,
  }) {
    return ModeloAnimal(
      id: id ?? this.id,
      nomedoanimal: nomedoanimal ?? this.nomedoanimal,
      datanascianimal: datanascianimal ?? this.datanascianimal,
      sexo: sexo ?? this.sexo,
      padrao: padrao ?? this.padrao,
      racadoanimal: racadoanimal ?? this.racadoanimal,
      foto: foto ?? this.foto,
      soupropietario: soupropietario ?? this.soupropietario,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomedoanimal': nomedoanimal,
      'datanascianimal': datanascianimal,
      'sexo': sexo,
      'padrao': padrao,
      'racadoanimal': racadoanimal,
      'foto': foto,
      'soupropietario': soupropietario,
    };
  }

  factory ModeloAnimal.fromMap(Map<String, dynamic> map) {
    return ModeloAnimal(
      id: map['id'] ?? '',
      nomedoanimal: map['nomedoanimal'] ?? '',
      datanascianimal: map['datanascianimal'] ?? '',
      sexo: map['sexo'] ?? '',
      padrao: map['padrao'] ?? '',
      racadoanimal: map['racadoanimal'] ?? '',
      foto: map['foto'] ?? '',
      soupropietario: map['soupropietario'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeloAnimal.fromJson(String source) => ModeloAnimal.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ModeloAnimal(id: $id, nomedoanimal: $nomedoanimal, datanascianimal: $datanascianimal, sexo: $sexo, padrao: $padrao, racadoanimal: $racadoanimal, foto: $foto, soupropietario: $soupropietario)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ModeloAnimal &&
      other.id == id &&
      other.nomedoanimal == nomedoanimal &&
      other.datanascianimal == datanascianimal &&
      other.sexo == sexo &&
      other.padrao == padrao &&
      other.racadoanimal == racadoanimal &&
      other.foto == foto &&
      other.soupropietario == soupropietario;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nomedoanimal.hashCode ^
      datanascianimal.hashCode ^
      sexo.hashCode ^
      padrao.hashCode ^
      racadoanimal.hashCode ^
      foto.hashCode ^
      soupropietario.hashCode;
  }
}
