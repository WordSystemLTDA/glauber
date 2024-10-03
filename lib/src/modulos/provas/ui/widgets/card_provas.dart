// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/verificar_permitir_compra_provedor.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/stores/provas_store.dart';
import 'package:provadelaco/src/modulos/provas/ui/paginas/pagina_aovivo.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/modal_detalhes_prova.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardProvas extends StatefulWidget {
  final ProvaModelo prova;
  final EventoModelo evento;
  // final bool verificando;
  final List<ProvaModelo> provasCarrinho;
  final List<NomesCabeceiraModelo>? nomesCabeceira;
  final String idEvento;
  final Function(ProvaModelo prova, EventoModelo evento, String quantParceiros) adicionarNoCarrinho;
  final Function(int quantidade, ProvaModelo prova, EventoModelo evento) adicionarAvulsaNoCarrinho;
  final Function(ProvaModelo prova) removerDoCarrinho;
  final Function(ProvaModelo prova)? aoSelecionarProvaAoVivo;

  const CardProvas({
    super.key,
    required this.prova,
    required this.idEvento,
    required this.nomesCabeceira,
    required this.evento,
    required this.provasCarrinho,
    required this.adicionarAvulsaNoCarrinho,
    required this.adicionarNoCarrinho,
    required this.removerDoCarrinho,
    this.aoSelecionarProvaAoVivo,
  });

  @override
  State<CardProvas> createState() => _CardProvasState();
}

class _CardProvasState extends State<CardProvas> {
  double tamanhoCard = 110;
  bool verificando = false;

