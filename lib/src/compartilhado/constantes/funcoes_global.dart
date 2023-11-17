import 'package:url_launcher/url_launcher.dart';
import 'package:provadelaco/src/compartilhado/constantes/constantes_global.dart';

class FuncoesGlobais {
  static void abrirWhatsapp(String celular) async {
    var celularFiltrado = celular.replaceAll(RegExp(r'[^0-9]'), '');
    var whatsapp = "${ConstantesGlobal.urlWhatsapp}$celularFiltrado";

    await launchUrl(Uri.parse(whatsapp));
  }
}
