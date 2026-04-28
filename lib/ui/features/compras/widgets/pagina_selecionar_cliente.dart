import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/compras_servico.dart';
import 'package:provadelaco/domain/models/clientes/clientes.dart';
import 'package:provider/provider.dart';

class PaginaSelecionarCliente extends StatefulWidget {
  const PaginaSelecionarCliente({super.key});

  @override
  State<PaginaSelecionarCliente> createState() => _PaginaSelecionarClienteState();
}

class _PaginaSelecionarClienteState extends State<PaginaSelecionarCliente> {
  final TextEditingController _controllerBusca = TextEditingController();
  final FocusNode _focusBusca = FocusNode();

  Timer? _debounce;
  bool _carregando = false;
  bool _carregouInicial = false;
  List<ClientesModelo> _clientes = [];

  @override
  void initState() {
    super.initState();
    _buscarClientes();

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
      _buscarClientes(pesquisa: value);
    });
  }

  Future<void> _buscarClientes({String? pesquisa}) async {
    final termo = (pesquisa ?? _controllerBusca.text).trim();

    setState(() {
      _carregando = true;
    });

    try {
      final comprasServico = context.read<ComprasServico>();
      final dados = await comprasServico.listarClientesNormal(termo);

      if (!mounted) {
        return;
      }

      setState(() {
        _clientes = dados;
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
        title: const Text('Selecionar cliente'),
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
              onSubmitted: (_) => _buscarClientes(),
              decoration: InputDecoration(
                hintText: 'Pesquisar cliente',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controllerBusca.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controllerBusca.clear();
                          setState(() {});
                          _buscarClientes(pesquisa: '');
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
                    onRefresh: () => _buscarClientes(),
                    child: _clientes.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 80),
                              Center(child: Text('Nenhum cliente encontrado.')),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: _clientes.length,
                            itemBuilder: (context, index) {
                              final cliente = _clientes[index];

                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                child: ListTile(
                                  onTap: () => Navigator.of(context).pop(cliente),
                                  leading: Text(cliente.id),
                                  title: Text(cliente.nome),
                                  subtitle: Text(
                                    cliente.apelido,
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
