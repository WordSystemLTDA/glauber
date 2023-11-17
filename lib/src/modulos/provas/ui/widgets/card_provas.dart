import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/uteis.dart';
import 'package:provadelaco/src/essencial/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_login.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

class CardProvas extends StatefulWidget {
  final ProvaModelo prova;
  final EventoModelo evento;
  final List<ProvaModelo> provasCarrinho;
  final List<NomesCabeceiraModelo>? nomesCabeceira;
  final String idEvento;
  final Function(ProvaModelo prova) aoClicarNaProva;

  const CardProvas({
    super.key,
    required this.prova,
    required this.idEvento,
    required this.aoClicarNaProva,
    required this.nomesCabeceira,
    required this.evento,
    required this.provasCarrinho,
  });

  @override
  State<CardProvas> createState() => _CardProvasState();
}

class _CardProvasState extends State<CardProvas> {
  double tamanhoCard = 120;

  void aoClicarNaCabeceira(ProvaModelo prova, item) {
    var usuario = UsuarioProvider.getUsuario();

    if (usuario == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Você precisa estar logado para fazer compras.'),
          showCloseIcon: true,
          backgroundColor: Colors.red,
        ));

        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const PaginaLogin();
          },
        ));
      }
      return;
    }

    if (prova.jaComprou) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Você já comprou essa prova.'),
          showCloseIcon: true,
          backgroundColor: Colors.red,
        ));
      }
      return;
    }

    var provaModelo = ProvaModelo(
      id: prova.id,
      jaComprou: false,
      nomeProva: prova.nomeProva,
      valor: prova.valor,
      idCabeceira: item.id,
    );

    widget.aoClicarNaProva(provaModelo);
  }

  Color? coresAction(prova, item) {
    if (prova.jaComprou) {
      return const Color.fromARGB(255, 230, 230, 230);
    }

    if (widget.provasCarrinho.contains(ProvaModelo(id: prova.id, jaComprou: false, nomeProva: prova.nomeProva, valor: prova.valor, idCabeceira: item.id))) {
      if (Theme.of(context).brightness == Brightness.light) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } else if (Theme.of(context).brightness == Brightness.light) {
      return Colors.white;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    var prova = widget.prova;

    return SizedBox(
      height: tamanhoCard,
      child: Card(
        color: prova.jaComprou ? const Color.fromARGB(255, 230, 230, 230) : Colors.white,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            var usuario = UsuarioProvider.getUsuario();

            if (usuario == null) {
              if (mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Você precisa estar logado para fazer compras.'),
                  showCloseIcon: true,
                  backgroundColor: Colors.red,
                ));

                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const PaginaLogin();
                  },
                ));
              }
              return;
            }

            if (prova.jaComprou) {
              if (mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Você já comprou essa prova.'),
                  showCloseIcon: true,
                  backgroundColor: Colors.red,
                ));
              }
              return;
            }
            // widget.aoClicarNaProva(prova);
          },
          borderRadius: BorderRadius.circular(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: const VerticalDivider(color: Colors.red, thickness: 5),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prova.nomeProva,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            Utils.coverterEmReal.format(double.parse(prova.valor)),
                            style: const TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 90,
                height: tamanhoCard,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                  ),
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.grey, width: 1)),
                    ),
                    height: tamanhoCard,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(height: 1);
                      },
                      padding: const EdgeInsets.only(bottom: 1),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.nomesCabeceira!.length,
                      itemBuilder: (context, index) {
                        var item = widget.nomesCabeceira![index];
                        return InkWell(
                          borderRadius: index == 0 ? const BorderRadius.only(topRight: Radius.circular(5)) : const BorderRadius.only(bottomRight: Radius.circular(5)),
                          onTap: () {
                            aoClicarNaCabeceira(prova, item);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: index == 0 ? const BorderRadius.only(topRight: Radius.circular(5)) : const BorderRadius.only(bottomRight: Radius.circular(5)),
                              color: coresAction(prova, item),
                            ),
                            width: 90,
                            height: tamanhoCard / 2.1,
                            child: Center(
                              child: Text(
                                item.nome,
                                style: TextStyle(
                                    color: widget.provasCarrinho
                                            .contains(ProvaModelo(id: prova.id, jaComprou: false, nomeProva: prova.nomeProva, valor: prova.valor, idCabeceira: item.id))
                                        ? Colors.white
                                        : Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
