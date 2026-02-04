import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provadelaco/config/config.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/data/services/competidores_servico.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/domain/models/evento/evento.dart';
import 'package:provadelaco/domain/models/prova/prova.dart';
import 'package:provadelaco/ui/features/provas/widgets/card_parceiros.dart';
import 'package:provadelaco/utils/whatsapp.dart';
import 'package:provider/provider.dart';

class ModalDetalhesProva extends StatefulWidget {
  final bool Function(int quantidade, List<CompetidoresModelo> listaCompetidores, bool sorteio) adicionarNoCarrinho;
  final ProvaModelo prova;
  final EventoModelo evento;
  final String? quantParceiros;
  final String permVincularParceiro;
  final List<ProvaModelo> provasCarrinho;

  const ModalDetalhesProva({
    super.key,
    required this.adicionarNoCarrinho,
    required this.prova,
    required this.evento,
    this.quantParceiros,
    required this.permVincularParceiro,
    required this.provasCarrinho,
  });

  @override
  State<ModalDetalhesProva> createState() => _ModalDetalhesProvaState();
}

class _ModalDetalhesProvaState extends State<ModalDetalhesProva> {
  int quantidade = 0;
  bool sorteio = false;
  String mensagemAlerta = '';

  List<CompetidoresModelo> listaCompetidores = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      mudarQuantidade();
    }
  }

  // mudar quantidade que irá aparecer dependendo se ja tem ou não selecionado
  void mudarQuantidade() {
    if (widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).isEmpty) {
      if (widget.prova.avulsa == 'Sim') {
        quantidade = int.parse(widget.prova.quantMinima);
      } else {
        quantidade = 1;
      }
    } else {
      quantidade = widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).length;
    }

    if (widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).isNotEmpty &&
        widget.permVincularParceiro == 'Sim') {
      listaCompetidores = widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).first.competidores ?? [];

      if (widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).first.sorteio != null) {
        sorteio = widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).first.sorteio!;
      }
    } else {
      if (widget.prova.permitirCompra.competidoresJaSelecionados != null &&
          widget.prova.permitirCompra.competidoresJaSelecionados!.isNotEmpty &&
          widget.permVincularParceiro == 'Sim') {
        if (widget.prova.avulsa == 'Sim') {
          quantidade = widget.prova.permitirCompra.competidoresJaSelecionados!.length;
        } else {
          quantidade = 1;
        }

        for (var i = 0; i < widget.prova.permitirCompra.competidoresJaSelecionados!.length; i++) {
          var itemNovo = widget.prova.permitirCompra.competidoresJaSelecionados![i];
          var novoCompetidor = CompetidoresModelo(
            id: itemNovo.id,
            nome: itemNovo.nome,
            idProva: widget.prova.id,
            apelido: itemNovo.apelido,
            nomeCidade: itemNovo.nomeCidade,
            siglaEstado: itemNovo.siglaEstado,
            ativo: itemNovo.ativo,
            jaExistente: itemNovo.jaExistente,
            idParceiroTrocado: itemNovo.idParceiroTrocado,
          );

          listaCompetidores.add(novoCompetidor);
        }
      }

      if (widget.quantParceiros != null && int.parse(widget.quantParceiros!) > 0 && widget.prova.avulsa == 'Não') {
        for (var i = 0;
            i <
                int.parse(widget.quantParceiros!) -
                    (widget.prova.permitirCompra.competidoresJaSelecionados != null ? widget.prova.permitirCompra.competidoresJaSelecionados!.length : 0);
            i++) {
          listaCompetidores.add(CompetidoresModelo(
            id: widget.prova.permitirSorteio == 'Sim' ? '0' : '',
            nome: '',
            apelido: '',
            nomeCidade: '',
            idProva: widget.prova.id,
            siglaEstado: '',
            ativo: 'Sim',
            jaExistente: false,
          ));
        }
      } else if (widget.permVincularParceiro == 'Sim') {
        for (var i = 0;
            i < quantidade - (widget.prova.permitirCompra.competidoresJaSelecionados != null ? widget.prova.permitirCompra.competidoresJaSelecionados!.length : 0);
            i++) {
          listaCompetidores.add(CompetidoresModelo(
            id: widget.prova.permitirSorteio == 'Sim' ? '0' : '',
            nome: '',
            apelido: '',
            nomeCidade: '',
            idProva: widget.prova.id,
            siglaEstado: '',
            ativo: 'Sim',
            jaExistente: false,
          ));
        }
      }
    }
  }

  void adicionarQuantidade() {
    if (quantidade < int.parse(widget.prova.quantMaxima)) {
      setState(() {
        quantidade = quantidade + 1;
        if (widget.permVincularParceiro == 'Sim') {
          listaCompetidores.add(CompetidoresModelo(
            id: widget.prova.permitirSorteio == 'Sim' ? '0' : '',
            nome: '',
            apelido: '',
            idProva: widget.prova.id,
            nomeCidade: '',
            siglaEstado: '',
            ativo: 'Sim',
            jaExistente: false,
          ));
        }
      });
    }
  }

  void removerQuantidade() {
    if (widget.prova.avulsa == 'Sim') {
      if (quantidade > int.parse(widget.prova.quantMinima)) {
        setState(() {
          quantidade = quantidade - 1;
          if (widget.permVincularParceiro == 'Sim') {
            listaCompetidores.removeLast();
          }
        });
      } else if (widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).isNotEmpty) {
        widget.adicionarNoCarrinho(0, [], sorteio);
      }
    } else {
      if (widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).isNotEmpty) {
        widget.adicionarNoCarrinho(0, [], sorteio);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var competidoresServico = context.read<CompetidoresServico>();
    var width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SizedBox(
        width: width,
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (listaCompetidores.isNotEmpty && widget.permVincularParceiro == 'Sim') ...[
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5, bottom: 10),
                                  child: Text('Seus Parceiros', style: TextStyle(fontSize: 16)),
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: listaCompetidores.length,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var item = listaCompetidores[index];

                                return CardParceiros(
                                  item: item,
                                  idProva: widget.prova.id,
                                  listaCompetidores: listaCompetidores,
                                  idCabeceira: widget.prova.idCabeceira,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            const Divider(),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: IconButton(
                                  color: (widget.prova.avulsa == 'Sim' && (quantidade > int.parse(widget.prova.quantMinima))) ? Colors.red : Colors.grey,
                                  iconSize: 34,
                                  onPressed: () {
                                    removerQuantidade();
                                  },
                                  icon: (widget.prova.avulsa == 'Sim' && (quantidade > int.parse(widget.prova.quantMinima))) ||
                                          widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).isEmpty
                                      ? const Icon(Icons.remove_circle_outline_outlined)
                                      : const Icon(Icons.delete_outline_outlined, color: Colors.red),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  quantidade.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  color: quantidade < int.parse(widget.prova.quantMaxima) ? Colors.green : Colors.grey,
                                  iconSize: 34,
                                  onPressed: () {
                                    if (widget.prova.avulsa == 'Sim') {
                                      adicionarQuantidade();
                                    }
                                  },
                                  icon: const Icon(Icons.add_circle_outline_outlined),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: mensagemAlerta.isNotEmpty ? 140 : 90),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          if (widget.prova.permitirSorteio == 'Sim' && widget.permVincularParceiro == 'Sim') ...[
                            SizedBox(
                              height: 30,
                              child: GestureDetector(
                                onTap: () {
                                  if (!sorteio == false) {
                                    for (var element in listaCompetidores) {
                                      if (element.id == '0') {
                                        setState(() {
                                          element.id = '';
                                        });
                                      }
                                    }
                                  } else {
                                    for (var element in listaCompetidores) {
                                      if (element.id == '') {
                                        setState(() {
                                          element.id = '0';
                                        });
                                      }
                                    }
                                  }

                                  setState(() {
                                    sorteio = !sorteio;
                                  });
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 24,
                                      child: Checkbox(
                                        value: sorteio,
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              sorteio = value;
                                            });

                                            if (value == false) {
                                              for (var element in listaCompetidores) {
                                                if (element.id == '0') {
                                                  setState(() {
                                                    element.id = '';
                                                  });
                                                }
                                              }
                                            } else {
                                              for (var element in listaCompetidores) {
                                                if (element.id == '') {
                                                  setState(() {
                                                    element.id = '0';
                                                  });
                                                }
                                              }
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text('HABILITAR SORTEIO'),
                                    // const Text('Caso não tenha parceiro, marque essa opção'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          SizedBox(
                            width: width - 20,
                            child: ElevatedButton(
                              onPressed: quantidade == 0
                                  ? null
                                  : () {
                                      var retorno = widget.adicionarNoCarrinho(quantidade, listaCompetidores, sorteio);
                                      if (retorno == false) {
                                        setState(() {
                                          if (widget.prova.permitirSorteio == 'Sim') {
                                            mensagemAlerta = 'Selecione todos os parceiros, antes de continuar. Caso não tenha parceiro, habilite a opção Sorteio.';
                                          } else {
                                            mensagemAlerta = 'Selecione todos os parceiros, antes de continuar.';
                                          }
                                        });
                                      }
                                    },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(quantidade == 0 ? Colors.grey : Colors.green),
                                foregroundColor: const WidgetStatePropertyAll(Colors.white),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                              child: Text(quantidade == 0
                                  ? 'Adicione alguma quantidade'
                                  : 'Salvar $quantidade ${quantidade == 1 ? 'item' : 'itens'} ${(double.parse(widget.prova.valor) * quantidade).obterReal()}'),
                            ),
                          ),
                          if (mensagemAlerta.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              mensagemAlerta,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                          // const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: -2,
              child: SearchAnchor(
                viewBuilder: (suggestions) {
                  if (suggestions.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text('Nenhum competidor disponível para essa Prova.'),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: suggestions.length,
                    padding: EdgeInsets.only(bottom: ConstantesGlobal.alturaTeclado),
                    itemBuilder: (context, index) {
                      var itemN = suggestions.elementAt(index);

                      return itemN;
                    },
                  );
                },
                isFullScreen: true,
                builder: (BuildContext context, SearchController controller) {
                  return TextButton(
                    onPressed: () {
                      controller.openView();
                    },
                    child: const Text('Competidores disponíveis', style: TextStyle(fontSize: 14)),
                  );
                },
                suggestionsBuilder: (BuildContext context, SearchController controller) async {
                  final keyword = controller.value.text;
                  var usuarioProvider = context.read<UsuarioProvider>();

                  List<CompetidoresModelo>? competidores =
                      await competidoresServico.listarBancoCompetidores(widget.prova.idCabeceira, usuarioProvider.usuario, keyword, widget.prova.id);

                  Iterable<Widget> widgets = competidores.map((competidor) {
                    return Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        onTap: () {},
                        leading: Text(competidor.id),
                        title: Text(
                          competidor.nome,
                          style: TextStyle(color: isDarkMode ? Colors.white : null),
                        ),
                        trailing: competidor.celular == null || (competidor.celular != null && competidor.celular!.isEmpty)
                            ? null
                            : IconButton(
                                onPressed: () {
                                  if (competidor.celular != null && competidor.celular!.isNotEmpty) {
                                    Whatsapp.abrir(competidor.celular!);
                                  }
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.green,
                                ),
                              ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              competidor.apelido,
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                            ),
                            if (competidor.nomeCidade.isNotEmpty)
                              Text(
                                "${competidor.nomeCidade} - ${competidor.siglaEstado}",
                                style: const TextStyle(fontWeight: FontWeight.w500, color: Color.fromARGB(255, 89, 89, 89)),
                              ),
                          ],
                        ),
                      ),
                    );
                  });

                  return widgets;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
