// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/widgets.dart';

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

  UsuarioModelo copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? email,
    ValueGetter<String?>? tipoDePix,
    ValueGetter<String?>? chavePix,
    ValueGetter<String?>? senha,
    ValueGetter<String?>? nome,
    ValueGetter<String?>? token,
    ValueGetter<String?>? hcCabeceira,
    ValueGetter<String?>? hcPezeiro,
    ValueGetter<String?>? idHcCabeceira,
    ValueGetter<String?>? idHcPezeiro,
    ValueGetter<String?>? tipo,
    ValueGetter<String?>? primeiroAcesso,
    ValueGetter<String?>? cpf,
    ValueGetter<String?>? dataNascimento,
    ValueGetter<String?>? sexo,
    ValueGetter<String?>? rg,
    ValueGetter<String?>? telefone,
    ValueGetter<String?>? celular,
    ValueGetter<String?>? cep,
    ValueGetter<String?>? endereco,
    ValueGetter<String?>? numero,
    ValueGetter<String?>? bairro,
    ValueGetter<String?>? complemento,
    ValueGetter<String?>? foto,
    ValueGetter<String?>? civil,
    ValueGetter<String?>? apelido,
    ValueGetter<String?>? nomeCidade,
    ValueGetter<String?>? idCidade,
    ValueGetter<bool?>? clienteBloqueado,
    ValueGetter<String?>? celularSuporte,
    ValueGetter<String?>? nivel,
    ValueGetter<String?>? somaDeHandicaps,
    ValueGetter<String?>? atualizacaoAndroid,
    ValueGetter<String?>? atualizacaoIos,
    ValueGetter<String?>? cabeceiroProvas,
    ValueGetter<String?>? pezeiroProvas,
    ValueGetter<String?>? ativoProva,
    ValueGetter<String?>? lacoemdupla,
    ValueGetter<String?>? tambores3,
    ValueGetter<String?>? lacoindividual,
    ValueGetter<String?>? tipodecategoriaprofissional,
    ValueGetter<String?>? handicaplacoindividual,
    ValueGetter<String?>? idhandicaplacoindividual,
  }) {
    return UsuarioModelo(
      id: id != null ? id() : this.id,
      email: email != null ? email() : this.email,
      tipoDePix: tipoDePix != null ? tipoDePix() : this.tipoDePix,
      chavePix: chavePix != null ? chavePix() : this.chavePix,
      senha: senha != null ? senha() : this.senha,
      nome: nome != null ? nome() : this.nome,
      token: token != null ? token() : this.token,
      hcCabeceira: hcCabeceira != null ? hcCabeceira() : this.hcCabeceira,
      hcPezeiro: hcPezeiro != null ? hcPezeiro() : this.hcPezeiro,
      idHcCabeceira: idHcCabeceira != null ? idHcCabeceira() : this.idHcCabeceira,
      idHcPezeiro: idHcPezeiro != null ? idHcPezeiro() : this.idHcPezeiro,
      tipo: tipo != null ? tipo() : this.tipo,
      primeiroAcesso: primeiroAcesso != null ? primeiroAcesso() : this.primeiroAcesso,
      cpf: cpf != null ? cpf() : this.cpf,
      dataNascimento: dataNascimento != null ? dataNascimento() : this.dataNascimento,
      sexo: sexo != null ? sexo() : this.sexo,
      rg: rg != null ? rg() : this.rg,
      telefone: telefone != null ? telefone() : this.telefone,
      celular: celular != null ? celular() : this.celular,
      cep: cep != null ? cep() : this.cep,
      endereco: endereco != null ? endereco() : this.endereco,
      numero: numero != null ? numero() : this.numero,
      bairro: bairro != null ? bairro() : this.bairro,
      complemento: complemento != null ? complemento() : this.complemento,
      foto: foto != null ? foto() : this.foto,
      civil: civil != null ? civil() : this.civil,
      apelido: apelido != null ? apelido() : this.apelido,
      nomeCidade: nomeCidade != null ? nomeCidade() : this.nomeCidade,
      idCidade: idCidade != null ? idCidade() : this.idCidade,
      clienteBloqueado: clienteBloqueado != null ? clienteBloqueado() : this.clienteBloqueado,
      celularSuporte: celularSuporte != null ? celularSuporte() : this.celularSuporte,
      nivel: nivel != null ? nivel() : this.nivel,
      somaDeHandicaps: somaDeHandicaps != null ? somaDeHandicaps() : this.somaDeHandicaps,
      atualizacaoAndroid: atualizacaoAndroid != null ? atualizacaoAndroid() : this.atualizacaoAndroid,
      atualizacaoIos: atualizacaoIos != null ? atualizacaoIos() : this.atualizacaoIos,
      cabeceiroProvas: cabeceiroProvas != null ? cabeceiroProvas() : this.cabeceiroProvas,
      pezeiroProvas: pezeiroProvas != null ? pezeiroProvas() : this.pezeiroProvas,
      ativoProva: ativoProva != null ? ativoProva() : this.ativoProva,
      lacoemdupla: lacoemdupla != null ? lacoemdupla() : this.lacoemdupla,
      tambores3: tambores3 != null ? tambores3() : this.tambores3,
      lacoindividual: lacoindividual != null ? lacoindividual() : this.lacoindividual,
      tipodecategoriaprofissional: tipodecategoriaprofissional != null ? tipodecategoriaprofissional() : this.tipodecategoriaprofissional,
      handicaplacoindividual: handicaplacoindividual != null ? handicaplacoindividual() : this.handicaplacoindividual,
      idhandicaplacoindividual: idhandicaplacoindividual != null ? idhandicaplacoindividual() : this.idhandicaplacoindividual,
    );
  }
}
