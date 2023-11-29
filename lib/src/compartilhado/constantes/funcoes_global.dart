import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provadelaco/src/compartilhado/constantes/constantes_global.dart';

class FuncoesGlobais {
  static void abrirWhatsapp(String celular) async {
    var celularFiltrado = celular.replaceAll(RegExp(r'[^0-9]'), '');
    var whatsapp = "${ConstantesGlobal.urlWhatsapp}$celularFiltrado";

    await launchUrl(Uri.parse(whatsapp));
  }

  static Future<String> getVersaoInstalada() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String numeroVersaoApp = packageInfo.version;

    return numeroVersaoApp.toString();
  }

  static Future<bool> appPrecisaAtualizar(versaoApp, versaoAppIos) async {
    String numeroVersaoApp = await getVersaoInstalada();
    String numeroVersaoAppServidor = Platform.isIOS ? versaoAppIos : versaoApp;

    if (numeroVersaoAppServidor.split('.').length <= 2) {
      numeroVersaoAppServidor += '.0';
    }

    if (Version.parse(numeroVersaoAppServidor) > Version.parse(numeroVersaoApp)) {
      return true;
    } else {
      return false;
    }
  }
}
