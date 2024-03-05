// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/verificar_permitir_compra_provedor.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardProvas extends StatefulWidget {
  final ProvaModelo prova;
  final EventoModelo evento;
  final bool verificando;
  final List<ProvaModelo> provasCarrinho;
  final List<NomesCabeceiraModelo>? nomesCabeceira;
  final String idEvento;

  const CardProvas({
    super.key,
    required this.prova,
    required this.idEvento,
    required this.verificando,
    required this.nomesCabeceira,
    required this.evento,
    required this.provasCarrinho,
  });

  @override
  State<CardProvas> createState() => _CardProvasState();
}

class _CardProvasState extends State<CardProvas> {
  double tamanhoCard = 110;

  void aoClicarNaCabeceira(ProvaModelo prova, NomesCabeceiraModelo item) async {
    var usuarioProvider = context.read<UsuarioProvider>();
    var verificarPermitirCompraProvedor = context.read<VerificarPermitirCompraProvedor>();

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

    var jaExisteCarrinho = existeNoCarrinho(prova, item);
    verificarPermitirCompraProvedor.verificarPermitirCompra(prova, widget.evento, widget.idEvento, widget.prova.id, usuarioProvider.usuario!, item.id, jaExisteCarrinho);
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

  bool existeNoCarrinho(ProvaModelo prova, NomesCabeceiraModelo item) {
    var provaNova = ProvaModelo(
      id: prova.id,
      permitirCompra: prova.permitirCompra,
      hcMinimo: "0",
      hcMaximo: "0",
      avulsa: prova.avulsa,
      quantMaxima: "0",
      quantMinima: "0",
      nomeProva: prova.nomeProva,
      valor: prova.valor,
      idCabeceira: item.id,
      somatoriaHandicaps: prova.somatoriaHandicaps,
      competidores: prova.competidores,
    );

    return widget.provasCarrinho.where((element) => element.id == provaNova.id && element.idCabeceira == provaNova.idCabeceira).isNotEmpty;
  }

  int quantidadeExisteCarrinho(ProvaModelo prova, NomesCabeceiraModelo item) {
    return widget.provasCarrinho.where((element) => element.id == prova.id && element.idCabeceira == item.id).length;
  }

  Color coresJaComprou(ProvaModelo prova) {
    var usuarioProvider = context.read<UsuarioProvider>();

    if (prova == null || usuarioProvider == null || usuarioProvider.usuario == null) {
      return Colors.red;
    }

    if (prova.permitirCompra.liberado) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    var prova = widget.prova;
    var width = MediaQuery.of(context).size.width;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: width,
      height: tamanhoCard,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            var usuarioProvider = context.read<UsuarioProvider>();

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

            if (prova.permitirCompra.liberado == false) {
              if (mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Center(child: Text(prova.permitirCompra.mensagem)),
                  showCloseIcon: true,
                  backgroundColor: Colors.red,
                ));
              }
              return;
            }
            // widget.aoClicarNaProva(prova);
          },
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              if (widget.verificando) ...[
                const Center(child: CircularProgressIndicator()),
              ],
              Row(
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
                              SizedBox(
                                width: (width - 90) - 50,
                                child: Text(
                                  prova.nomeProva,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
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

                              return Badge(
                                isLabelVisible: quantidadeExisteCarrinho(prova, item) != 0,
                                label: Text(quantidadeExisteCarrinho(prova, item).toString()),
                                offset: const Offset(-2, 3),
                                child: SizedBox(
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
            ],
          ),
        ),
      ),
    );
  }
}
