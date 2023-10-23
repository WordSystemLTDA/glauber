import 'package:flutter/material.dart';

class PaginaPagamentosInscricao extends StatefulWidget {
  const PaginaPagamentosInscricao({super.key});

  @override
  State<PaginaPagamentosInscricao> createState() => _PaginaPagamentosInscricaoState();
}

class _PaginaPagamentosInscricaoState extends State<PaginaPagamentosInscricao> {
  bool? concorda = false;
  int metodoPagamento = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamentos'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            const SizedBox(width: double.infinity, height: 20),
            const Text('Método de pagamento'),
            const SizedBox(width: double.infinity, height: 10),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: 1,
                  label: Text('Pix'),
                ),
              ],
              selected: {metodoPagamento},
              onSelectionChanged: (novoValor) {
                setState(() {
                  metodoPagamento = novoValor.first;
                });
              },
            )

            // CupertinoSlidingSegmentedControl(
            //     groupValue: segmentedControlGroupValue,
            //     children: myTabs,
            //     onValueChanged: (i) {
            //       setState(() {
            //         segmentedControlGroupValue = i;
            //       });
            //     }),
          ]),
          Column(children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Total a pagar: '),
                    ElevatedButton(onPressed: () {}, child: const Text('Concluir')),
                  ]),
                ),
                const SizedBox(width: 10)
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: concorda,
                  onChanged: (novoValor) {
                    setState(() {
                      concorda = novoValor;
                    });
                  },
                ),
                const Text('Li e concordo com os '),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const Dialog(
                          child: SizedBox(
                            height: 230,
                            width: 300,
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Termos de uso',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
