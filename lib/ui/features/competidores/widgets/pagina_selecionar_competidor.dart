import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/data/services/competidores_servico.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provider/provider.dart';

class PaginaSelecionarCompetidor extends StatefulWidget {
  final String titulo;
  final String hintText;
  final String idProva;
  final String? idCabeceira;
  final bool usarBancoCompetidores;
  final bool Function(CompetidoresModelo competidor)? podeSelecionar;
  final String Function(CompetidoresModelo competidor)? mensagemBloqueio;
  final bool destacarCardsStatus;
  final bool Function(CompetidoresModelo competidor)? jaSelecionado;
  final bool bloquearCliqueIncompativel;
  final List<String> idsJaSelecionados;

  const PaginaSelecionarCompetidor({
    super.key,
    this.titulo = 'Selecionar competidor',
    this.hintText = 'Pesquisar por nome, apelido ou ID',
    this.idProva = '713',
    this.idCabeceira = '1',
    this.usarBancoCompetidores = false,
    this.podeSelecionar,
    this.mensagemBloqueio,
    this.destacarCardsStatus = false,
    this.jaSelecionado,
    this.bloquearCliqueIncompativel = false,
    this.idsJaSelecionados = const [],
  });

  @override
  State<PaginaSelecionarCompetidor> createState() => _PaginaSelecionarCompetidorState();
}

class _PaginaSelecionarCompetidorState extends State<PaginaSelecionarCompetidor> {
  static const int _tamanhoPagina = 20;

  final TextEditingController _controllerBusca = TextEditingController();
  final FocusNode _focusBusca = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final Set<String> _competidoresExpandidos = <String>{};

