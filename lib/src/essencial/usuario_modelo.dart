import 'dart:convert';

class UsuarioModelo {
  String? id;
  String? email;
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
  String? cidade;
  String? foto;

  UsuarioModelo({
    required this.id,
    required this.email,
    required this.senha,
    required this.hcCabeceira,
    required this.hcPezeiro,
    required this.idHcCabeceira,
    required this.idHcPezeiro,
    required this.nome,
    required this.token,
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
    required this.cidade,
    required this.foto,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
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
      'cidade': cidade,
      'foto': foto,
    };
  }

  factory UsuarioModelo.fromMap(Map<String, dynamic> map) {
    return UsuarioModelo(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
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
      cidade: map['cidade'] != null ? map['cidade'] as String : null,
      foto: map['foto'] != null ? map['foto'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioModelo.fromJson(String source) => UsuarioModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
