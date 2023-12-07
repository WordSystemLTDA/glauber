import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/ordem_de_entrada_modelo.dart';
import 'package:provider/provider.dart';

class CardOrdemDeEntrada extends StatefulWidget {
  final OrdemDeEntradaModelo item;

  const CardOrdemDeEntrada({
    super.key,
    required this.item,
  });

  @override
  State<CardOrdemDeEntrada> createState() => _CardOrdemDeEntradaState();
}

class _CardOrdemDeEntradaState extends State<CardOrdemDeEntrada> {
  double tamanhoCard = 120;

  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    var width = MediaQuery.of(context).size.width;
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
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Parceiros de ${item.nomeCliente}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          item.nomeCabeceira,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 10),
                        Text("Sua somatória: ${item.idCabeceira == '1' ? usuarioProvider.usuario!.hcCabeceira! : usuarioProvider.usuario!.hcPezeiro!}"),
                        const SizedBox(height: 20),
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

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minVerticalPadding: 0,
                                  // visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                  title: Text(
                                    itemParceiro.nomeCliente,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text("Inscrição: ${itemParceiro.numeroDaInscricao}"),
                                  trailing: Text(
                                    itemParceiro.somatoria,
                                    style: const TextStyle(fontSize: 16),
                                  ),
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
                    Container(
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
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.70,
                            child: Text(
                              item.nomeEvento,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.70,
                            child: Text(
                              item.nomeProva,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 15),
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
