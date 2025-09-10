import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/modulos/animais/paginas/pagina_animais.dart';
import 'package:provadelaco/src/modulos/animais/paginas/pagina_inserir_animais.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_cadastro.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_login.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_preencher_informacoes.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_selecionar_modalidades.dart';
import 'package:provadelaco/src/modulos/buscar/ui/paginas/pagina_buscar.dart';
import 'package:provadelaco/src/modulos/compras/ui/paginas/pagina_compras.dart';
import 'package:provadelaco/src/modulos/compras/ui/paginas/pagina_selecionar_pagamentos.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/paginas/pagina_finalizar_compra.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/paginas/pagina_sucesso_compra.dart';
import 'package:provadelaco/src/modulos/home/ui/paginas/pagina_confirmar_parceiros.dart';
import 'package:provadelaco/src/modulos/home/ui/paginas/pagina_home.dart';
import 'package:provadelaco/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/ui/paginas/pagina_ordemdeentrada.dart';
import 'package:provadelaco/src/modulos/perfil/ui/paginas/pagina_editar_usuario.dart';
import 'package:provadelaco/src/modulos/perfil/ui/paginas/pagina_perfil.dart';
import 'package:provadelaco/src/modulos/propaganda/ui/paginas/pagina_propaganda.dart';
import 'package:provadelaco/src/modulos/provas/ui/paginas/pagina_aovivo.dart';
import 'package:provadelaco/src/modulos/provas/ui/paginas/pagina_provas.dart';
import 'package:provadelaco/src/modulos/splash/ui/paginas/pagina_splash.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRotas.login:
        return buildRoute(const PaginaLogin(), settings: settings);
      case AppRotas.cadastro:
        final argumentos = settings.arguments as PaginaCadastroArgumentos;
        return buildRoute(PaginaCadastro(argumentos: argumentos), settings: settings);
      case AppRotas.home:
        return buildRoute(const PaginaHome(), settings: settings);
      case AppRotas.inicio:
        final argumentos = settings.arguments as PaginaInicioArgumentos?;

        if (argumentos != null) {
          return buildRoute(PaginaInicio(argumentos: argumentos), settings: settings, animacao: true);
        } else {
          return buildRoute(const PaginaInicio(), settings: settings, animacao: true);
        }
      case AppRotas.splash:
        return buildRoute(const PaginaSplash(), settings: settings);
      case AppRotas.buscar:
        return buildRoute(const PaginaBuscar(), settings: settings);
      case AppRotas.selecionarModalidades:
        final argumentos = settings.arguments as PaginaSelecionarModalidadesArgumentos;
        return buildRoute(PaginaSelecionarModalidades(argumentos: argumentos), settings: settings);
      case AppRotas.compras:
        return buildRoute(const PaginaCompras(), settings: settings);
      case AppRotas.ordemDeEntrada:
        return buildRoute(const PaginaOrdemDeEntrada(), settings: settings);
      case AppRotas.perfil:
        return buildRoute(const PaginaPerfil(), settings: settings);
      case AppRotas.editarUsuario:
        return buildRoute(const PaginaEditarUsuario(), settings: settings);
      case AppRotas.animais:
        final argumentos = settings.arguments as PaginaAnimaisArgumentos;
        return buildRoute(PaginaAnimais(argumentos: argumentos), settings: settings);
      case AppRotas.animaisCadastrar:
        return buildRoute(const PaginaInserirAnimais(), settings: settings);
      case AppRotas.selecionarInscricoes:
        return buildRoute(const PaginaSelecionarPagamentos(), settings: settings);
      case AppRotas.aovivo:
        final argumentos = settings.arguments as PaginaAoVivoArgumentos;
        return buildRoute(PaginaAoVivo(argumentos: argumentos), settings: settings);
      case AppRotas.finalizarCompra:
        final argumentos = settings.arguments as PaginaFinalizarCompraArgumentos;
        return buildRoute(PaginaFinalizarCompra(argumentos: argumentos), settings: settings);
      case AppRotas.provas:
        final argumentos = settings.arguments as PaginaProvasArgumentos;
        return buildRoute(PaginaProvas(argumentos: argumentos), settings: settings);
      case AppRotas.propaganda:
        final argumentos = settings.arguments as PaginaPropagandaArgumentos;
        return buildRoute(PaginaPropaganda(argumentos: argumentos), settings: settings);
      case AppRotas.preencherInformacoes:
        final argumentos = settings.arguments as PaginaPreencherInformacoesArgumentos;
        return buildRoute(PaginaPreencherInformacoes(argumentos: argumentos), settings: settings);
      case AppRotas.sucessoCompra:
        final argumentos = settings.arguments as PaginaSucessoCompraArgumentos;
        return buildRoute(PaginaSucessoCompra(argumentos: argumentos), settings: settings);
      case AppRotas.confirmarParceiros:
        // final argumentos = settings.arguments as PaginaSucessoCompraArgumentos;
        return buildRoute(PaginaConfirmarParceiros(), settings: settings);
      default:
        return _errorRoute();
    }
  }

  static dynamic buildRoute(Widget child, {required RouteSettings settings, bool animacao = false}) {
    if (animacao) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return child;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    } else {
      return MaterialPageRoute(settings: settings, builder: (BuildContext context) => child);
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Essa rota não existe.',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
