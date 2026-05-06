// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/data/repositories/provas_aovivo_repository.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/ui/features/provas/widgets/pagina_lista_de_competicao.dart';
import 'package:provadelaco/ui/features/provas/widgets/pagina_ordem_de_entrada.dart' show PaginaOrdemDeEntrada;
import 'package:provider/provider.dart';

class PaginaAoVivoArgumentos {
  final String idEvento;
  final String idEmpresa;
  final String? idListaCompeticao;
  final String? nomeProva;

  PaginaAoVivoArgumentos({
    required this.idEvento,
    required this.idEmpresa,
    this.idListaCompeticao,
    this.nomeProva,
  });
}

class PaginaAoVivo extends StatefulWidget {
  final PaginaAoVivoArgumentos argumentos;
  const PaginaAoVivo({super.key, required this.argumentos});

  @override
  State<PaginaAoVivo> createState() => _PaginaAoVivoState();
}

class _PaginaAoVivoState extends State<PaginaAoVivo> {
  String idListaCompeticao = '0';
  String nomeProvaSelecionada = '';

  final TextEditingController searchProvaController = TextEditingController();

  int _totalCompetidores(List<dynamic> listaCompeticao) {
    return listaCompeticao.where((item) => !(item.id.toString().startsWith('-'))).fold<int>(0, (acc, item) => acc + (item.ordemDeEntradas as List).length);
  }

  dynamic _listaSelecionada(List<dynamic> listaCompeticao) {
    for (final item in listaCompeticao) {
      if (item.id.toString() == idListaCompeticao) {
        return item;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provasAoVivoStore = context.read<ProvasAoVivoStore>();
      var usuarioProvider = context.read<UsuarioProvider>();
      provasAoVivoStore.listar(usuarioProvider.usuario, widget.argumentos.idEmpresa, widget.argumentos.idEvento);
    });
  }

  @override
  void dispose() {
    searchProvaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provasAoVivoStore = context.read<ProvasAoVivoStore>();
    var usuarioProvider = context.read<UsuarioProvider>();

    return Consumer<UsuarioProvider>(builder: (context, usuarioProv, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFF7F7FA),
        appBar: AppBar(
          title: const Text('Provas ao Vivo', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onSurface,
          elevation: 0,
        ),
        body: ListenableBuilder(
          listenable: provasAoVivoStore,
          builder: (context, _) {
            final evento = provasAoVivoStore.evento;
            // final listaCompeticao = provasAoVivoStore.listaCompeticao;

            if (evento == null) return const Center(child: CircularProgressIndicator());

            return RefreshIndicator(
              onRefresh: () async {
                if (idListaCompeticao == '0') {
                  await provasAoVivoStore.listar(usuarioProvider.usuario, widget.argumentos.idEmpresa, widget.argumentos.idEvento);
                }
                // If idListaCompeticao != '0', the PaginaOrdemDeEntrada handles its own data/refresh or we can trigger it differently
                // But since PaginaOrdemDeEntrada has its own RefreshIndicator, we should probably disable this one when inside?
                // Or maybe this Scaffold RefreshIndicator is fine for the main list only.
                // However, the structure has RefreshIndicator wrapping everything.
                // Let's keep it simple for now and only refresh main list here.
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.45)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              FilledButton.tonalIcon(
                                onPressed: () {
                                  if (idListaCompeticao == '0') {
                                    Navigator.pop(context);
                                  } else {
                                    setState(() => idListaCompeticao = '0');
                                  }
                                },
                                icon: const Icon(Icons.arrow_back_ios_new, size: 14),
                                label: Text(idListaCompeticao == '0' ? 'Voltar' : 'Ver listas'),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  evento.nomeEvento,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(
                                avatar: const Icon(Icons.calendar_today, size: 16),
                                label: Text(DateFormat('dd/MM/yyyy', 'pt_BR').format(DateTime.parse(evento.dataEvento))),
                              ),
                              Chip(
                                avatar: const Icon(Icons.groups_2_outlined, size: 16),
                                label: Text('${_totalCompetidores(provasAoVivoStore.listaCompeticao)} competidores'),
                              ),
                              if (idListaCompeticao != '0' && _listaSelecionada(provasAoVivoStore.listaCompeticao) != null)
                                Chip(
                                  avatar: const Icon(Icons.flag_outlined, size: 16),
                                  label: Text(_listaSelecionada(provasAoVivoStore.listaCompeticao)!.nome),
                                ),
                              if (idListaCompeticao != '0' && _listaSelecionada(provasAoVivoStore.listaCompeticao) != null)
                                Chip(
                                  avatar: const Icon(Icons.format_list_numbered, size: 16),
                                  label: Text('${_listaSelecionada(provasAoVivoStore.listaCompeticao)!.ordemDeEntradas.length} na lista'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: idListaCompeticao == '0'
                        ? PaginaListaDeCompeticao(
                            listaCompeticao: provasAoVivoStore.listaCompeticao,
                            searchText: searchProvaController.text,
                            aoSelecionar: (itemListaCompeticao) {
                              setState(() {
                                idListaCompeticao = itemListaCompeticao.id;
                                nomeProvaSelecionada = itemListaCompeticao.nome;
                              });
                            },
                            idEvento: widget.argumentos.idEvento,
                            evento: provasAoVivoStore.evento!,
                            nomesCabeceira: provasAoVivoStore.nomesCabeceira,
                          )
                        : PaginaOrdemDeEntrada(
                            idListaCompeticao: idListaCompeticao,
                            nomeProva: nomeProvaSelecionada,
                            idEmpresa: widget.argumentos.idEmpresa,
                            idEvento: widget.argumentos.idEvento,
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
