import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/competidores_servico.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/ui/features/competidores/widgets/card_competidor.dart';
import 'package:provider/provider.dart';

class PaginaCompetidores extends StatefulWidget {
  const PaginaCompetidores({super.key});

  @override
  State<PaginaCompetidores> createState() => _PaginaCompetidoresState();
}

class _PaginaCompetidoresState extends State<PaginaCompetidores> {
  final TextEditingController _searchController = TextEditingController();
  List<CompetidoresModelo> _lista = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscar('');
  }

  Future<void> _buscar(String pesquisa) async {
    setState(() {
      _carregando = true;
    });

    final servico = context.read<CompetidoresServico>();
    final usuario = context.read<UsuarioProvider>().usuario;

    final dados = await servico.listarCompetidores(null, usuario, pesquisa, '');

    if (mounted) {
      setState(() {
        _lista = dados;
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competidores'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar por nome ou apelido',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onSubmitted: (value) => _buscar(value),
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _lista.isEmpty
                    ? const Center(child: Text('Nenhum competidor encontrado'))
                    : RefreshIndicator(
                        onRefresh: () => _buscar(_searchController.text),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          itemCount: _lista.length,
                          itemBuilder: (context, index) {
                            final item = _lista[index];
                            return CardCompetidor(item: item);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
