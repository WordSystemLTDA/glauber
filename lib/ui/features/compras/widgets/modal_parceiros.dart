import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/compras_servico.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/domain/models/compras/compras.dart';
import 'package:provadelaco/ui/features/competidores/widgets/pagina_selecionar_competidor.dart';
import 'package:provadelaco/ui/features/compras/widgets/card_parceiros_compra.dart';
import 'package:provider/provider.dart';

class ModalParceiros extends StatefulWidget {
  final String idCompra;
  final String idProva;
  final String idEvento;
  const ModalParceiros({super.key, required this.idCompra, required this.idProva, required this.idEvento});

  @override
  State<ModalParceiros> createState() => _ModalParceirosState();
}

class _ModalParceirosState extends State<ModalParceiros> {
  ComprasModelo? item;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    listarCompra();
  }

  void listarCompra() async {
    if (carregando == false) {
      setState(() {
        carregando = true;
      });
    }

    var comprasServico = context.read<ComprasServico>();

    await comprasServico.listarPorId(widget.idCompra, widget.idProva, widget.idEvento).then((value) {
      item = value;
    });

    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    if (item == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width * 0.9,
          maxHeight: height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item?.nomeEvento ?? 'Sem Prova'),
                    if (item!.parceiros.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Seus Parceiros', style: TextStyle(fontWeight: FontWeight.w700)),
                          TextButton(
                            onPressed: () async {
                              await Navigator.of(context).push<CompetidoresModelo>(
                                MaterialPageRoute(
                                  builder: (_) => PaginaSelecionarCompetidor(
                                    titulo: 'Competidores disponíveis',
                                    hintText: 'Pesquisar competidores',
                                    usarBancoCompetidores: true,
                                    idCabeceira: item!.idCabeceira,
                                    idProva: widget.idProva,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Competidores disponíveis', style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 5),
                          itemCount: item!.parceiros.length,
                          itemBuilder: (context, index) {
                            var parceiro = item!.parceiros[index];

                            return CardParceirosCompra(
                              item: item!,
                              parceiro: parceiro,
                              parceiros: item!.parceiros,
                              aoSalvar: () {
                                listarCompra();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
