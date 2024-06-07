import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/clientes_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/retorno_compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/retorno_gerar_pagamentos.dart';

abstract interface class ComprasServico {
  Future<RetornoComprasModelo> listar(int pagina1, int pagina2, int pagina3);
  Future<List<ComprasModelo>> listarSomenteInscricoes(int pagina);
  Future<List<ClientesModelo>> listarClientes(String pesquisa);
  Future<bool> baixarPDF(String idVenda);
  Future<(bool, String)> transferirCompras(List<ComprasModelo> comprasTransferencia, String novoCliente);
  Future<(bool, String, RetornoGerarPagamentos?)> gerarPagamentos(List<ComprasModelo> comprasPagamentos, UsuarioModelo? usuario);
  Future<(bool, String)> editarParceiro(String idParceiroVenda, String idParceiroOriginal, String idNovoParceiro, String modalidade);
}
