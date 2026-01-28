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
  final String tipoDePix;
  final String chavePix;
  final String lacoemdupla;
  final String tambores3;
  final String lacoindividual;
  final String tipodecategoriaprofissional;
  final String handicaplacoindividual;

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
    required this.tipoDePix,
    required this.chavePix,
    required this.lacoemdupla,
    required this.tambores3,
    required this.lacoindividual,
    required this.tipodecategoriaprofissional,
    required this.handicaplacoindividual,
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
      'tipoDePix': tipoDePix,
      'chavePix': chavePix,
      'lacoemdupla': lacoemdupla,
      'tambores3': tambores3,
      'lacoindividual': lacoindividual,
      'tipodecategoriaprofissional': tipodecategoriaprofissional,
      'handicaplacoindividual': handicaplacoindividual,
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
      tipoDePix: map['tipoDePix'] as String,
      chavePix: map['chavePix'] as String,
      lacoemdupla: map['lacoemdupla'] as String,
      tambores3: map['tambores3'] as String,
      lacoindividual: map['lacoindividual'] as String,
      tipodecategoriaprofissional: map['tipodecategoriaprofissional'] as String,
      handicaplacoindividual: map['handicaplacoindividual'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormularioEditarUsuarioModelo.fromJson(String source) => FormularioEditarUsuarioModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
