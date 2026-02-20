// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/evento/evento.dart';
import 'package:provadelaco/domain/models/modelo_prova_ao_vivo.dart';
import 'package:provadelaco/domain/models/nomes_cabeceira_modelo.dart';

class CardListaCompeticao extends StatefulWidget {
  final ModeloProvaAoVivo item;
  final EventoModelo evento;
  // final bool verificando;
  final List<ModeloProvaAoVivo> provasCarrinho;
  final List<NomesCabeceiraModelo>? nomesCabeceira;
  final String idEvento;

  final Function(ModeloProvaAoVivo item)? aoSelecionar;

  const CardListaCompeticao({
    super.key,
    required this.item,
    required this.idEvento,
    // required this.verificando,
    required this.nomesCabeceira,
    required this.evento,
    required this.provasCarrinho,
    this.aoSelecionar,
  });

  @override
  State<CardListaCompeticao> createState() => _CardListaCompeticaoState();
}

class _CardListaCompeticaoState extends State<CardListaCompeticao> {
  double tamanhoCard = 110;
  bool verificando = false;

  Color coresJaComprou(ModeloProvaAoVivo prova) {
    return Colors.green;
  }

  void aoClicarNoCard(ModeloProvaAoVivo item) {
    if (widget.aoSelecionar != null) {
      widget.aoSelecionar!(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    // var width = MediaQuery.of(context).size.width;

    // bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => aoClicarNoCard(item),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon or Badge
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      item.ordemDeEntradas.length.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.people_outline, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            "${item.ordemDeEntradas.length} INSCRIÇÕES",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Trailing Action
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.deepPurple.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 3))]),
                  child: const Row(
                    children: [
                      Text(
                        "Ver",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
