// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/constantes/funcoes_global.dart';
import 'package:provadelaco/src/essencial/providers/versoes/versoes_modelo.dart';
import 'package:provadelaco/src/essencial/providers/versoes/versoes_provider.dart';
import 'package:provadelaco/src/modulos/home/interator/estados/home_estado.dart';
import 'package:provadelaco/src/modulos/home/interator/servicos/home_servico.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeStore extends ValueNotifier<HomeEstado> {
  final HomeServico _homeServico;

  HomeStore(this._homeServico) : super(EstadoInicial());

  void listar(BuildContext context) async {
    value = Carregando();

    var resposta = await _homeServico.listar();

    if (resposta.sucesso) {
      var versaoProvider = context.read<VersoesProvider>();
      versaoProvider.setVersoes(resposta.versoes);

      verificarAtualicao(context, resposta.versoes);

      value = Carregado(eventos: resposta.eventos, propagandas: resposta.propagandas);
    } else {
      value = ErroAoCarregar(erro: Exception('Erro ao listar.'));
    }
  }

  void verificarAtualicao(context, VersoesModelo versoes) async {
    if (await FuncoesGlobais.appPrecisaAtualizar(versoes.versaoAppAndroid, versoes.versaoAppIos)) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contextDialog) {
          return AlertDialog(
            title: const Text(
              'Atualização disponível',
              style: TextStyle(fontSize: 16),
            ),
            content: const Text('Clique no botão ATUALIZAR para poder atualizar o aplicativo'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Atualizar'),
                onPressed: () async {
                  try {
                    if (Platform.isAndroid) {
                      if (await canLaunchUrl(Uri.parse(versoes.linkAtualizacaoAndroid))) {
                        await launchUrl(Uri.parse(versoes.linkAtualizacaoAndroid));
                      }
                    } else if (Platform.isIOS) {
                      if (await canLaunchUrl(Uri.parse(versoes.linkAtualizacaoIos))) {
                        await launchUrl(Uri.parse(versoes.linkAtualizacaoIos));
                      }
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Não foi possível abrir o LINK, entre em contato com o suporte.'),
                      backgroundColor: Colors.red,
                      showCloseIcon: true,
                    ));
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }
}
