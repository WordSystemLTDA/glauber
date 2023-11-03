import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/listar_informacoes_modelo.dart';

abstract interface class ListarInformacoesServico {
  Future<(bool, String, ListarInformacoesModelo)> listarInformacoes(String idProva, String idEvento);
}
