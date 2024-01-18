import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/constantes/dados_fakes.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';

class ComprasProvedor extends ChangeNotifier {
  final ComprasServico _servico;
  int pagina = 1;
  bool carregando = false;
  bool temMaisParaCarregar = true;
  List<ComprasModelo> compras = [...DadosFakes.dadosFakesCompras];

  ComprasProvedor(this._servico);

  void listar(UsuarioModelo? usuario, bool resetar) async {
    if (carregando) return;

    if (resetar) {
      compras.clear();
      compras.addAll(DadosFakes.dadosFakesCompras);
      pagina = 1;
      temMaisParaCarregar = true;
      notifyListeners();
    }

    if (!temMaisParaCarregar) return;

    carregando = true;
    notifyListeners();

    await _servico.listar(usuario, pagina).then((comprasServico) {
      if (pagina == 1) {
        compras.clear();
      }

      if (comprasServico.length < 15) {
        temMaisParaCarregar = false;
        notifyListeners();
      }

      compras.addAll(comprasServico);
      carregando = false;
    });

    pagina++;
    notifyListeners();
  }

  void resetarCompras() {
    compras.clear();
    compras.addAll(DadosFakes.dadosFakesCompras);
    pagina = 1;
    temMaisParaCarregar = true;
    notifyListeners();
  }
}
