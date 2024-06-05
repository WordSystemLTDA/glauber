import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/pagamentos_modelo.dart';

class ModalPagamentosDisponiveis extends StatefulWidget {
  final List<PagamentosModelo> pagamentosDisponiveis;
  const ModalPagamentosDisponiveis({super.key, required this.pagamentosDisponiveis});

  @override
  State<ModalPagamentosDisponiveis> createState() => _ModalPagamentosDisponiveisState();
}

class _ModalPagamentosDisponiveisState extends State<ModalPagamentosDisponiveis> {
  @override
  Widget build(BuildContext context) {
    var pagamentosDisponiveis = widget.pagamentosDisponiveis;

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pagamentos Disponíveis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pagamentosDisponiveis.length,
                itemBuilder: (context, index) {
                  var item = pagamentosDisponiveis[index];

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.nome),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
