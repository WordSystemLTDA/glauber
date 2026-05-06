import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/prova_parceiros_modelo.dart';

class CardOrdemDeEntradaProva extends StatefulWidget {
  final ProvaParceirosModelos item;
  final bool mostrarOpcoes;
  final bool selecionado;
  final String nomeprova;

  const CardOrdemDeEntradaProva({
    super.key,
    required this.item,
    required this.mostrarOpcoes,
    required this.selecionado,
    required this.nomeprova,
  });

  @override
  State<CardOrdemDeEntradaProva> createState() => _CardOrdemDeEntradaProvaState();
}

class _CardOrdemDeEntradaProvaState extends State<CardOrdemDeEntradaProva> {
  @override
  Widget build(BuildContext context) {
    var itemParceiro = widget.item;
    final estiloNomeDupla = const TextStyle(fontSize: 14, fontWeight: FontWeight.w700);

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
        border: widget.selecionado ? Border.all(color: Colors.green.shade600, width: 1.5) : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Leading avatar / badge
                // Container(
                //   width: 48,
                //   height: 48,
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                //     shape: BoxShape.circle,
                //   ),
                //   child: Center(
                //     child: Text(
                //       (itemParceiro.nomeClienteCabeceira.isNotEmpty ? itemParceiro.nomeClienteCabeceira[0] : '?').toUpperCase(),
                //       style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 12),

                // Main content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${itemParceiro.nomeClienteCabeceira.toUpperCase()}${itemParceiro.sorteiocabeceira.contains('Sim') ? ' (SORTEIO)' : ''}",
                              style: estiloNomeDupla,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${itemParceiro.nomeClientePezeiro.toUpperCase()}${itemParceiro.sorteiopezeiro.contains('Sim') ? ' (SORTEIO)' : ''}",
                        style: estiloNomeDupla,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          if (itemParceiro.prev.isNotEmpty) Chip(label: Text('PREV: ${itemParceiro.prev}')),
                          if (itemParceiro.boi1 != '') Chip(label: Text('1: ${itemParceiro.boi1}')),
                          if (itemParceiro.boi2 != '') Chip(label: Text('2: ${itemParceiro.boi2}')),
                          if (itemParceiro.boi3 != '') Chip(label: Text('3: ${itemParceiro.boi3}')),
                          if (itemParceiro.boi4 != '') Chip(label: Text('4: ${itemParceiro.boi4}')),
                          if (itemParceiro.finalT != '') Chip(label: Text('F: ${itemParceiro.finalT}')),
                          if (itemParceiro.medio != '') Chip(label: Text('M: ${double.parse(itemParceiro.medio).toStringAsFixed(2)}')),
                        ],
                      ),
                    ],
                  ),
                ),

                // Trailing info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Inscrição', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    Text(itemParceiro.numeroDaInscricao, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        itemParceiro.somatoria,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.nomeprova == 'CLASSIFICAÇÃO FINAL' ? 'Classificação: ${itemParceiro.ranking}' : 'Ranking: ${itemParceiro.classificacao}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
