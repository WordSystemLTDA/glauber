import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/cidade_servico.dart';
import 'package:provadelaco/domain/models/cidade/cidade.dart';
import 'package:provider/provider.dart';

class PaginaSelecionarCidade extends StatefulWidget {
  const PaginaSelecionarCidade({super.key});

  @override
  State<PaginaSelecionarCidade> createState() => _PaginaSelecionarCidadeState();
}

class _PaginaSelecionarCidadeState extends State<PaginaSelecionarCidade> {
  final TextEditingController _controllerBusca = TextEditingController();
  final FocusNode _focusBusca = FocusNode();

  Timer? _debounce;
  bool _carregando = false;
  bool _carregouInicial = false;
  List<CidadeModelo> _cidades = [];

  @override
  void initState() {
    super.initState();
    _buscarCidades();

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
    setState(() {});

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _buscarCidades(pesquisa: value);
    });
  }

  Future<void> _buscarCidades({String? pesquisa}) async {
    final termo = (pesquisa ?? _controllerBusca.text).trim();

    setState(() {
      _carregando = true;
    });

    try {
      final cidadeServico = context.read<CidadeServico>();
      final dados = await cidadeServico.listar(termo);

      if (!mounted) {
        return;
      }

      setState(() {
        _cidades = dados;
        _carregando = false;
        _carregouInicial = true;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _carregando = false;
        _carregouInicial = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar cidade'),
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
              onSubmitted: (_) => _buscarCidades(),
              decoration: InputDecoration(
                hintText: 'Pesquisar cidade',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controllerBusca.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controllerBusca.clear();
                          setState(() {});
                          _buscarCidades(pesquisa: '');
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
                    onRefresh: () => _buscarCidades(),
                    child: _cidades.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 80),
                              Center(child: Text('Nenhuma cidade encontrada.')),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: _cidades.length,
                            itemBuilder: (context, index) {
                              final cidade = _cidades[index];

                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                child: ListTile(
                                  onTap: () => Navigator.of(context).pop(cidade),
                                  leading: const Icon(Icons.location_city_outlined),
                                  title: Text(cidade.nome),
                                  subtitle: Text(
                                    cidade.nomeUf,
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
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
