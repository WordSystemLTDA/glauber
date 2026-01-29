import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/data/servicos/compras_servico.dart';
import 'package:provadelaco/src/domain/models/retorno_compras_modelo.dart';

class ComprasProvedor extends ChangeNotifier {
  final ComprasServico _servico;
  int pagina1 = 1;
  int pagina2 = 1;
  int pagina3 = 1;
  bool carregando = false;
  bool temMaisParaCarregar = true;
  RetornoComprasModelo compras = RetornoComprasModelo(anteriores: [], atuais: [], canceladas: []);

  ComprasProvedor(this._servico);

  void listar(UsuarioModelo? usuario, bool resetar) async {
    if (carregando) return;

    if (resetar) {
      compras.anteriores.clear();

      compras.atuais.clear();

      compras.canceladas.clear();

      pagina1 = 1;
      pagina2 = 1;
      pagina3 = 1;
      temMaisParaCarregar = true;
      notifyListeners();
    }

    if (!temMaisParaCarregar) return;

    carregando = true;
    notifyListeners();

    await _servico.listar(pagina1, pagina2, pagina3).then((comprasServico) {
      if (pagina1 == 1) {
        compras.anteriores.clear();
      }
      if (pagina2 == 1) {
        compras.atuais.clear();
      }
      if (pagina2 == 1) {
        compras.canceladas.clear();
      }

      if (comprasServico.anteriores.length < 15) {
        temMaisParaCarregar = false;
        notifyListeners();
      }
      if (comprasServico.atuais.length < 15) {
        temMaisParaCarregar = false;
        notifyListeners();
      }
      if (comprasServico.canceladas.length < 15) {
        temMaisParaCarregar = false;
        notifyListeners();
      }

      compras = comprasServico;
      // compras.addAll(comprasServico);
      carregando = false;
    });

    pagina1++;
    pagina2++;
    pagina3++;
    notifyListeners();
  }

  void resetarCompras() {
    compras.anteriores.clear();

    compras.atuais.clear();

    compras.canceladas.clear();

    pagina1 = 1;
    pagina2 = 1;
    pagina3 = 1;
    temMaisParaCarregar = true;
    notifyListeners();
  }
}
