import 'package:flutter/material.dart';

class AppRotas {
  static const splash = '/';
  static const inicio = '/inicio';
  static const login = '/autenticacao/login';
  static const cadastro = '/autenticacao/cadastrar';
  static const preencherInformacoes = '/autenticacao/preencherInformacoes';
  static const home = '/home';
  static const buscar = '/buscar';
  static const compras = '/compras';
  static const finalizarCompra = '/finalizarCompra';
  static const ordemDeEntrada = '/ordemDeEntrada';
  static const perfil = '/perfil';
  static const propaganda = '/propaganda';
  static const provas = '/provas';
  static const editarUsuario = '/editarUsuario';
  static const sucessoCompra = '/sucessoCompra';
  static const calendario = '/calendario';
  static const verEventoCalendario = '/verEventoCalendario';
  static const aovivo = '/aovivo';
  static const animais = '/animais';
  static const animaisCadastrar = '/animais/cadastrar/';

  static const paginaInicial = splash;

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
