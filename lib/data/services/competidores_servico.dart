import 'dart:convert';

import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';

class CompetidoresPaginados {
  final List<CompetidoresModelo> itens;
  final bool hasMore;
  final int page;
  final int limit;
  final int total;

  CompetidoresPaginados({
    required this.itens,
    required this.hasMore,
    required this.page,
    required this.limit,
    required this.total,
  });
}

class CompetidoresServico {
  final DioClient client;

  CompetidoresServico(this.client);

  Future<CompetidoresPaginados> listarCompetidoresPaginado(
    String? idCabeceira,
    UsuarioModelo? usuario,
    String pesquisa,
    String idProva, {
    int page = 1,
    int limit = 20,
    String filtro = 'todos',
    List<String> idsJaSelecionados = const [],
  }) async {
    final pesquisaParam = Uri.encodeQueryComponent(pesquisa);
    final idCliente = usuario?.id ?? '';
    final idCabeceiraParam = Uri.encodeQueryComponent(idCabeceira ?? '');
    final idProvaParam = Uri.encodeQueryComponent(idProva);
    final idClienteParam = Uri.encodeQueryComponent(idCliente);
    final idsSelecionadosParam = Uri.encodeQueryComponent(idsJaSelecionados.join(','));
    final filtroParam = Uri.encodeQueryComponent(filtro);
    final url = 'compras/listar_competidores.php?pesquisa=$pesquisaParam&id_prova=$idProvaParam&id_cliente=$idClienteParam&id_cabeceira=$idCabeceiraParam&page=$page&limit=$limit&filtro=$filtroParam&ids_selecionados=$idsSelecionadosParam';

    final response = await client.dio.get(url);
    final jsonData = jsonDecode(response.data);
    final dados = jsonData['dados'];
    final sucesso = jsonData['sucesso'];
    final paginacao = jsonData['paginacao'] ?? const {};

    if (sucesso == true && dados != null) {
      return CompetidoresPaginados(
        itens: List<CompetidoresModelo>.from(dados.map((elemento) => CompetidoresModelo.fromMap(elemento))),
        hasMore: paginacao['hasMore'] == true,
        page: (paginacao['page'] is int) ? paginacao['page'] as int : page,
        limit: (paginacao['limit'] is int) ? paginacao['limit'] as int : limit,
        total: (paginacao['total'] is int) ? paginacao['total'] as int : (dados as List).length,
      );
    }

    return CompetidoresPaginados(
      itens: const [],
      hasMore: false,
      page: page,
      limit: limit,
      total: 0,
    );
  }

  Future<CompetidoresPaginados> listarBancoCompetidoresPaginado(
    String? idCabeceira,
    UsuarioModelo? usuario,
    String pesquisa,
    String idProva, {
    int page = 1,
    int limit = 20,
    String filtro = 'todos',
    List<String> idsJaSelecionados = const [],
  }) async {
    final idCliente = usuario?.id ?? '0';
    final pesquisaParam = Uri.encodeQueryComponent(pesquisa);
    final idProvaParam = Uri.encodeQueryComponent(idProva);
    final idClienteParam = Uri.encodeQueryComponent(idCliente);
    final idCabeceiraParam = Uri.encodeQueryComponent(idCabeceira ?? '');
    final idsSelecionadosParam = Uri.encodeQueryComponent(idsJaSelecionados.join(','));
    final filtroParam = Uri.encodeQueryComponent(filtro);
    final url = 'compras/listar_clientes_sorteio.php?pesquisa=$pesquisaParam&id_prova=$idProvaParam&id_cliente=$idClienteParam&id_cabeceira=$idCabeceiraParam&page=$page&limit=$limit&filtro=$filtroParam&ids_selecionados=$idsSelecionadosParam';

    final response = await client.dio.get(url);
    final jsonData = jsonDecode(response.data);
    final dados = jsonData['dados'];
    final sucesso = jsonData['sucesso'];
    final paginacao = jsonData['paginacao'] ?? const {};

    if (sucesso == true && dados != null) {
      return CompetidoresPaginados(
        itens: List<CompetidoresModelo>.from(dados.map((elemento) => CompetidoresModelo.fromMap(elemento))),
        hasMore: paginacao['hasMore'] == true,
        page: (paginacao['page'] is int) ? paginacao['page'] as int : page,
        limit: (paginacao['limit'] is int) ? paginacao['limit'] as int : limit,
        total: (paginacao['total'] is int) ? paginacao['total'] as int : (dados as List).length,
      );
    }

    return CompetidoresPaginados(
      itens: const [],
      hasMore: false,
      page: page,
      limit: limit,
      total: 0,
    );
  }

  Future<List<CompetidoresModelo>> listarCompetidores(String? idCabeceira, UsuarioModelo? usuario, String pesquisa, String idProva) async {
    final resultado = await listarCompetidoresPaginado(
      idCabeceira,
      usuario,
      pesquisa,
      idProva,
      page: 1,
      limit: 100,
    );

    return resultado.itens;
  }

  Future<List<CompetidoresModelo>> listarBancoCompetidores(String? idCabeceira, UsuarioModelo? usuario, String pesquisa, String idProva) async {
    final resultado = await listarBancoCompetidoresPaginado(
      idCabeceira,
      usuario,
      pesquisa,
      idProva,
      page: 1,
      limit: 100,
    );

    return resultado.itens;
  }
}
