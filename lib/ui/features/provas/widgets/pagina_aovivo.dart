// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
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
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
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
                  // header image
                  Container(
                    height: 180,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                            child: CachedNetworkImage(
                              imageUrl: evento.foto,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey.shade300),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        // Gradient Overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.1),
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(evento.nomeEvento,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    height: 1.1,
                                  )),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: Colors.white70, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    DateFormat('dd ' 'MMM' ' yyyy', 'pt_BR').format(DateTime.parse(evento.dataEvento)).toUpperCase(),
                                    style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Material(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                if (idListaCompeticao == '0') {
                                  Navigator.pop(context);
                                } else {
                                  setState(() => idListaCompeticao = '0');
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      idListaCompeticao == '0' ? 'Voltar' : 'Ver Listas',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
