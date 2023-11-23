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
  double tamanhoCard = 110;

  void aoClicarNaCabeceira(ProvaModelo prova, item) {
    var usuario = UsuarioProvider.getUsuario();

    if (!prova.compraLiberada) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Essa prova não está liberada para venda ainda.')),
          showCloseIcon: true,
          backgroundColor: Colors.red,
        ));
      }
      return;
    }

    // Caso o usuário não esteja logado
    if (usuario == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Você precisa estar logado para fazer compras.')),
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

    // Caso o usuário não tenha nenhum handicap
    if (double.parse(usuario.hcCabeceira) <= 0 && double.parse(usuario.hcPezeiro) <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text("Você precisa ter um HandiCap para poder continuar a compra.")),
          showCloseIcon: true,
          backgroundColor: Colors.red,
        ));
      }
      return;
    }

    // Verificação do HandiCap Máximo e Mínimo da prova
    if (double.parse(prova.hcMinimo) > 0 && double.parse(prova.hcMaximo) > 0) {
      // Verificação se o id cabeceira é o primeiro (CABECEIRA) e verifica se está de acordo com o valor maximo e minimo de handicap da prova
      if (item.id == '1' && !(double.parse(usuario.hcCabeceira) >= double.parse(prova.hcMinimo) && double.parse(usuario.hcCabeceira) <= double.parse(prova.hcMaximo))) {
        if (mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text("Seu Handicap de ${usuario.hcCabeceira} não é permitido para essa Somatória de ${prova.hcMinimo} á ${prova.hcMaximo}.")),
            showCloseIcon: true,
            backgroundColor: Colors.red,
          ));
        }
        return;
      }

      // Verificação se o id cabeceira é o segundo (PISEIRO) e verifica se está de acordo com o valor maximo e minimo de handicap da prova
      if (item.id == '2' && !(double.parse(usuario.hcPezeiro) >= double.parse(prova.hcMinimo) && double.parse(usuario.hcPezeiro) <= double.parse(prova.hcMaximo))) {
        if (mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text("Seu Handicap ${usuario.hcPezeiro} não é permitido para essa Somatória de ${prova.hcMinimo} á ${prova.hcMaximo}.")),
            showCloseIcon: true,
            backgroundColor: Colors.red,
          ));
        }
        return;
      }
    }

    // Caso o usuário ja tenha comprado essa prova
    if (prova.jaComprou) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Você já comprou essa prova.')),
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
      hcMinimo: '0',
      hcMaximo: '0',
      idCabeceira: item.id,
      compraLiberada: true,
    );

    widget.aoClicarNaProva(provaModelo);
  }

  Color? coresAction(prova, item) {
    if (prova.jaComprou) {
      return const Color.fromARGB(255, 252, 252, 252);
    }

    if (existeNoCarrinho(prova, item)) {
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

  bool existeNoCarrinho(prova, item) {
    return widget.provasCarrinho.contains(ProvaModelo(
      id: prova.id,
      jaComprou: false,
      hcMinimo: '0',
      hcMaximo: '0',
      nomeProva: prova.nomeProva,
      valor: prova.valor,
      idCabeceira: item.id,
      compraLiberada: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var prova = widget.prova;

    return SizedBox(
      height: tamanhoCard,
      child: Card(
        color: prova.jaComprou ? const Color.fromARGB(255, 252, 252, 252) : Colors.white,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            var usuario = UsuarioProvider.getUsuario();

            if (!prova.compraLiberada) {
              if (mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Center(child: Text('Essa prova não está liberada para venda ainda.')),
                  showCloseIcon: true,
                  backgroundColor: Colors.red,
                ));
              }
              return;
            }

            if (usuario == null) {
              if (mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Center(child: Text('Você precisa estar logado para fazer compras.')),
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
                  content: Center(child: Text('Você já comprou essa prova.')),
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
                      child: VerticalDivider(color: (prova.jaComprou || !prova.compraLiberada) ? Colors.red : Colors.green, thickness: 5),
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
                  clipBehavior: Clip.hardEdge,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                  ),
                  margin: EdgeInsets.zero,
                  child: SizedBox(
                    height: tamanhoCard,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(height: 1, color: Color.fromARGB(255, 238, 238, 238));
                      },
                      padding: const EdgeInsets.only(bottom: 1),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.nomesCabeceira!.length,
                      itemBuilder: (context, index) {
                        var item = widget.nomesCabeceira![index];
                        return SizedBox(
                          width: 90,
                          height: tamanhoCard / 2.1,
                          child: Material(
                            color: coresAction(prova, item),
                            child: InkWell(
                              borderRadius: index == 0 ? const BorderRadius.only(topRight: Radius.circular(5)) : const BorderRadius.only(bottomRight: Radius.circular(5)),
                              onTap: () {
                                aoClicarNaCabeceira(prova, item);
                              },
                              child: Center(
                                child: Text(
                                  item.nome,
                                  style: TextStyle(color: existeNoCarrinho(prova, item) ? Colors.white : Colors.black),
                                  textAlign: TextAlign.center,
                                ),
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
