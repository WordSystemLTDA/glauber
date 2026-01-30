import 'package:provadelaco/config/config.dart';
import 'package:url_launcher/url_launcher.dart';

class Whatsapp {
  static void abrir(String celular) async {
    var celularFiltrado = celular.replaceAll(RegExp(r'[^0-9]'), '');
    var whatsapp = "${ConstantesGlobal.urlWhatsapp}$celularFiltrado";

    await launchUrl(Uri.parse(whatsapp));
  }
}
