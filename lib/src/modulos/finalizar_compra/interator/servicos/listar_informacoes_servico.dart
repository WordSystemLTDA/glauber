import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/listar_informacoes_modelo.dart';
import 'package:glauber/src/modulos/provas/interator/modelos/prova_modelo.dart';

abstract interface class ListarInformacoesServico {
  Future<(bool, String, ListarInformacoesModelo)> listarInformacoes(List<ProvaModelo> provas, String idEvento);
}
