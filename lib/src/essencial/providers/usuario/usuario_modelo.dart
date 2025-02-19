// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UsuarioModelo {
  String? id;
  String? email;
  String? tipoDePix;
  String? chavePix;
  String? senha;
  String? nome;
  String? token;
  String? hcCabeceira;
  String? hcPezeiro;
  String? idHcCabeceira;
  String? idHcPezeiro;
  String? tipo;
  String? primeiroAcesso;
  String? cpf;
  String? dataNascimento;
  String? sexo;
  String? rg;
  String? telefone;
  String? celular;
  String? cep;
  String? endereco;
  String? numero;
  String? bairro;
  String? complemento;
  String? foto;
  String? civil;
  String? apelido;
  String? nomeCidade;
  String? idCidade;
  bool? clienteBloqueado;
  String? celularSuporte;
  String? nivel;
  String? somaDeHandicaps;
  String? atualizacaoAndroid;
  String? atualizacaoIos;
  String? cabeceiroProvas;
  String? pezeiroProvas;
  String? ativoProva;
  String? lacoemdupla;
  String? tambores3;
  String? lacoindividual;
  String? tipodecategoriaprofissional;
  String? handicaplacoindividual;
  String? idhandicaplacoindividual;

  UsuarioModelo({
    required this.id,
    required this.email,
    required this.tipoDePix,
    required this.chavePix,
    required this.senha,
    required this.nome,
    required this.token,
    required this.hcCabeceira,
    required this.hcPezeiro,
    required this.idHcCabeceira,
    required this.idHcPezeiro,
    required this.tipo,
    required this.primeiroAcesso,
    required this.cpf,
    required this.dataNascimento,
    required this.sexo,
    required this.rg,
    required this.telefone,
    required this.celular,
    required this.cep,
    required this.endereco,
    required this.numero,
    required this.bairro,
    required this.complemento,
    required this.foto,
    required this.civil,
    required this.apelido,
    required this.nomeCidade,
    required this.idCidade,
    required this.clienteBloqueado,
    required this.celularSuporte,
    required this.nivel,
    required this.somaDeHandicaps,
    required this.atualizacaoAndroid,
    required this.atualizacaoIos,
    required this.cabeceiroProvas,
    required this.pezeiroProvas,
    required this.ativoProva,
    this.lacoemdupla,
    this.tambores3,
    this.lacoindividual,
    this.tipodecategoriaprofissional,
    this.handicaplacoindividual,
    this.idhandicaplacoindividual,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'tipoDePix': tipoDePix,
      'chavePix': chavePix,
      'senha': senha,
      'nome': nome,
      'token': token,
      'hcCabeceira': hcCabeceira,
      'hcPezeiro': hcPezeiro,
      'idHcCabeceira': idHcCabeceira,
      'idHcPezeiro': idHcPezeiro,
      'tipo': tipo,
      'primeiroAcesso': primeiroAcesso,
      'cpf': cpf,
      'dataNascimento': dataNascimento,
      'sexo': sexo,
      'rg': rg,
      'telefone': telefone,
      'celular': celular,
      'cep': cep,
      'endereco': endereco,
      'numero': numero,
      'bairro': bairro,
      'complemento': complemento,
      'foto': foto,
      'civil': civil,
      'apelido': apelido,
      'nomeCidade': nomeCidade,
      'idCidade': idCidade,
      'clienteBloqueado': clienteBloqueado,
      'celularSuporte': celularSuporte,
      'nivel': nivel,
      'somaDeHandicaps': somaDeHandicaps,
      'atualizacaoAndroid': atualizacaoAndroid,
      'atualizacaoIos': atualizacaoIos,
      'cabeceiroProvas': cabeceiroProvas,
      'pezeiroProvas': pezeiroProvas,
      'ativoProva': ativoProva,
      'lacoemdupla': lacoemdupla,
      'tambores3': tambores3,
      'lacoindividual': lacoindividual,
      'tipodecategoriaprofissional': tipodecategoriaprofissional,
      'handicaplacoindividual': handicaplacoindividual,
      'idhandicaplacoindividual': idhandicaplacoindividual,
    };
  }

  factory UsuarioModelo.fromMap(Map<String, dynamic> map) {
    return UsuarioModelo(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      tipoDePix: map['tipoDePix'] != null ? map['tipoDePix'] as String : null,
      chavePix: map['chavePix'] != null ? map['chavePix'] as String : null,
      senha: map['senha'] != null ? map['senha'] as String : null,
      nome: map['nome'] != null ? map['nome'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      hcCabeceira: map['hcCabeceira'] != null ? map['hcCabeceira'] as String : null,
      hcPezeiro: map['hcPezeiro'] != null ? map['hcPezeiro'] as String : null,
      idHcCabeceira: map['idHcCabeceira'] != null ? map['idHcCabeceira'] as String : null,
      idHcPezeiro: map['idHcPezeiro'] != null ? map['idHcPezeiro'] as String : null,
      tipo: map['tipo'] != null ? map['tipo'] as String : null,
      primeiroAcesso: map['primeiroAcesso'] != null ? map['primeiroAcesso'] as String : null,
      cpf: map['cpf'] != null ? map['cpf'] as String : null,
      dataNascimento: map['dataNascimento'] != null ? map['dataNascimento'] as String : null,
      sexo: map['sexo'] != null ? map['sexo'] as String : null,
      rg: map['rg'] != null ? map['rg'] as String : null,
      telefone: map['telefone'] != null ? map['telefone'] as String : null,
      celular: map['celular'] != null ? map['celular'] as String : null,
      cep: map['cep'] != null ? map['cep'] as String : null,
      endereco: map['endereco'] != null ? map['endereco'] as String : null,
      numero: map['numero'] != null ? map['numero'] as String : null,
      bairro: map['bairro'] != null ? map['bairro'] as String : null,
      complemento: map['complemento'] != null ? map['complemento'] as String : null,
      foto: map['foto'] != null ? map['foto'] as String : null,
      civil: map['civil'] != null ? map['civil'] as String : null,
      apelido: map['apelido'] != null ? map['apelido'] as String : null,
      nomeCidade: map['nomeCidade'] != null ? map['nomeCidade'] as String : null,
      idCidade: map['idCidade'] != null ? map['idCidade'] as String : null,
      clienteBloqueado: map['clienteBloqueado'] != null ? map['clienteBloqueado'] as bool : null,
      celularSuporte: map['celularSuporte'] != null ? map['celularSuporte'] as String : null,
      nivel: map['nivel'] != null ? map['nivel'] as String : null,
      somaDeHandicaps: map['somaDeHandicaps'] != null ? map['somaDeHandicaps'] as String : null,
      atualizacaoAndroid: map['atualizacaoAndroid'] != null ? map['atualizacaoAndroid'] as String : null,
      atualizacaoIos: map['atualizacaoIos'] != null ? map['atualizacaoIos'] as String : null,
      cabeceiroProvas: map['cabeceiroProvas'] != null ? map['cabeceiroProvas'] as String : null,
      pezeiroProvas: map['pezeiroProvas'] != null ? map['pezeiroProvas'] as String : null,
      ativoProva: map['ativoProva'] != null ? map['ativoProva'] as String : null,
      lacoemdupla: map['lacoemdupla'] != null ? map['lacoemdupla'] as String : null,
      tambores3: map['tambores3'] != null ? map['tambores3'] as String : null,
      lacoindividual: map['lacoindividual'] != null ? map['lacoindividual'] as String : null,
      tipodecategoriaprofissional: map['tipodecategoriaprofissional'] != null ? map['tipodecategoriaprofissional'] as String : null,
      handicaplacoindividual: map['handicaplacoindividual'] != null ? map['handicaplacoindividual'] as String : null,
      idhandicaplacoindividual: map['idhandicaplacoindividual'] != null ? map['idhandicaplacoindividual'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioModelo.fromJson(String source) => UsuarioModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
