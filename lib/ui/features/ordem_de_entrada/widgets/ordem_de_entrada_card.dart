import 'package:flutter/material.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/domain/models/ordem_de_entrada_modelo.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardOrdemDeEntrada extends StatefulWidget {
  final OrdemDeEntradaModelo item;
  final bool mostrarOpcoes;

  const CardOrdemDeEntrada({
    super.key,
    required this.item,
    required this.mostrarOpcoes,
  });

  @override
  State<CardOrdemDeEntrada> createState() => _CardOrdemDeEntradaState();
}

class _CardOrdemDeEntradaState extends State<CardOrdemDeEntrada> {
  @override
  Widget build(BuildContext context) {
    double tamanhoCard = widget.mostrarOpcoes ? 107 : 140;
    var item = widget.item;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var usuarioProvider = context.read<UsuarioProvider>();

    return SizedBox(
      height: tamanhoCard,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  insetPadding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  surfaceTintColor: Colors.white,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width * 0.9,
                      maxHeight: height * 0.8,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: width / 1.5,
                                child: Text(
                                  "Parceiros de ${item.nomeCliente}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(item.nomeEvento),
                              const SizedBox(height: 5),
                              Text("Seu HandiCap: ${item.idCabeceira == '2' ? usuarioProvider.usuario!.hcPezeiro : usuarioProvider.usuario!.hcCabeceira!}"),
                              const SizedBox(height: 5),
                              Text(item.nomeCabeceira),
                              const SizedBox(height: 5),
                              if (item.parceiros.isNotEmpty) ...[
                                const Divider(),
                                Flexible(
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return const Divider();
                                    },
                                    shrinkWrap: true,
                                    itemCount: item.parceiros.length,
                                    itemBuilder: (context, index) {
                                      var itemParceiro = item.parceiros[index];

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    itemParceiro.nomeCliente,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  if (itemParceiro.sorteio == '0' || itemParceiro.sorteio.isEmpty) ...[
                                                    Text("HC: ${itemParceiro.handicapCliente}, Somatória: ${itemParceiro.somatoria}"),
                                                  ],
                                                  if (itemParceiro.sorteio != '0' && itemParceiro.sorteio.isNotEmpty) ...[
                                                    Text("HC: ${itemParceiro.handicapCliente}, Somatória: ${itemParceiro.somatoria}, Extra${itemParceiro.sorteio}"),
                                                  ],
                                                  Text(itemParceiro.numeroDaInscricao, style: const TextStyle(fontSize: 16, color: Colors.red)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Wrap(
                                              spacing: 8.0, // gap between adjacent chips
                                              runSpacing: 4.0, // gap between lines
                                              alignment: WrapAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    const Text('1 BOI'),
                                                    Text(itemParceiro.boi1),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const Text('2 BOI'),
                                                    Text(itemParceiro.boi2),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const Text('3 BOI'),
                                                    Text(itemParceiro.boi3),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const Text('4 BOI'),
                                                    Text(itemParceiro.boi4),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const Text('Final'),
                                                    Text(itemParceiro.finalT),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const Text('Média'),
                                                    Text(itemParceiro.medio),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    'Ranking: ${itemParceiro.ranking}',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                              if (item.parceiros.isEmpty) ...[
                                const Divider(),
                                const Text(
                                  'Ainda não há parceiros cadastrados.',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          borderRadius: BorderRadius.circular(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    Skeleton.shade(
                      child: Container(
                        width: 5,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: const VerticalDivider(color: Colors.green, thickness: 5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.7,
                            child: Text(
                              widget.mostrarOpcoes ? item.nomeCliente : item.nomeEvento,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.70,
                            child: Text(
                              'Parceiros: ${item.parceiros.length}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          if (widget.mostrarOpcoes == false) ...[
                            SizedBox(
                              width: width * 0.70,
                              child: Text(
                                item.nomeProva,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                          SizedBox(height: widget.mostrarOpcoes ? 5 : 15),
                          Text(
                            item.nomeCabeceira,
                            style: const TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
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
