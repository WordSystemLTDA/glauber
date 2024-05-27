import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';

class PaginaAnimais extends StatefulWidget {
  const PaginaAnimais({super.key});

  @override
  State<PaginaAnimais> createState() => _PaginaAnimaisState();
}

class _PaginaAnimaisState extends State<PaginaAnimais> {
  TextEditingController nomeBuscaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarSombra(
        titulo: Text("Animais"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRotas.animaisCadastrar);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nomeBuscaController,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar cavalos',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                onChanged: (nomePesquisa) {
                  // buscarStore.listarEventoPorNome(nomePesquisa);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                prototypeItem: const SizedBox(height: 105),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT93a8gsU4zpkm0GV7gBFKJ9vPEoleHomfql7tvt2jwUQ&s',
                              height: 105,
                              width: 160,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CAVALO MANSO'),
                                Text('Puro-Sangue inglês'),
                                Text('Macho'),
                                Text('10 anos'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
