// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FormularioEditarUsuarioModelo {
  final String id;
  final String nome;
  final String apelido;
  final String civil;
  final String sexo;
  final String dataNascimento;
  final String cpf;
  final String rg;
  final String email;
  final String senha;
  final String telefone;
  final String celular;
  final String cep;
  final String endereco;
  final String numero;
  final String bairro;
  final String complemento;
  final String cidade;
  final String hcCabeceira;
  final String hcPezeiro;

  FormularioEditarUsuarioModelo({
    required this.id,
    required this.nome,
    required this.apelido,
    required this.civil,
    required this.sexo,
    required this.dataNascimento,
    required this.cpf,
    required this.rg,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.celular,
    required this.cep,
    required this.endereco,
    required this.numero,
    required this.bairro,
    required this.complemento,
    required this.cidade,
    required this.hcCabeceira,
    required this.hcPezeiro,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'apelido': apelido,
      'civil': civil,
      'sexo': sexo,
      'dataNascimento': dataNascimento,
      'cpf': cpf,
      'rg': rg,
      'email': email,
      'senha': senha,
      'telefone': telefone,
      'celular': celular,
      'cep': cep,
      'endereco': endereco,
      'numero': numero,
      'bairro': bairro,
      'complemento': complemento,
      'cidade': cidade,
      'hcCabeceira': hcCabeceira,
      'hcPezeiro': hcPezeiro,
    };
  }

  factory FormularioEditarUsuarioModelo.fromMap(Map<String, dynamic> map) {
    return FormularioEditarUsuarioModelo(
      id: map['id'] as String,
      nome: map['nome'] as String,
      apelido: map['apelido'] as String,
      civil: map['civil'] as String,
      sexo: map['sexo'] as String,
      dataNascimento: map['dataNascimento'] as String,
      cpf: map['cpf'] as String,
      rg: map['rg'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
      telefone: map['telefone'] as String,
      celular: map['celular'] as String,
      cep: map['cep'] as String,
      endereco: map['endereco'] as String,
      numero: map['numero'] as String,
      bairro: map['bairro'] as String,
      complemento: map['complemento'] as String,
      cidade: map['cidade'] as String,
      hcCabeceira: map['hcCabeceira'] as String,
      hcPezeiro: map['hcPezeiro'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormularioEditarUsuarioModelo.fromJson(String source) => FormularioEditarUsuarioModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
