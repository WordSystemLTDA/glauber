import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/listar_informacoes_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

abstract interface class ListarInformacoesServico {
  Future<(bool, String, ListarInformacoesModelo)> listarInformacoes(UsuarioModelo? usuario, List<ProvaModelo> provas, String idEvento, bool editando, String idVenda);
}
