// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  void aoClicarNaCabeceira(ProvaModelo prova, NomesCabeceiraModelo item) {
    var usuarioProvider = context.read<UsuarioProvider>();

    if (prova.jaComprou == '1' && item.id == '1') {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Você já comprou essa modalidade.')),
          showCloseIcon: true,
        ));
      }
      return;
    }

    if (prova.jaComprou == '2' && item.id == '2') {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Você já comprou essa modalidade.')),
          showCloseIcon: true,
        ));
      }
      return;
    }

    // Caso o usuário ja tenha comprado essa prova
    if (prova.jaComprou == 'todos') {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Você já comprou essa prova.')),
          showCloseIcon: true,
        ));
      }
      return;
    }

    if (!prova.compraLiberada) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text('Ainda falta ${prova.tempoFaltante} para que essa prova seja liberada.')),
          showCloseIcon: true,
        ));
      }
      return;
    }

    if (widget.evento.liberacaoDeCompra == '0') {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('A compra dessa prova foi desativada, aguarde a ativação.')),
          showCloseIcon: true,
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

        Navigator.pushNamed(context, AppRotas.login);
      }
      return;
    }

    if (item.id == '1' && (usuarioProvider.usuario!.hcCabeceira!.isEmpty || double.parse(usuarioProvider.usuario!.hcCabeceira!) <= 0)) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text("Você precisa ter um HandiCap ${item.nome} para poder continuar a compra.")),
          showCloseIcon: true,
        ));
      }
      return;
    }

    if (item.id == '2' && (usuarioProvider.usuario!.hcPezeiro!.isEmpty || double.parse(usuarioProvider.usuario!.hcPezeiro!) <= 0)) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text("Você precisa ter um HandiCap ${item.nome} para poder continuar a compra.")),
          showCloseIcon: true,
        ));
      }
      return;
    }

    // Verificação do HandiCap Máximo e Mínimo da prova
    if ((prova.hcMinimo.isNotEmpty && prova.hcMaximo.isNotEmpty) && (double.parse(prova.hcMinimo) > 0 && double.parse(prova.hcMaximo) > 0)) {
      // Verificação se o id cabeceira é o primeiro (CABECEIRA) e verifica se está de acordo com o valor maximo e minimo de handicap da prova

      if (item.id == '1' && usuarioProvider.usuario!.hcCabeceira!.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text("Seu Handicap é vazio e não é permitido para essa Somatória de ${prova.hcMinimo} á ${prova.hcMaximo}.")),
            showCloseIcon: true,
            backgroundColor: Colors.red,
          ));
        }
        return;
      }

      if (item.id == '2' && usuarioProvider.usuario!.hcPezeiro!.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text("Seu Handicap é vazio e não é permitido para essa Somatória de ${prova.hcMinimo} á ${prova.hcMaximo}.")),
            showCloseIcon: true,
            backgroundColor: Colors.red,
          ));
        }
        return;
      }

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
            content: Center(child: Text("Seu Handicap de ${usuarioProvider.usuario!.hcPezeiro} não é permitido para essa Somatória de ${prova.hcMinimo} á ${prova.hcMaximo}.")),
            showCloseIcon: true,
            backgroundColor: Colors.red,
          ));
        }
        return;
      }
    }

    var provaModelo = ProvaModelo(
      id: prova.id,
      jaComprou: '0',
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
      jaComprou: '0',
      hcMinimo: '0',
      hcMaximo: '0',
      nomeProva: prova.nomeProva,
      valor: prova.valor,
      idCabeceira: item.id,
      compraLiberada: true,
    ));
  }

  Color coresJaComprou(ProvaModelo prova) {
    var usuarioProvider = context.read<UsuarioProvider>();

    if (prova == null || usuarioProvider == null || usuarioProvider.usuario == null) {
      return Colors.red;
    }

    // Verificação do HandiCap Máximo e Mínimo da prova
    if ((prova.hcMinimo != null && prova.hcMaximo != null) &&
        (prova.hcMinimo.isNotEmpty && prova.hcMaximo.isNotEmpty) &&
        (double.parse(prova.hcMinimo) > 0 && double.parse(prova.hcMaximo) > 0)) {
      // Verificação se o id cabeceira é o primeiro (CABECEIRA) e verifica se está de acordo com o valor maximo e minimo de handicap da prova
      if (usuarioProvider.usuario!.hcPezeiro!.isEmpty || usuarioProvider.usuario!.hcCabeceira!.isEmpty) {
        return Colors.red;
      }

      var verificacaoMaxMinCabeceira = !(double.parse(usuarioProvider.usuario!.hcCabeceira!) >= double.parse(prova.hcMinimo) &&
          double.parse(usuarioProvider.usuario!.hcCabeceira!) <= double.parse(prova.hcMaximo));

      var verificacaoMaxMinPiseiro =
          !(double.parse(usuarioProvider.usuario!.hcPezeiro!) >= double.parse(prova.hcMinimo) && double.parse(usuarioProvider.usuario!.hcPezeiro!) <= double.parse(prova.hcMaximo));

      if (verificacaoMaxMinCabeceira && verificacaoMaxMinPiseiro) {
        return Colors.red;
      }
    }

    // Verificação do HandiCap Máximo e Mínimo da prova
    if ((prova.hcMinimo.isNotEmpty && prova.hcMaximo.isNotEmpty) && (double.parse(prova.hcMinimo) > 0 && double.parse(prova.hcMaximo) > 0)) {
      // Verificação se o id cabeceira é o primeiro (CABECEIRA) e verifica se está de acordo com o valor maximo e minimo de handicap da prova

      if (usuarioProvider.usuario!.hcCabeceira!.isEmpty && usuarioProvider.usuario!.hcPezeiro!.isEmpty) {
        return Colors.red;
      }

      if ((!(double.parse(usuarioProvider.usuario!.hcCabeceira!) >= double.parse(prova.hcMinimo) &&
              double.parse(usuarioProvider.usuario!.hcCabeceira!) <= double.parse(prova.hcMaximo))) &&
          prova.jaComprou == '2') {
        return Colors.red;
      }

      if ((!(double.parse(usuarioProvider.usuario!.hcPezeiro!) >= double.parse(prova.hcMinimo) &&
              double.parse(usuarioProvider.usuario!.hcPezeiro!) <= double.parse(prova.hcMaximo))) &&
          prova.jaComprou == '1') {
        return Colors.red;
      }

      if ((!(double.parse(usuarioProvider.usuario!.hcCabeceira!) >= double.parse(prova.hcMinimo) &&
              double.parse(usuarioProvider.usuario!.hcCabeceira!) <= double.parse(prova.hcMaximo))) &&
          (!(double.parse(usuarioProvider.usuario!.hcPezeiro!) >= double.parse(prova.hcMinimo) &&
              double.parse(usuarioProvider.usuario!.hcPezeiro!) <= double.parse(prova.hcMaximo)))) {
        return Colors.red;
      }
    }

    if (prova.jaComprou == 'todos') {
      return Colors.red;
    }

    if (!prova.compraLiberada) {
      return Colors.red;
    }

    if (widget.evento.liberacaoDeCompra == '0') {
      return Colors.red;
    }

    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    var prova = widget.prova;
    var width = MediaQuery.of(context).size.width;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: tamanhoCard,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            var usuarioProvider = context.read<UsuarioProvider>();

            if (!prova.compraLiberada) {
              if (mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Center(child: Text('Ainda falta ${prova.tempoFaltante} para que essa prova seja liberada.')),
                  showCloseIcon: true,
                ));
              }
              return;
            }

            if (widget.evento.liberacaoDeCompra == '0') {
              if (mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Center(child: Text('A compra dessa prova foi desativada, aguarde a ativação.')),
                  showCloseIcon: true,
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

                Navigator.pushNamed(context, AppRotas.login);
              }
              return;
            }

            if (prova.jaComprou == 'todos') {
              if (mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Center(child: Text('Você já comprou essa prova.')),
                  showCloseIcon: true,
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
                    Skeleton.shade(
                      child: Container(
                        width: 5,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: VerticalDivider(color: coresJaComprou(prova), thickness: 5),
                      ),
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
                          if (!prova.compraLiberada) ...[
                            Text(
                              "${prova.tempoFaltante!} para liberação",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                          if (prova.compraLiberada) ...[
                            const SizedBox(height: 15),
                          ],
                          SizedBox(
                            width: (width - 90) - 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Utils.coverterEmReal.format(double.parse(prova.valor)),
                                  style: const TextStyle(fontSize: 18, color: Colors.green),
                                ),
                                if ((prova.hcMinimo.isNotEmpty && prova.hcMaximo.isNotEmpty) && (double.parse(prova.hcMinimo) > 0 && double.parse(prova.hcMaximo) > 0)) ...[
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "HC: ${prova.hcMinimo} á ${prova.hcMaximo}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ],
                            ),
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
