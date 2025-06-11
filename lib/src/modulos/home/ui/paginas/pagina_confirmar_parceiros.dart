import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/confirmar_parceiros_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/servicos/home_servico.dart';
import 'package:provider/provider.dart';

class PaginaConfirmarParceiros extends StatefulWidget {
  const PaginaConfirmarParceiros({super.key});

  @override
  State<PaginaConfirmarParceiros> createState() => _PaginaConfirmarParceirosState();
}

class _PaginaConfirmarParceirosState extends State<PaginaConfirmarParceiros> with SingleTickerProviderStateMixin {
  RetornoConfirmarParceirosModelo? dados;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    listar();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void listar() async {
    var servico = context.read<HomeServico>();
    var usuarioProvider = context.read<UsuarioProvider>();

    dados = await servico.listarConfirmarParceiros('4');
    setState(() {});
  }

  void recusarInscricao(String nome) {
    print('$nome foi recusado e enviado para sorteio.');
  }

  void confirmarInscricao(String nome) {
    print('$nome foi confirmado e vinculado à venda.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Parceiros'),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Laçar Pé'),
            Tab(text: 'Laçar Cabeça'),
          ],
        ),
      ),
      body: dados == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildListView('1'),
                _buildListView('2'),
              ],
            ),
    );
  }

  Widget _buildListView(String modalidade) {
    // Filtra provas e parceiros pela modalidade
    final provasFiltradas = (modalidade == '1' ? (dados?.lacarpe ?? []) : (dados?.lacarcabeca ?? []))
        .map((prova) {
          final parceirosFiltrados = prova.parceiros;

          if (parceirosFiltrados.isEmpty) return null;
          return ExpansionTile(
            title: Text(prova.nomeprova),
            initiallyExpanded: true,
            children: parceirosFiltrados.map((parceiro) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nome: ${parceiro.nomeparceiro}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Cidade: ${parceiro.nomecidade}'),
                      Text('Laço: ${parceiro.modalidade}'),
                      Text('Handicap: ${parceiro.hccabeceira}'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => recusarInscricao(parceiro.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Recusar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => confirmarInscricao(parceiro.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Confirmar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        })
        .whereType<ExpansionTile>()
        .toList();

    if (provasFiltradas.isEmpty) {
      return const Center(child: Text('Nenhum parceiro encontrado.'));
    }

    return ListView(children: provasFiltradas);
  }
}
