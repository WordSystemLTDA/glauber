import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/selecionar_prova/ui/widgets/card_provas.dart';

class PaginaSelecionarProva extends StatefulWidget {
  const PaginaSelecionarProva({super.key});

  @override
  State<PaginaSelecionarProva> createState() => _PaginaSelecionarProvaState();
}

class _PaginaSelecionarProvaState extends State<PaginaSelecionarProva> {
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
                  'https://i0.wp.com/surgiu.com.br/wp-content/uploads/2022/06/prova-do-laco.jpeg?resize=1024%2C1024&ssl=1',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        end: const Alignment(0.0, -0.6),
                        begin: const Alignment(0.0, 0),
                        colors: <Color>[const Color(0x8A000000), Colors.black12.withOpacity(0.0)],
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('CASA DE SHOWS', style: TextStyle(color: Colors.white, fontSize: 16)),
                        Text('Zé neto e Cristiano', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                        Text('Não abre hoje', style: TextStyle(color: Colors.white, fontSize: 14)),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: const BoxDecoration(color: Color.fromARGB(106, 0, 0, 0), borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: IconButton(
                        icon: const Row(
                          children: [
                            Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                            Text('Voltar', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                ActionChip(
                  avatar: const Icon(Icons.location_on_outlined),
                  label: const Text('Localização'),
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                ActionChip(
                  avatar: const Icon(Icons.payment_outlined),
                  label: const Text('Pagamentos'),
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                ActionChip(
                  avatar: const Icon(Icons.warning_amber),
                  label: const Text('Termos de Uso'),
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Escolha sua Prova',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: 2,
              itemBuilder: (context, index) {
                return const CardProvas();
              },
            ),
          ),
        ],
      ),
    );
  }
}