  void aoClicarNaCabeceira(ProvaModelo prova, NomesCabeceiraModelo item, bool confirmar) async {
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

    setState(() {
      verificando = true;
    });

    var jaExisteCarrinho = existeNoCarrinho(prova, item);
    var quantidadeCarrinho = widget.provasCarrinho.where((element) => element.id == prova.id).length.toString();
    await verificarPermitirCompraProvedor
        .verificarPermitirCompra(prova, widget.evento, widget.idEvento, widget.prova.id, usuarioProvider.usuario!, item.id, jaExisteCarrinho, quantidadeCarrinho)
        .then((state) {
      if (state.permitirCompraModelo.liberado) {
        if (usuarioProvider.usuario!.ativoProva == 'Sim' && confirmar) {
          if (mounted) {
            showDialog<String>(
              context: context,
              builder: (BuildContext contextDialog) {
                return AlertDialog(
                  title: const Text('Confirmação'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          item.id == '1'
                              ? (usuarioProvider.usuario!.cabeceiroProvas ?? '')
                              : item.id == '2'
                                  ? (usuarioProvider.usuario!.pezeiroProvas ?? '')
                                  : '',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Não'),
                      onPressed: () {
                        Navigator.of(contextDialog).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Sim'),
                      onPressed: () async {
                        Navigator.of(contextDialog).pop();
                        aoClicarNaCabeceira(prova, item, false);
                      },
                    ),
                  ],
                );
              },
            );
          }

          return;
        }

        var provaModelo = ProvaModelo(
          id: state.provaModelo.id,
          permitirCompra: state.permitirCompraModelo,
          nomeProva: state.provaModelo.nomeProva,
          permitirSorteio: state.provaModelo.permitirSorteio,
          valor: state.provaModelo.valor,
          hcMinimo: state.provaModelo.hcMinimo,
          avulsa: state.provaModelo.avulsa,
          quantMaxima: state.permitirCompraModelo.quantMaximaAvulsa == null ? state.provaModelo.quantMaxima : state.permitirCompraModelo.quantMaximaAvulsa!,
          quantMinima: state.provaModelo.quantMinima,
          hcMaximo: state.provaModelo.hcMaximo,
          idListaCompeticao: state.provaModelo.idListaCompeticao,
          idCabeceira: state.idCabeceira,
          somatoriaHandicaps: state.provaModelo.somatoriaHandicaps,
          habilitarAoVivo: '',
          competidores: state.provaModelo.competidores,
          permitirEditarParceiros: state.provaModelo.permitirEditarParceiros,
          liberarReembolso: state.provaModelo.liberarReembolso,
        );

        if (provaModelo.avulsa == 'Sim') {
          if (mounted) {
            showModalBottomSheet(
              showDragHandle: true,
              isScrollControlled: true,
              context: context,
              builder: (contextModal) {
                return ModalDetalhesProva(
                  prova: provaModelo,
                  evento: widget.evento,
                  quantParceiros: state.permitirCompraModelo.quantParceiros,
                  permVincularParceiro: state.permitirCompraModelo.permVincularParceiro!,
                  provasCarrinho: widget.provasCarrinho,
                  adicionarNoCarrinho: (quantidade, listaCompetidores, sorteio) {
                    var novaProva = ProvaModelo(
                      id: provaModelo.id,
                      nomeProva: provaModelo.nomeProva,
                      valor: provaModelo.valor,
                      permitirSorteio: provaModelo.permitirSorteio,
                      permitirCompra: provaModelo.permitirCompra,
                      hcMinimo: "0",
                      habilitarAoVivo: '',
                      hcMaximo: "0",
                      avulsa: provaModelo.avulsa,
                      idListaCompeticao: '',
                      quantMaxima: "0",
                      quantMinima: "0",
                      sorteio: sorteio,
                      idCabeceira: provaModelo.idCabeceira,
                      somatoriaHandicaps: provaModelo.somatoriaHandicaps,
                      competidores: listaCompetidores,
                      permitirEditarParceiros: provaModelo.permitirEditarParceiros,
                      liberarReembolso: provaModelo.liberarReembolso,
                    );

                    if (quantidade == 0) {
                      widget.removerDoCarrinho(novaProva);
                      Navigator.pop(context);
                      return true;
                    }

                    if ((state.permitirCompraModelo.permVincularParceiro == 'Não' || ((provaModelo.permitirSorteio == 'Sim' && sorteio == true))
                        ? false
                        : listaCompetidores.where((element) => element.id == '' || element.id == '0').isNotEmpty)) {
                      return false;
                    }

                    widget.adicionarAvulsaNoCarrinho(quantidade, novaProva, state.eventoModelo);

                    Navigator.pop(context);

                    return true;
                  },
                );
              },
            );
          }
        } else {
          if (state.permitirCompraModelo.permVincularParceiro == 'Não' ||
              (int.tryParse(state.permitirCompraModelo.quantParceiros!) != null ? int.parse(state.permitirCompraModelo.quantParceiros!) == 0 : false)) {
            var novaProva = ProvaModelo(
              id: provaModelo.id,
              nomeProva: provaModelo.nomeProva,
              valor: provaModelo.valor,
              permitirSorteio: provaModelo.permitirSorteio,
              permitirCompra: provaModelo.permitirCompra,
              hcMinimo: "0",
              hcMaximo: "0",
              idListaCompeticao: '',
              avulsa: provaModelo.avulsa,
              habilitarAoVivo: '',
              quantMaxima: "0",
              quantMinima: "0",
              sorteio: false,
              idCabeceira: provaModelo.idCabeceira,
              somatoriaHandicaps: provaModelo.somatoriaHandicaps,
              competidores: provaModelo.competidores,
              permitirEditarParceiros: provaModelo.permitirEditarParceiros,
              liberarReembolso: provaModelo.liberarReembolso,
            );

            widget.adicionarNoCarrinho(novaProva, state.eventoModelo, state.permitirCompraModelo.quantParceiros!);
          } else {
            if (mounted) {
              showModalBottomSheet(
                showDragHandle: true,
                isScrollControlled: true,
                context: context,
                builder: (contextModal) {
                  return ModalDetalhesProva(
                    prova: provaModelo,
                    evento: widget.evento,
                    quantParceiros: state.permitirCompraModelo.quantParceiros,
                    permVincularParceiro: state.permitirCompraModelo.permVincularParceiro!,
                    provasCarrinho: widget.provasCarrinho,
                    adicionarNoCarrinho: (quantidade, listaCompetidores, sorteio) {
                      var novaProva = ProvaModelo(
                        id: provaModelo.id,
                        nomeProva: provaModelo.nomeProva,
                        valor: provaModelo.valor,
                        permitirSorteio: provaModelo.permitirSorteio,
                        permitirCompra: provaModelo.permitirCompra,
                        hcMinimo: "0",
                        hcMaximo: "0",
                        idListaCompeticao: '',
                        avulsa: provaModelo.avulsa,
                        quantMaxima: "0",
                        quantMinima: "0",
                        sorteio: sorteio,
                        habilitarAoVivo: '',
                        idCabeceira: provaModelo.idCabeceira,
                        somatoriaHandicaps: provaModelo.somatoriaHandicaps,
                        competidores: listaCompetidores,
                        permitirEditarParceiros: provaModelo.permitirEditarParceiros,
                        liberarReembolso: provaModelo.liberarReembolso,
                      );

                      if (quantidade == 0) {
                        widget.removerDoCarrinho(novaProva);
                        Navigator.pop(context);
                        return true;
                      }

                      if ((state.permitirCompraModelo.permVincularParceiro == 'Não' || ((provaModelo.permitirSorteio == 'Sim' && sorteio == true))
                          ? false
                          : listaCompetidores.where((element) => element.id == '' || element.id == '0').isNotEmpty)) {
                        return false;
                      }

                      widget.adicionarNoCarrinho(novaProva, state.eventoModelo, state.permitirCompraModelo.quantParceiros!);

                      Navigator.pop(context);

                      return true;
                    },
                  );
                },
              );
            }
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          if (state.permitirCompraModelo.rota != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Center(child: Text(state.permitirCompraModelo.mensagem)),
              action: SnackBarAction(
                label: state.permitirCompraModelo.tituloAcao!,
                onPressed: () {
                  if (state.permitirCompraModelo.rota! == '/compras') {
                    Navigator.pushNamed(context, AppRotas.inicio, arguments: PaginaInicioArgumentos(rota: state.permitirCompraModelo.rota!)).then((value) {
                      if (mounted) {
                        context.read<ProvasStore>().listar(usuarioProvider.usuario, widget.idEvento, '');
                      }
                    });
                  } else {
                    Navigator.pushNamed(context, state.permitirCompraModelo.rota!).then((value) {
                      if (mounted) {
                        context.read<ProvasStore>().listar(usuarioProvider.usuario, widget.idEvento, '');
                      }
                    });
                  }
                },
              ),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Center(child: Text(state.permitirCompraModelo.mensagem)),
              showCloseIcon: true,
              backgroundColor: Colors.red,
            ));
          }
        }
      }
    }).whenComplete(() {
      setState(() {
        verificando = false;
      });
    });
  }

  Color? coresAction(ProvaModelo prova, NomesCabeceiraModelo item) {
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
      idListaCompeticao: '',
      quantMinima: "0",
      nomeProva: prova.nomeProva,
      valor: prova.valor,
      habilitarAoVivo: '',
      idCabeceira: item.id,
      somatoriaHandicaps: prova.somatoriaHandicaps,
      competidores: prova.competidores,
      permitirSorteio: prova.permitirSorteio,
      permitirEditarParceiros: prova.permitirEditarParceiros,
      liberarReembolso: prova.liberarReembolso,
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

  void aoClicarNoCard(ProvaModelo prova) {
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
        if (prova.permitirCompra.rota != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text(prova.permitirCompra.mensagem)),
            action: SnackBarAction(
              label: prova.permitirCompra.tituloAcao!,
              onPressed: () {
                if (prova.permitirCompra.rota! == '/compras') {
                  Navigator.pushNamed(context, AppRotas.inicio, arguments: PaginaInicioArgumentos(rota: prova.permitirCompra.rota!)).then((value) {
                    if (mounted) {
                      context.read<ProvasStore>().listar(usuarioProvider.usuario, widget.idEvento, '');
                    }
                  });
                } else {
                  Navigator.pushNamed(context, prova.permitirCompra.rota!).then((value) {
                    if (mounted) {
                      context.read<ProvasStore>().listar(usuarioProvider.usuario, widget.idEvento, '');
                    }
                  });
                }
              },
            ),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text(prova.permitirCompra.mensagem)),
            showCloseIcon: true,
            backgroundColor: Colors.red,
          ));
        }
      }
    } else {
      if (prova.habilitarAoVivo == 'Sim') {
        Navigator.pushNamed(context, AppRotas.aovivo,
            arguments:
                PaginaAoVivoArgumentos(idEvento: widget.evento.id, idEmpresa: widget.evento.idEmpresa, idListaCompeticao: prova.idListaCompeticao, nomeProva: prova.nomeProva));
      }
    }
  }

  Widget _getIconButton(color, icon) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
        border: Border.all(width: 1, color: const Color.fromARGB(255, 255, 159, 152)),
        color: const Color(0xFFfbe5ea),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          const SizedBox(height: 5),
          const Text(
            'Súmula',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var prova = widget.prova;
    var width = MediaQuery.of(context).size.width;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SwipeActionCell(
      key: ObjectKey(prova),
      trailingActions: <SwipeAction>[
        SwipeAction(
          color: Colors.transparent,
          content: _getIconButton(Colors.red, Icons.live_tv_outlined),
          onTap: (handler) {
            Navigator.pushNamed(context, AppRotas.aovivo,
                arguments:
                    PaginaAoVivoArgumentos(idEvento: widget.evento.id, idEmpresa: widget.evento.idEmpresa, idListaCompeticao: prova.idListaCompeticao, nomeProva: prova.nomeProva));
          },
        ),
      ],
      child: SizedBox(
        width: width,
        height: tamanhoCard,
        child: Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: InkWell(
            onTap: () {
              aoClicarNoCard(prova);
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "ID da Prova: ${prova.id}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              );
            },
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                if (verificando) ...[
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
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                if (prova.descricao != null && prova.descricao!.isNotEmpty) ...[
                                  SizedBox(
                                    width: (width - 90) - 50,
                                    child: Text(
                                      prova.descricao!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: !isDarkMode ? const Color.fromARGB(255, 123, 123, 123) : const Color.fromARGB(255, 208, 208, 208), fontSize: 12),
                                    ),
                                  ),
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
                                return Divider(height: 1, color: Theme.of(context).colorScheme.surface);
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
                                          aoClicarNaCabeceira(prova, item, true);
                                        },
                                        child: Center(
                                          child: Text(
                                            item.nome,
                                            style: TextStyle(
                                              color: prova.permitirCompra.liberado == false ||
                                                      (prova.permitirCompra.idCabeceiraInvalido != null && prova.permitirCompra.idCabeceiraInvalido! == item.id)
                                                  ? Colors.grey
                                                  : existeNoCarrinho(prova, item)
                                                      ? Colors.white
                                                      : (isDarkMode ? Colors.white : Colors.black),
                                            ),
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
      ),
    );
  }
}
