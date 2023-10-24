import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/uteis.dart';

class PaginaPagamentosInscricao extends StatefulWidget {
  const PaginaPagamentosInscricao({super.key});

  @override
  State<PaginaPagamentosInscricao> createState() => _PaginaPagamentosInscricaoState();
}

class _PaginaPagamentosInscricaoState extends State<PaginaPagamentosInscricao> {
  bool concorda = false;
  int metodoPagamento = 1;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar Compra'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(width: double.infinity, height: 20),
                const Text(
                  'Método de pagamento',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: double.infinity, height: 10),
                SizedBox(
                  width: width,
                  child: SegmentedButton(
                    segments: const [
                      ButtonSegment(
                        value: 1,
                        label: Text(
                          'Pix',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ButtonSegment(
                        value: 2,
                        label: Text(
                          'Mercado',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ButtonSegment(
                        value: 3,
                        label: Text(
                          'Paypal',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ButtonSegment(
                        value: 4,
                        label: Text(
                          'Nubank',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    selected: {metodoPagamento},
                    showSelectedIcon: false,
                    onSelectionChanged: (novoValor) {
                      setState(() {
                        metodoPagamento = novoValor.first;
                      });
                    },
                  ),
                )
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      Utils.coverterEmReal.format(45),
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Taxa Admin.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "+ ${Utils.coverterEmReal.format(5)}",
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Total: ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                Utils.coverterEmReal.format(50),
                                style: const TextStyle(fontSize: 16, color: Colors.green),
                              ),
                            ],
                          ),
                          AbsorbPointer(
                            absorbing: !concorda,
                            child: SizedBox(
                              width: 150,
                              height: 50,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Concluir',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    setState(() {
                      concorda = concorda ? false : true;
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: concorda,
                        onChanged: (novoValor) {
                          setState(() {
                            concorda = novoValor!;
                          });
                        },
                      ),
                      SizedBox(
                        width: width - 100,
                        child: RichText(
                          textAlign: TextAlign.left,
                          softWrap: true,
                          text: TextSpan(
                            text: "Li e aceito o contrato, a politica de privacidade e os ",
                            style: Theme.of(context).textTheme.titleSmall,
                            children: <TextSpan>[
                              TextSpan(
                                text: ' Termos de uso',
                                style: const TextStyle(color: Colors.red),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
