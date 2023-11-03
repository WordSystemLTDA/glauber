import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/provas/interator/estados/provas_estado.dart';
import 'package:glauber/src/modulos/provas/interator/stores/provas_store.dart';
import 'package:glauber/src/modulos/provas/ui/widgets/card_provas.dart';
import 'package:provider/provider.dart';

class PaginaProvas extends StatefulWidget {
  final String idEvento;
  const PaginaProvas({super.key, required this.idEvento});

  @override
  State<PaginaProvas> createState() => _PaginaProvasState();
}

class _PaginaProvasState extends State<PaginaProvas> {
  @override
  Widget build(BuildContext context) {
    var provasStore = context.read<ProvasStore>();

    return Scaffold(
      body: ValueListenableBuilder<ProvasEstado>(
        valueListenable: provasStore,
        builder: (context, state, _) {
          if (state is ProvasCarregando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProvasCarregado) {
            return Column(
              children: [
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      Image.network(
                        state.evento!.foto,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              end: const Alignment(0.0, -0.6),
                              begin: const Alignment(0.0, 0),
                              colors: <Color>[const Color(0x8A000000), Colors.black12.withOpacity(0.0)],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // const Text('CASA DE SHOWS', style: TextStyle(color: Colors.white, fontSize: 16)),
                              Text(state.evento!.nomeEvento, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                              Text(state.evento!.dataEvento, style: const TextStyle(color: Colors.white, fontSize: 14)),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: const BoxDecoration(color: Color.fromARGB(106, 0, 0, 0), borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: IconButton(
                              icon: const Row(
                                children: [
                                  Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                                  Text('Voltar', style: TextStyle(color: Colors.white, fontSize: 16)),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.location_on_outlined),
                        label: const Text('Localização'),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      ActionChip(
                        avatar: const Icon(Icons.payment_outlined),
                        label: const Text('Pagamentos'),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      ActionChip(
                        avatar: const Icon(Icons.warning_amber),
                        label: const Text('Termos de Uso'),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                if (state.provas.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Escolha sua Prova',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        provasStore.listar(widget.idEvento);
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: state.provas.length,
                        itemBuilder: (context, index) {
                          var prova = state.provas[index];

                          return CardProvas(prova: prova, idEvento: widget.idEvento);
                        },
                      ),
                    ),
                  ),
                ],
                if (state.provas.isEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Não há provas para esse evento.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ],
            );
          }

          return const Text('Erro ao listar Provas.');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provasStore = context.read<ProvasStore>();
      provasStore.listar(widget.idEvento);
    });
  }
}
