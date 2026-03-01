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
  bool _mostrarFiltros = true;
  double _ultimoOffset = 0;

  bool _carregandoInicial = true;
  String? _nomeProvaSelecionada;
  List<dynamic> _listaLocal = [];

  final Set<String> _filtrosSelecionados = <String>{};

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

    final offset = _scrollController.position.pixels;

    if (offset <= 0 && !_mostrarFiltros) {
      setState(() => _mostrarFiltros = true);
    } else {
      final diferenca = offset - _ultimoOffset;
      if (diferenca > 8 && _mostrarFiltros) {
        setState(() => _mostrarFiltros = false);
      } else if (diferenca < -8 && !_mostrarFiltros) {
        setState(() => _mostrarFiltros = true);
      }
    }

    _ultimoOffset = offset;

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
      satSelecionado: _filtrosSelecionados.contains('1'),
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
    final lista = _listaLocal;
    final theme = Theme.of(context);

    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          child: _mostrarFiltros
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.tune_rounded, size: 18, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Filtros',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Pesquisar na lista',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: _searchController.text.isEmpty
                                      ? null
                                      : IconButton(
                                          onPressed: () {
                                            _searchController.clear();
                                            _carregarDados(resetar: true);
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.close),
                                        ),
                                  filled: true,
                                  fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (value) {
                                  _onSearchChanged(value);
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _filtroSelecionado.isEmpty ? null : _filtroSelecionado,
                                  hint: const Text('Somatória'),
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
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SegmentedButton<String>(
                            style: SegmentedButton.styleFrom(
                              selectedBackgroundColor: theme.colorScheme.primary,
                              selectedForegroundColor: theme.colorScheme.onPrimary,
                              backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                              foregroundColor: theme.colorScheme.onSurface,
                              side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
                            ),
                            segments: const [
                              ButtonSegment(value: '1', label: Text('SAT')),
                            ],
                            selected: _filtrosSelecionados,
                            onSelectionChanged: (value) {
                              final novo = Set<String>.from(value);
                              final mudou = _filtrosSelecionados.length != novo.length || !_filtrosSelecionados.containsAll(novo);
                              if (!mudou) return;

                              setState(() {
                                _filtrosSelecionados
                                  ..clear()
                                  ..addAll(novo);
                              });

                              _carregarDados(resetar: true);
                            },
                            emptySelectionAllowed: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),

        Expanded(
          child: _carregandoInicial && lista.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : lista.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded, size: 44, color: theme.hintColor),
                            const SizedBox(height: 10),
                            Text(
                              'Nenhum resultado encontrado',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Ajuste a pesquisa ou filtros para tentar novamente.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async => _carregarDados(resetar: true),
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
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
