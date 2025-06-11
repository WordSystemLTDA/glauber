import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RetornoConfirmarParceirosModelo {
  final List<ConfirmarParceirosModelo> lacarpe;
  final List<ConfirmarParceirosModelo> lacarcabeca;

  RetornoConfirmarParceirosModelo({
    required this.lacarpe,
    required this.lacarcabeca,
  });

  Map<String, dynamic> toMap() {
    return {
      'lacarpe': lacarpe.map((x) => x.toMap()).toList(),
      'lacarcabeca': lacarcabeca.map((x) => x.toMap()).toList(),
    };
  }

  factory RetornoConfirmarParceirosModelo.fromMap(Map<String, dynamic> map) {
    return RetornoConfirmarParceirosModelo(
      lacarpe: List<ConfirmarParceirosModelo>.from(map['lacarpe']?.map((x) => ConfirmarParceirosModelo.fromMap(x))),
      lacarcabeca: List<ConfirmarParceirosModelo>.from(map['lacarcabeca']?.map((x) => ConfirmarParceirosModelo.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory RetornoConfirmarParceirosModelo.fromJson(String source) => RetornoConfirmarParceirosModelo.fromMap(json.decode(source));
}

class ConfirmarParceirosModelo {
  final String id;
  final String nomeprova;
  final List<ParceirosModelo> parceiros;

  ConfirmarParceirosModelo({
    required this.id,
    required this.nomeprova,
    required this.parceiros,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeprova': nomeprova,
      'parceiros': parceiros.map((x) => x.toMap()).toList(),
    };
  }

  factory ConfirmarParceirosModelo.fromMap(Map<String, dynamic> map) {
    return ConfirmarParceirosModelo(
      id: map['id'] ?? '',
      nomeprova: map['nomeprova'] ?? '',
      parceiros: List<ParceirosModelo>.from(map['parceiros']?.map((x) => ParceirosModelo.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfirmarParceirosModelo.fromJson(String source) => ConfirmarParceirosModelo.fromMap(json.decode(source));
}

class ParceirosModelo {
  final String id;
  final String idvendasparceiro;
  final String idparceiro;
  final String datacadastro;
  final String horacadastro;
  final String status;
  final String modalidade;
  final String nomeparceiro;
  final String apelidoparceiro;
  final String nomecidade;
  final String hccabeceira;
  final String hcpezeiro;

  ParceirosModelo({
    required this.id,
    required this.idvendasparceiro,
    required this.idparceiro,
    required this.datacadastro,
    required this.horacadastro,
    required this.status,
    required this.modalidade,
    required this.nomeparceiro,
    required this.apelidoparceiro,
    required this.nomecidade,
    required this.hccabeceira,
    required this.hcpezeiro,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idvendasparceiro': idvendasparceiro,
      'idparceiro': idparceiro,
      'datacadastro': datacadastro,
      'horacadastro': horacadastro,
      'status': status,
      'modalidade': modalidade,
      'nomeparceiro': nomeparceiro,
      'apelidoparceiro': apelidoparceiro,
      'nomecidade': nomecidade,
      'hccabeceira': hccabeceira,
      'hcpezeiro': hcpezeiro,
    };
  }

  factory ParceirosModelo.fromMap(Map<String, dynamic> map) {
    return ParceirosModelo(
      id: map['id'] as String,
      idvendasparceiro: map['idvendasparceiro'] as String,
      idparceiro: map['idparceiro'] as String,
      datacadastro: map['datacadastro'] as String,
      horacadastro: map['horacadastro'] as String,
      status: map['status'] as String,
      modalidade: map['modalidade'] as String,
      nomeparceiro: map['nomeparceiro'] as String,
      apelidoparceiro: map['apelidoparceiro'] as String,
      nomecidade: map['nomecidade'] as String,
      hccabeceira: map['hccabeceira'] as String,
      hcpezeiro: map['hcpezeiro'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParceirosModelo.fromJson(String source) => ParceirosModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
