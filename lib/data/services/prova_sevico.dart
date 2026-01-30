import 'dart:convert';

import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/animal/animal.dart';
import 'package:provadelaco/domain/models/evento/evento.dart';
import 'package:provadelaco/domain/models/modalidade_prova_modelo.dart';
import 'package:provadelaco/domain/models/modelo_prova_ao_vivo_retorno.dart';
import 'package:provadelaco/domain/models/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/domain/models/pagamentos_modelo.dart';
import 'package:provadelaco/domain/models/permitir_compra_modelo.dart';
import 'package:provadelaco/domain/models/prova_retorno_modelo.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';

class ProvaServico {
  final DioClient client;

  ProvaServico(this.client);

  Future<ProvaRetornoModelo> listar(UsuarioModelo? usuario, String idEvento, String tipo) async {
    var idCliente = usuario != null ? usuario.id : 0;

    var url = 'provas/listar.php?id_evento=$idEvento&id_cliente=$idCliente&tipo=$tipo';

    var response = await client.dio.get(url);
    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];

    EventoModelo evento = EventoModelo.fromMap(jsonData['evento']);
    ModeloAnimal? animalPadrao = jsonData['animalPadrao'] != null ? ModeloAnimal.fromJson(jsonData['animalPadrao']) : null;

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
      return ProvaRetornoModelo(
        sucesso: sucesso,
        provas: provas,
        evento: evento,
        pagamentoDisponiveis: pagamentoDisponiveis,
        nomesCabeceira: nomesCabeceira,
        animalPadrao: animalPadrao,
      );
    } else {
      return Future.error('');
    }
  }

  Future<ModeloProvaAoVivoRetorno> listarAoVivo(UsuarioModelo? usuario, String idEmpresa, String idEvento) async {
    var url = 'provas/listar_ao_vivo.php?id_evento=$idEvento&idEmpresa=$idEmpresa';

    var response = await client.dio.get(url);
    var jsonData = jsonDecode(response.data);

    return ModeloProvaAoVivoRetorno.fromMap(jsonData);
  }

  Future<PermitirCompraModelo> permitirAdicionarCompra(String idEvento, String idProva, UsuarioModelo? usuario, String? idCabeceira, String quantidadeCarrinho) async {
    var idCliente = usuario != null ? usuario.id : 0;

    var url = 'provas/permitir_adicionar_compra.php?id_evento=$idEvento&id_cliente=$idCliente&id_cabeceira=$idCabeceira&id_prova=$idProva&quantidade_carrinho=$quantidadeCarrinho';

    var response = await client.dio.get(url);
    var jsonData = jsonDecode(response.data);

    return PermitirCompraModelo.fromJson(jsonData);
  }
}
