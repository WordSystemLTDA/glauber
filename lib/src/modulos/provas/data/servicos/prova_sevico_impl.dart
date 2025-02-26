import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/pagamentos_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/modalidade_prova_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/modelo_prova_ao_vivo_retorno.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/permitir_compra_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_retorno_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/prova_servico.dart';

class ProvaServicoImpl implements ProvaServico {
  final IHttpClient client;

  ProvaServicoImpl(this.client);

  @override
  Future<ProvaRetornoModelo> listar(UsuarioModelo? usuario, String idEvento, String tipo) async {
    var idCliente = usuario != null ? usuario.id : 0;

    var url = 'provas/listar.php?id_evento=$idEvento&id_cliente=$idCliente&tipo=$tipo';

    var response = await client.get(url: url);
    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];

    EventoModelo evento = EventoModelo.fromMap(jsonData['evento']);

    List<ModalidadeProvaModelo> provas = List<ModalidadeProvaModelo>.from(jsonData['provas'].map((elemento) {
      return ModalidadeProvaModelo.fromJson(elemento);
    }));

    List<NomesCabeceiraModelo> nomesCabeceira = List<NomesCabeceiraModelo>.from(jsonData['nomesCabeceira'].map((elemento) {
      return NomesCabeceiraModelo.fromMap(elemento);
    }));

    List<PagamentosModelo> pagamentoDisponiveis = List<PagamentosModelo>.from(jsonData['pagamentoDisponiveis'].map((elemento) {
      return PagamentosModelo.fromMap(elemento);
    }));

    if (response.statusCode == 200 && sucesso == true) {
      return ProvaRetornoModelo(sucesso: sucesso, provas: provas, evento: evento, pagamentoDisponiveis: pagamentoDisponiveis, nomesCabeceira: nomesCabeceira);
    } else {
      return Future.error('');
    }
  }

  @override
  Future<ModeloProvaAoVivoRetorno> listarAoVivo(UsuarioModelo? usuario, String idEmpresa, String idEvento) async {
    var url = 'provas/listar_ao_vivo.php?id_evento=$idEvento&idEmpresa=$idEmpresa';

    var response = await client.get(url: url);
    var jsonData = jsonDecode(response.data);

    return ModeloProvaAoVivoRetorno.fromMap(jsonData);
  }

  @override
  Future<PermitirCompraModelo> permitirAdicionarCompra(String idEvento, String idProva, UsuarioModelo? usuario, String idCabeceira, String quantidadeCarrinho) async {
    var idCliente = usuario != null ? usuario.id : 0;

    var url = 'provas/permitir_adicionar_compra.php?id_evento=$idEvento&id_cliente=$idCliente&id_cabeceira=$idCabeceira&id_prova=$idProva&quantidade_carrinho=$quantidadeCarrinho';

    var response = await client.get(url: url);
    var jsonData = jsonDecode(response.data);

    return PermitirCompraModelo.fromJson(jsonData);
  }
}
