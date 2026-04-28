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
  });

  @override
  State<PaginaSelecionarCompetidor> createState() => _PaginaSelecionarCompetidorState();
}

class _PaginaSelecionarCompetidorState extends State<PaginaSelecionarCompetidor> {
  final TextEditingController _controllerBusca = TextEditingController();
  final FocusNode _focusBusca = FocusNode();

  Timer? _debounce;
  bool _carregando = false;
  bool _carregouInicial = false;
  List<CompetidoresModelo> _competidores = [];

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _onChangedBusca(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _buscarCompetidores(pesquisa: value);
    });
  }

  Future<void> _buscarCompetidores({String? pesquisa}) async {
    final termo = (pesquisa ?? _controllerBusca.text).trim();

    setState(() {
      _carregando = true;
    });

    try {
      final usuarioProvider = context.read<UsuarioProvider>();
      final competidoresServico = context.read<CompetidoresServico>();

      final dados = widget.usarBancoCompetidores ? await competidoresServico.listarBancoCompetidores(widget.idCabeceira, usuarioProvider.usuario, termo, widget.idProva) : await competidoresServico.listarCompetidores(widget.idCabeceira, usuarioProvider.usuario, termo, widget.idProva);

      if (!mounted) {
        return;
      }

      setState(() {
        _competidores = dados;
        _carregando = false;
        _carregouInicial = true;
      });

      if (dados.isEmpty && termo.isNotEmpty) {
        _mostrarSnackBarTopo('Nenhum competidor encontrado para "$termo".');
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _carregando = false;
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

  Color? _corCard(CompetidoresModelo competidor, bool isDarkMode) {
    if (!widget.destacarCardsStatus) {
      return null;
    }

    final jaSelecionado = _estaSelecionado(competidor);

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

  Widget? _trailingStatus(CompetidoresModelo competidor) {
    if (!widget.destacarCardsStatus) {
      return null;
    }

    if (competidor.ativo == 'Não') {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Competidor já'),
          Text('Fez todas as inscrições'),
        ],
      );
    }

    if (competidor.ativo == 'Somatoria') {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('HandiCap do Competidor'),
          Text('Estoura a somatória'),
        ],
      );
    }

    if (competidor.ativo == 'HCMinMax') {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('HandiCap do Competidor'),
          Text('Não é compatível com a prova'),
        ],
      );
    }

    return null;
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
              onChanged: _onChangedBusca,
              onSubmitted: (_) => _buscarCompetidores(),
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
          if (_carregando && _carregouInicial) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: !_carregouInicial && _carregando
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _buscarCompetidores(),
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
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: _competidores.length,
                            itemBuilder: (context, index) {
                              final competidor = _competidores[index];

                              return Card(
                                elevation: 2,
                                color: _corCard(competidor, isDarkMode),
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                shape: _shapeCard(competidor),
                                child: ListTile(
                                  onTap: () => _selecionarCompetidor(competidor),
                                  leading: Text(competidor.id),
                                  trailing: _trailingStatus(competidor),
                                  title: Text(
                                    competidor.nome,
                                    style: TextStyle(
                                      color: _estaSelecionado(competidor) ? Theme.of(context).colorScheme.onSurface : (isDarkMode ? Colors.white : null),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        competidor.apelido,
                                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                      ),
                                      if (competidor.hccabeceira != null && competidor.hccabeceira!.isNotEmpty && competidor.hcpezeiro != null && competidor.hcpezeiro!.isNotEmpty)
                                        Text(
                                          'Cabeça: ${competidor.hccabeceira!} - Pé: ${competidor.hcpezeiro!}',
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      if (competidor.nomeCidade.isNotEmpty)
                                        Text(
                                          '${competidor.nomeCidade} - ${competidor.siglaEstado}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: isDarkMode ? Colors.white : const Color.fromARGB(255, 89, 89, 89),
                                          ),
                                        ),
                                    ],
                                  ),
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
}
