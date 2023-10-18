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
      body: Column(children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(color: Colors.red),
        ),
        Expanded(
          child: ListView(children: [
            const Padding(padding: EdgeInsets.all(10), child: Text('Escolha seu ingresso', style: TextStyle(fontSize: 15))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/pagamentos_inscricao');
                },
                child: const Card(
                  elevation: 12,
                  child: Padding(
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
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              // height: double.maxFinite,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                color: Colors.blue,
              ),
            ),
          ]),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
