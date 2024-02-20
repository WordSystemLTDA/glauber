import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/clientes_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/retorno_lista_compra_modelo.dart';

abstract interface class ComprasServico {
  Future<List<RetornoListaCompraModelo>> listar(UsuarioModelo? usuario, int pagina);
  Future<List<ClientesModelo>> listarClientes(String pesquisa);
  Future<bool> baixarPDF(String idVenda);
  Future<(bool, String)> transferirCompras(List<ComprasModelo> comprasTransferencia, String novoCliente);
}
