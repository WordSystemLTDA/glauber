import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/compras/interator/provedor/compras_provedor.dart';
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

  bool salvandoInformacoes = false;

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

    dados = await servico.listarConfirmarParceiros(usuarioProvider.usuario?.id ?? '0');
    setState(() {});
  }

  void listarCompras({bool? resetar}) {
    var comprasStore = context.read<ComprasProvedor>();
    var usuarioProvider = context.read<UsuarioProvider>();

    if (usuarioProvider.usuario != null) {
      comprasStore.listar(usuarioProvider.usuario, resetar ?? false);
    }
  }

  void recusarInscricao(ParceirosModelo parceiro) {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Recusar Inscrição'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Deseja realmente recusar a inscrição de ${parceiro.nomeparceiro}?'),
                const SizedBox(height: 10),
                const Text(
                  'Após recusar, a inscrição com esse parceiro irá para sorteio automaticamente.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(contextDialog).pop();
                },
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () async {
                  if (salvandoInformacoes) {
                    return;
                  }

                  setStateDialog(() {
                    salvandoInformacoes = true;
                  });

                  await recusarParceiro(contextDialog, parceiro);

                  // setStateDialog(() {
                  //   salvandoInformacoes = false;
                  // });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: salvandoInformacoes
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Recusar'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> recusarParceiro(BuildContext contextDialog, ParceirosModelo parceiro) async {
    var servico = context.read<HomeServico>();
    var usuarioProvider = context.read<UsuarioProvider>();

    var resultado = await servico.recusarParceiro(parceiro, usuarioProvider.usuario?.id ?? '0');

    if (resultado.sucesso) {
      if (contextDialog.mounted) {
        Navigator.of(contextDialog).pop();
      }

      if (mounted) {
        listarCompras(resetar: true);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(resultado.mensagem),
          backgroundColor: Colors.green,
        ));

        Navigator.of(context).pop();
      }
    } else {
      if (contextDialog.mounted) {
        Navigator.of(contextDialog).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro: ${resultado.mensagem}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> confirmarParceiro(BuildContext contextDialog, ParceirosModelo parceiro, ConfirmarParceirosModelo prova) async {
    var servico = context.read<HomeServico>();
    var usuarioProvider = context.read<UsuarioProvider>();

    var resultado = await servico.confirmarParceiro(parceiro, prova.id, usuarioProvider.usuario?.id ?? '0', usuarioProvider.usuario);

    if (resultado.sucesso) {
      if (contextDialog.mounted) {
        Navigator.of(contextDialog).pop();
      }

      if (mounted) {
        listarCompras(resetar: true);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(resultado.mensagem),
          backgroundColor: Colors.green,
        ));

        Navigator.of(context).pop();
      }
    } else {
      if (contextDialog.mounted) {
        Navigator.of(contextDialog).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro: ${resultado.mensagem}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void confirmarInscricao(ParceirosModelo parceiro, ConfirmarParceirosModelo prova) {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Confirmar Inscrição'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Deseja realmente confirmar a inscrição de ${parceiro.nomeparceiro}?'),
                const SizedBox(height: 10),
                Text(
                  'Você vai laçar: ${parceiro.modalidade == '1' ? 'PÉ' : 'CABEÇA'}',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text('Parceiro: ${parceiro.nomeparceiro}'),
                Text('Cidade: ${parceiro.nomecidade}'),
                Text('Laço: ${parceiro.modalidade == '1' ? 'Cabeça' : 'Pé'}'),
                Text('HC Cabeceira: ${parceiro.hccabeceira}'),
                Text('HC Pezeiro: ${parceiro.hcpezeiro}'),
                const SizedBox(height: 10),
                const Text(
                  'Após confirmar, o parceiro será adicionado à sua lista de parceiros.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(contextDialog).pop();
                },
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () async {
                  if (salvandoInformacoes) {
                    return;
                  }

                  setStateDialog(() {
                    salvandoInformacoes = true;
                  });

                  await confirmarParceiro(contextDialog, parceiro, prova);

                  // setStateDialog(() {
                  //   salvandoInformacoes = false;
                  // });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: salvandoInformacoes
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Confirmar'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Parceiros'),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: 'Para laçar Pé (${(dados?.lacarpe ?? []).length})'),
            Tab(text: 'Para laçar Cabeça (${(dados?.lacarcabeca ?? []).length})'),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nome: ${parceiro.nomeparceiro}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Cidade: ${parceiro.nomecidade}'),
                          Text('Laço: ${parceiro.modalidade == '1' ? 'Cabeça' : 'Pé'}'),
                          Text('HC Cabeceira: ${parceiro.hccabeceira}'),
                          Text('HC Pezeiro: ${parceiro.hcpezeiro}'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () => recusarInscricao(parceiro),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Recusar'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () => confirmarInscricao(parceiro, prova),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Confirmar'),
                            ),
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
