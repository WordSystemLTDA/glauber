import 'package:glauber/src/essencial/network/http_cliente.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/finalizar_compra_modelo.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/servicos/finalizar_compra_servico.dart';

class FinalizarCompraServicoImpl implements FinalizarCompraServico {
  final IHttpClient client;

  FinalizarCompraServicoImpl(this.client);

  @override
  Future<bool> inserir(FinalizarCompraModelo dados) async {
    return false;
  }
}
