import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_login.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/perfil/ui/paginas/pagina_editar_usuario.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provider/provider.dart';

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
    var usuarioProvider = context.read<UsuarioProvider>();

    if (!prova.compraLiberada || widget.evento.liberacaoDeCompra == '0') {
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
    if (usuarioProvider.usuario == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Você precisa estar logado para fazer compras.')),
          showCloseIcon: true,
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
    if ((usuarioProvider.usuario!.hcCabeceira!.isEmpty && usuarioProvider.usuario!.hcPezeiro!.isEmpty) ||
        (double.parse(usuarioProvider.usuario!.hcCabeceira!) <= 0 && double.parse(usuarioProvider.usuario!.hcPezeiro!) <= 0)) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Center(child: Text("Você precisa ter um HandiCap para poder continuar a compra.")),
          showCloseIcon: true,
          action: SnackBarAction(
            label: 'Editar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const PaginaEditarUsuario();
                  },
                ),
              );
            },
          ),
        ));
      }
      return;
    }

    // Verificação do HandiCap Máximo e Mínimo da prova
    if ((prova.hcMinimo.isNotEmpty && prova.hcMaximo.isNotEmpty) && (double.parse(prova.hcMinimo) > 0 && double.parse(prova.hcMaximo) > 0)) {
      // Verificação se o id cabeceira é o primeiro (CABECEIRA) e verifica se está de acordo com o valor maximo e minimo de handicap da prova
      if (item.id == '1' &&
          !(double.parse(usuarioProvider.usuario!.hcCabeceira!) >= double.parse(prova.hcMinimo) &&
              double.parse(usuarioProvider.usuario!.hcCabeceira!) <= double.parse(prova.hcMaximo))) {
        if (mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text("Seu Handicap de ${usuarioProvider.usuario!.hcCabeceira} não é permitido para essa Somatória de ${prova.hcMinimo} á ${prova.hcMaximo}.")),
            showCloseIcon: true,
            backgroundColor: Colors.red,
          ));
        }
        return;
      }

      // Verificação se o id cabeceira é o segundo (PISEIRO) e verifica se está de acordo com o valor maximo e minimo de handicap da prova
      if (item.id == '2' &&
          !(double.parse(usuarioProvider.usuario!.hcPezeiro!) >= double.parse(prova.hcMinimo) &&
              double.parse(usuarioProvider.usuario!.hcPezeiro!) <= double.parse(prova.hcMaximo))) {
        if (mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text("Seu Handicap ${usuarioProvider.usuario!.hcPezeiro} não é permitido para essa Somatória de ${prova.hcMinimo} á ${prova.hcMaximo}.")),
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
    if (existeNoCarrinho(prova, item)) {
      if (Theme.of(context).brightness == Brightness.light) {
        return Colors.green;
      } else {
        return Colors.green;
      }
    } else if (Theme.of(context).brightness == Brightness.light) {
      return Colors.white;
    } else {
      return Colors.transparent;
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

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: tamanhoCard,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            var usuarioProvider = context.read<UsuarioProvider>();

            if (!prova.compraLiberada || widget.evento.liberacaoDeCompra == '0') {
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

            if (usuarioProvider.usuario == null) {
              if (mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Center(child: Text('Você precisa estar logado para fazer compras.')),
                  showCloseIcon: true,
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
                      child: VerticalDivider(color: (prova.jaComprou || !prova.compraLiberada || widget.evento.liberacaoDeCompra == '0') ? Colors.red : Colors.green, thickness: 5),
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
                child: Material(
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.zero,
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                    ),
                    child: SizedBox(
                      height: tamanhoCard,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider(height: 1, color: Theme.of(context).colorScheme.background);
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
                                    style: TextStyle(color: existeNoCarrinho(prova, item) ? Colors.white : (isDarkMode ? Colors.white : Colors.black)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