  Timer? _debounce;
  bool _carregando = false;
  bool _carregouInicial = false;
  bool _carregandoMais = false;
  int _paginaAtual = 1;
  bool _temMaisPaginas = true;
  String _termoBuscaAtual = '';
  int _totalResultados = 0;
  List<CompetidoresModelo> _competidores = [];
  _FiltroCompetidor _filtroSelecionado = _FiltroCompetidor.todos;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_aoRolarLista);
    _buscarCompetidores();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusBusca.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controllerBusca.dispose();
    _focusBusca.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _aoRolarLista() {
    if (!_scrollController.hasClients) {
      return;
    }

    final posicao = _scrollController.position;
    final chegouPertoDoFim = posicao.pixels >= (posicao.maxScrollExtent - 180);

    if (chegouPertoDoFim) {
      _buscarCompetidores(carregarMais: true);
    }
  }

  void _onChangedBusca(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _buscarCompetidores(pesquisa: value);
    });
  }

  Future<void> _buscarCompetidores({String? pesquisa, bool carregarMais = false}) async {
    final termo = (pesquisa ?? _controllerBusca.text).trim();

    if (carregarMais) {
      if (_carregandoMais || !_temMaisPaginas || _carregando) {
        return;
      }
      setState(() {
        _carregandoMais = true;
      });
    } else {
      setState(() {
        _carregando = true;
      });
      _termoBuscaAtual = termo;
    }

    final paginaSolicitada = carregarMais ? _paginaAtual + 1 : 1;
    final filtroApi = _filtroParaApi(_filtroSelecionado);

    try {
      final usuarioProvider = context.read<UsuarioProvider>();
      final competidoresServico = context.read<CompetidoresServico>();

      final dados = widget.usarBancoCompetidores
          ? await competidoresServico.listarBancoCompetidoresPaginado(
              widget.idCabeceira,
              usuarioProvider.usuario,
              termo,
              widget.idProva,
              page: paginaSolicitada,
              limit: _tamanhoPagina,
              filtro: filtroApi,
              idsJaSelecionados: widget.idsJaSelecionados,
            )
          : await competidoresServico.listarCompetidoresPaginado(
              widget.idCabeceira,
              usuarioProvider.usuario,
              termo,
              widget.idProva,
              page: paginaSolicitada,
              limit: _tamanhoPagina,
              filtro: filtroApi,
              idsJaSelecionados: widget.idsJaSelecionados,
            );

      if (!mounted) {
        return;
      }

      setState(() {
        _competidores = carregarMais ? [..._competidores, ...dados.itens] : dados.itens;
        _carregando = false;
        _carregandoMais = false;
        _carregouInicial = true;
        _paginaAtual = dados.page;
        _temMaisPaginas = dados.hasMore;
        _totalResultados = dados.total;
        if (!carregarMais) {
          _competidoresExpandidos.clear();
        }
      });

      if (!carregarMais && dados.itens.isEmpty && termo.isNotEmpty) {
        _mostrarSnackBarTopo('Nenhum competidor encontrado para "$termo".');
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _carregando = false;
        _carregandoMais = false;
        _carregouInicial = true;
      });

      _mostrarSnackBarTopo('Não foi possível carregar os competidores.');
    }
  }

  void _selecionarCompetidor(CompetidoresModelo competidor) {
    final podeSelecionar = widget.podeSelecionar?.call(competidor) ?? true;

    if (!podeSelecionar) {
      final mensagem = widget.mensagemBloqueio?.call(competidor) ?? 'Este competidor não pode ser selecionado.';
      _mostrarSnackBarTopo(mensagem);
      return;
    }

    Navigator.of(context).pop(competidor);
  }

  bool _estaSelecionado(CompetidoresModelo competidor) {
    return widget.jaSelecionado?.call(competidor) ?? false;
  }

  bool _podeSelecionarCompetidor(CompetidoresModelo competidor) {
    return widget.podeSelecionar?.call(competidor) ?? true;
  }

  String _filtroParaApi(_FiltroCompetidor filtro) {
    switch (filtro) {
      case _FiltroCompetidor.compativeis:
        return 'compativeis';
      case _FiltroCompetidor.naoCompativeis:
        return 'nao_compativeis';
      case _FiltroCompetidor.jaSelecionados:
        return 'ja_selecionados';
      case _FiltroCompetidor.todos:
        return 'todos';
    }
  }

  void _alternarExpansao(CompetidoresModelo competidor) {
    setState(() {
      if (_competidoresExpandidos.contains(competidor.id)) {
        _competidoresExpandidos.remove(competidor.id);
      } else {
        _competidoresExpandidos.add(competidor.id);
      }
    });
  }

  void _aoTocarCompetidor(CompetidoresModelo competidor) {
    if (_podeSelecionarCompetidor(competidor)) {
      _selecionarCompetidor(competidor);
      return;
    }

    if (widget.bloquearCliqueIncompativel) {
      final mensagem = widget.mensagemBloqueio?.call(competidor) ?? 'Este competidor não pode ser selecionado.';
      _mostrarSnackBarTopo(mensagem);
      return;
    }

    _alternarExpansao(competidor);
  }

  Color? _corCard(CompetidoresModelo competidor, bool isDarkMode) {
    if (!widget.destacarCardsStatus) {
      return null;
    }

    final jaSelecionado = _estaSelecionado(competidor);

    // Verificar somatória inválida
    if (competidor.podeCorrer == false) {
      return const Color(0xFFfbe5ea);
    }

    if ((competidor.ativo == 'Não' || jaSelecionado) && competidor.id != '0') {
      return const Color(0xFFfbe5ea);
    }

    if (competidor.ativo == 'Somatoria' || competidor.ativo == 'HCMinMax') {
      return isDarkMode ? const Color.fromARGB(255, 102, 117, 128) : Colors.blue[50];
    }

    return null;
  }

  ShapeBorder _shapeCard(CompetidoresModelo competidor) {
    if (!widget.destacarCardsStatus) {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
    }

    final jaSelecionado = _estaSelecionado(competidor);

    // Verificar somatória inválida
    if (competidor.podeCorrer == false) {
      return RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      );
    }

    if ((competidor.ativo == 'Não' || jaSelecionado) && competidor.id != '0') {
      return RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      );
    }

    if (competidor.ativo == 'Somatoria' || competidor.ativo == 'HCMinMax') {
      return RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      );
    }

    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
  }

  List<String> _motivosBloqueioUnicos(CompetidoresModelo competidor, {bool removerMensagemPrincipal = false}) {
    final vistos = <String>{};
    final mensagemPrincipal = removerMensagemPrincipal ? (competidor.mensagemValidacao ?? '').trim() : '';

    final motivosBase = (competidor.motivosBloqueio ?? []).isNotEmpty ? (competidor.motivosBloqueio ?? []) : ((competidor.mensagemValidacao?.trim().isNotEmpty ?? false) ? [competidor.mensagemValidacao!.trim()] : <String>[]);

    return motivosBase.map((motivo) => motivo.trim()).where((motivo) => motivo.isNotEmpty).where((motivo) => !removerMensagemPrincipal || motivo != mensagemPrincipal).where((motivo) => vistos.add(motivo)).toList();
  }

  Widget _buildMotivosBloqueio(CompetidoresModelo competidor) {
    final motivos = _motivosBloqueioUnicos(competidor);
    if (motivos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: motivos
          .map(
            (motivo) => Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.block, size: 12, color: Colors.red),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      motivo,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  void _mostrarSnackBarTopo(String mensagem) {
    final mediaQuery = MediaQuery.of(context);
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: mediaQuery.size.height - (mediaQuery.padding.top + kToolbarHeight + 40),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final competidoresVisiveis = _competidores;
    final possuiMaisItens = _temMaisPaginas;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controllerBusca,
              focusNode: _focusBusca,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                _onChangedBusca(value);
                setState(() {});
              },
              onSubmitted: (_) => _buscarCompetidores(pesquisa: _controllerBusca.text),
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controllerBusca.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controllerBusca.clear();
                          _buscarCompetidores(pesquisa: '');
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          _buildBarraFiltros(),
          if (_carregando && _carregouInicial) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: !_carregouInicial && _carregando
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _buscarCompetidores(pesquisa: _termoBuscaAtual),
                    child: _competidores.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 80),
                              Center(
                                child: Text('Nenhum competidor disponível.'),
                              ),
                            ],
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: competidoresVisiveis.length + 1,
                            itemBuilder: (context, index) {
                              if (index >= competidoresVisiveis.length) {
                                if (_carregandoMais) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  );
                                }

                                if (possuiMaisItens) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Center(
                                      child: Text(
                                        'Role para carregar mais',
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                      ),
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      '$_totalResultados ${_totalResultados == 1 ? 'resultado' : 'resultados'} encontrados',
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                    ),
                                  ),
                                );
                              }

                              final competidor = competidoresVisiveis[index];
                              final expandido = _competidoresExpandidos.contains(competidor.id);
                              final podeSelecionar = _podeSelecionarCompetidor(competidor);
                              final jaSelecionado = _estaSelecionado(competidor);
                              final statusColor = jaSelecionado ? Colors.orange : (competidor.podeCorrer == false ? Colors.red : Colors.green);
                              final statusTexto = jaSelecionado ? 'Já selecionado' : (competidor.podeCorrer == false ? 'Não compatível' : 'Compatível');

                              return Card(
                                elevation: 2,
                                color: _corCard(competidor, isDarkMode),
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                shape: _shapeCard(competidor),
                                child: Column(
                                  children: [
                                    InkWell(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8), bottom: Radius.circular(8)),
                                      onTap: () => _aoTocarCompetidor(competidor),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 56,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 2),
                                                child: Text(
                                                  competidor.id,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    competidor.nome,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: jaSelecionado ? Theme.of(context).colorScheme.onSurface : (isDarkMode ? Colors.white : null),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    competidor.apelido,
                                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 13),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  if (competidor.hccabeceira != null && competidor.hccabeceira!.isNotEmpty && competidor.hcpezeiro != null && competidor.hcpezeiro!.isNotEmpty)
                                                    Text(
                                                      'HC C: ${competidor.hccabeceira!} | HC P: ${competidor.hcpezeiro!}',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w600,
                                                        color: isDarkMode ? Colors.white70 : Colors.black87,
                                                      ),
                                                    ),
                                                  if (competidor.nomeCidade.isNotEmpty)
                                                    Text(
                                                      '${competidor.nomeCidade} - ${competidor.siglaEstado}',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        color: isDarkMode ? Colors.white70 : const Color.fromARGB(255, 89, 89, 89),
                                                      ),
                                                    ),
                                                  const SizedBox(height: 8),
                                                  Wrap(
                                                    spacing: 8,
                                                    runSpacing: 6,
                                                    children: [
                                                      if (competidor.somaDupla != null && competidor.somaDupla!.isNotEmpty)
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                          decoration: BoxDecoration(
                                                            color: statusColor.withValues(alpha: 0.12),
                                                            borderRadius: BorderRadius.circular(999),
                                                          ),
                                                          child: Text(
                                                            'Soma ${competidor.somaDupla}',
                                                            style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: statusColor.withValues(alpha: 0.12),
                                                          borderRadius: BorderRadius.circular(999),
                                                        ),
                                                        child: Text(
                                                          statusTexto,
                                                          style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Icon(
                                              podeSelecionar ? Icons.check_circle_outline : (expandido ? Icons.expand_less : Icons.expand_more),
                                              color: podeSelecionar ? Colors.green : Colors.grey.shade600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    AnimatedCrossFade(
                                      firstChild: const SizedBox.shrink(),
                                      secondChild: Padding(
                                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (competidor.hccabeceira != null && competidor.hccabeceira!.isNotEmpty && competidor.hcpezeiro != null && competidor.hcpezeiro!.isNotEmpty)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'HC competidor: ${competidor.hccabeceira!} (cab) - ${competidor.hcpezeiro!} (pé)',
                                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                                                ),
                                              ),
                                            if (competidor.hccabeceiraParceiro != null && competidor.hcpezeiroParceiro != null && competidor.somaDupla != null && competidor.somatoriProva != null) ...[
                                              const SizedBox(height: 8),
                                              Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: competidor.podeCorrer == true ? (isDarkMode ? Colors.green.shade900.withValues(alpha: 0.3) : Colors.green.shade50) : (isDarkMode ? Colors.red.shade900.withValues(alpha: 0.3) : Colors.red.shade50),
                                                  border: Border.all(
                                                    color: competidor.podeCorrer == true ? Colors.green : Colors.red,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Seu HC: ${competidor.hccabeceiraParceiro!} (cab) - ${competidor.hcpezeiroParceiro!} (pé)',
                                                      style: const TextStyle(fontSize: 11.5),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Wrap(
                                                      spacing: 10,
                                                      runSpacing: 4,
                                                      children: [
                                                        Text(
                                                          'Soma: ${competidor.somaDupla!}',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14,
                                                            color: competidor.podeCorrer == true ? Colors.green.shade700 : Colors.red.shade700,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Limite: ${competidor.somatoriProva!}',
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 12,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    if (competidor.podeCorrer == true)
                                                      const Row(
                                                        children: [
                                                          Icon(
                                                            Icons.check_circle,
                                                            size: 13,
                                                            color: Colors.green,
                                                          ),
                                                          SizedBox(width: 4),
                                                          Expanded(
                                                            child: Text(
                                                              'Dupla compatível',
                                                              style: TextStyle(
                                                                color: Colors.green,
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    if (competidor.podeCorrer != true) ...[
                                                      const SizedBox(height: 2),
                                                      const Text(
                                                        'Motivos do bloqueio',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      _buildMotivosBloqueio(competidor),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ],
                                            if (competidor.nomeCidade.isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              Text(
                                                '${competidor.nomeCidade} - ${competidor.siglaEstado}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: isDarkMode ? Colors.white : const Color.fromARGB(255, 89, 89, 89),
                                                ),
                                              ),
                                            ],
                                            if (podeSelecionar) ...[
                                              const SizedBox(height: 12),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton.icon(
                                                  onPressed: () => _selecionarCompetidor(competidor),
                                                  icon: const Icon(Icons.check),
                                                  label: const Text('Selecionar competidor'),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      crossFadeState: !podeSelecionar && expandido ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                      duration: const Duration(milliseconds: 180),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarraFiltros() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChipFiltro('Todos', _FiltroCompetidor.todos),
                const SizedBox(width: 8),
                _buildChipFiltro('Compatíveis', _FiltroCompetidor.compativeis),
                const SizedBox(width: 8),
                _buildChipFiltro('Não compatíveis', _FiltroCompetidor.naoCompativeis),
                const SizedBox(width: 8),
                _buildChipFiltro('Já selecionados', _FiltroCompetidor.jaSelecionados),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$_totalResultados ${_totalResultados == 1 ? 'resultado encontrado' : 'resultados encontrados'}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildChipFiltro(String titulo, _FiltroCompetidor filtro) {
    return ChoiceChip(
      label: Text(titulo),
      selected: _filtroSelecionado == filtro,
      onSelected: (_) {
        setState(() {
          _filtroSelecionado = filtro;
        });
        _buscarCompetidores(pesquisa: _controllerBusca.text);
      },
    );
  }
}

enum _FiltroCompetidor {
  todos,
  compativeis,
  naoCompativeis,
  jaSelecionados,
}
