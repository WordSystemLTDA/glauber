import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

class ModalAdicionarAvulsa extends StatefulWidget {
  final Function(int quantidade) adicionarNoCarrinho;
  final ProvaModelo prova;
  final List<ProvaModelo> provasCarrinho;

  const ModalAdicionarAvulsa({
    super.key,
    required this.adicionarNoCarrinho,
    required this.prova,
    required this.provasCarrinho,
  });

  @override
  State<ModalAdicionarAvulsa> createState() => _ModalAdicionarAvulsaState();
}

class _ModalAdicionarAvulsaState extends State<ModalAdicionarAvulsa> {
  int quantidade = 0;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      if (widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).isEmpty) {
        quantidade = int.parse(widget.prova.quantMinima);
      } else {
        quantidade = widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).length;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SizedBox(
        width: width,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: IconButton(
                        color: quantidade > int.parse(widget.prova.quantMinima) ? Colors.red : Colors.grey,
                        iconSize: 34,
                        onPressed: () {
                          if (quantidade > int.parse(widget.prova.quantMinima)) {
                            setState(() {
                              quantidade = quantidade - 1;
                            });
                          } else if (widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).isNotEmpty) {
                            widget.adicionarNoCarrinho(0);
                          }
                        },
                        icon: quantidade > int.parse(widget.prova.quantMinima) ||
                                widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).isEmpty
                            ? const Icon(Icons.remove_circle_outline_outlined)
                            : const Icon(Icons.delete_outline_outlined, color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        quantidade.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        color: quantidade < int.parse(widget.prova.quantMaxima) ? Colors.green : Colors.grey,
                        iconSize: 34,
                        onPressed: () {
                          if (quantidade < int.parse(widget.prova.quantMaxima)) {
                            setState(() {
                              quantidade = quantidade + 1;
                            });
                          }
                        },
                        icon: const Icon(Icons.add_circle_outline_outlined),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: quantidade == 0
                        ? null
                        : () {
                            widget.adicionarNoCarrinho(quantidade);
                          },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(quantidade == 0 ? Colors.grey : Colors.green),
                      foregroundColor: const MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: Text(quantidade == 0
                        ? 'Adicione alguma quantidade'
                        : 'Salvar $quantidade ${quantidade == 1 ? 'item' : 'itens'} ${(double.parse(widget.prova.valor) * quantidade).obterReal()}'),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
