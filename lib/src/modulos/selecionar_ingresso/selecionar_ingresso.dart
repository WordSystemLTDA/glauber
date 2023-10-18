import 'package:flutter/material.dart';

class SelecionarIngresso extends StatefulWidget {
  const SelecionarIngresso({super.key});

  @override
  State<SelecionarIngresso> createState() => _SelecionarIngressoState();
}

class _SelecionarIngressoState extends State<SelecionarIngresso> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                Image.network(
                  'https://www.tenhomaisdiscosqueamigos.com/wp-content/uploads/2016/07/lollapalooza-brasil-2017.png',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: const BoxDecoration(color: Color.fromARGB(106, 0, 0, 0), borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: IconButton(
                      icon: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                          Text(
                            'Voltar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                const Text('Escolha seu ingresso', style: TextStyle(fontSize: 15)),
                Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/pagamentos_inscricao');
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Pista', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 15),
                        Text('Valor do ingresso', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 15),
                        Text('R\$ 100,00', style: TextStyle(fontSize: 18)),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
