import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provadelaco/data/repositories/ordemdeentrada_prova_repository.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/ui/features/ordem_de_entrada/widgets/ordem_de_entrada_card_prova.dart';
import 'package:provider/provider.dart';

class PaginaOrdemDeEntrada extends StatefulWidget {
  final String idListaCompeticao;
  final String? nomeProva;
  final String idEmpresa;
  final String idEvento;

  const PaginaOrdemDeEntrada({
    super.key,
    required this.idListaCompeticao,
    required this.nomeProva,
    required this.idEmpresa,
    required this.idEvento,
  });

  @override
  State<PaginaOrdemDeEntrada> createState() => _PaginaOrdemDeEntradaState();
}

class _PaginaOrdemDeEntradaState extends State<PaginaOrdemDeEntrada> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _filtroSelecionado = '';
  int _paginaAtual = 0;
  bool _carregandoProximaPagina = false;
  Timer? _debounceTimer;

  bool _carregandoInicial = true;
  String? _nomeProvaSelecionada;
  List<dynamic> _listaLocal = [];

  @override
  void initState() {
    super.initState();
    _nomeProvaSelecionada = widget.nomeProva;
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDados(resetar: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _carregarProximaPagina();
    }
  }

  Future<void> _carregarProximaPagina() async {
    if (_carregandoProximaPagina) return;
    setState(() {
      _carregandoProximaPagina = true;
    });

    _paginaAtual += 1;
    await _buscarDados(pagina: _paginaAtual);

    if (mounted) {
      setState(() {
        _carregandoProximaPagina = false;
      });
    }
  }

  Future<void> _carregarDados({bool resetar = false}) async {
    if (!mounted) return;

    if (resetar) {
      setState(() {
        _paginaAtual = 0;
        _carregandoInicial = true;
        // Se for refresh completo, limpamos a lista local para mostrar carregamento,
        // ou mantemos para evitar flicker? Melhor limpar se for mudança de filtro
      });
    }

    await _buscarDados(pagina: _paginaAtual);

    if (mounted && resetar) {
      setState(() {
        _carregandoInicial = false;
      });
    }
  }

  Future<void> _buscarDados({required int pagina}) async {
    if (!mounted) return;
    final ordemDeEntradaProvaStore = Provider.of<OrdemDeEntradaProvaStore>(context, listen: false);
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);

    await ordemDeEntradaProvaStore.listarPorListaCompeticao(
      usuarioProvider.usuario,
      widget.idListaCompeticao,
      widget.idEmpresa,
      widget.idEvento,
      _searchController.text,
      somatoria: _filtroSelecionado,
      pagina: pagina,
    );

    if (mounted) {
      setState(() {
        // Atualiza lista local com o que está na store
        // Nota: listarPorListaCompeticao na store geralmente substitui a lista se for pagina 0
        // ou adiciona se for pagina > 0?
        // O store parece manter o estado 'ordemdeentradas'.
        _listaLocal = ordemDeEntradaProvaStore.ordemdeentradas;
      });
    }
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _carregarDados(resetar: true);
    });
  }

  void _onFilterChanged(String? value) {
    setState(() {
      _filtroSelecionado = value ?? '';
    });
    _carregarDados(resetar: true);
  }

  @override
  Widget build(BuildContext context) {
    final ordemDeEntradaProvaStore = Provider.of<OrdemDeEntradaProvaStore>(context);
    // Usamos a lista local atualizada após a busca
    final lista = _listaLocal;

    return Column(
      children: [
        // Filtros e Pesquisa
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar na lista',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _filtroSelecionado.isEmpty ? null : _filtroSelecionado,
                    hint: const Text('Somatoria'),
                    items: [
                      const DropdownMenuItem(value: '', child: Text('Todas')),
                      ...ordemDeEntradaProvaStore.somatoriasDisponiveis.map((somatoria) {
                        return DropdownMenuItem(
                          value: somatoria['valor'],
                          child: Text(somatoria['label']!),
                        );
                      }),
                    ],
                    onChanged: _onFilterChanged,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Lista
        Expanded(
          child: _carregandoInicial && lista.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : lista.isEmpty
                  ? const Center(child: Text('Nenhum resultado encontrado'))
                  : RefreshIndicator(
                      onRefresh: () async => _carregarDados(resetar: true),
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        // Adiciona item extra para loading indicator se estiver carregando mais
                        itemCount: lista.length + (_carregandoProximaPagina ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == lista.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          var item = lista[index];
                          return CardOrdemDeEntradaProva(
                            item: item,
                            nomeprova: _nomeProvaSelecionada ?? '',
                            mostrarOpcoes: true,
                            selecionado: false,
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}
