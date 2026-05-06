// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/compras_servico.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/domain/models/compras/compras.dart';
import 'package:provadelaco/domain/models/parceiros_compra_modelo.dart';
import 'package:provadelaco/ui/features/competidores/widgets/pagina_selecionar_competidor.dart';
import 'package:provider/provider.dart';

class CardParceirosCompra extends StatefulWidget {
  final ComprasModelo item;
  final ParceirosCompraModelo parceiro;
  final List<ParceirosCompraModelo> parceiros;
  final Function() aoSalvar;

  const CardParceirosCompra({
    super.key,
    required this.item,
    required this.parceiro,
    required this.parceiros,
    required this.aoSalvar,
  });

  @override
  State<CardParceirosCompra> createState() => _CardParceirosCompraState();
}

class _CardParceirosCompraState extends State<CardParceirosCompra> {
  bool _competidorEstaBloqueado(CompetidoresModelo competidor) {
    if ((competidor.motivosBloqueio ?? []).isNotEmpty) {
      return true;
    }

    if (competidor.podeCorrer == false) {
      return true;
    }

    if (widget.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty && competidor.id != '0') {
      return true;
    }

    if (competidor.ativo == 'Não' || competidor.ativo == 'Somatoria' || competidor.ativo == 'HCMinMax') {
      return true;
    }

    return false;
  }

  void _mostrarMensagemBloqueio(CompetidoresModelo competidor) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_mensagemBloqueioCompetidor(competidor)),
        showCloseIcon: true,
      ),
    );
  }

  String _mensagemBloqueioCompetidor(CompetidoresModelo competidor) {
    if ((competidor.motivosBloqueio ?? []).isNotEmpty) {
      return competidor.motivosBloqueio!.join('\n');
    }

    if (competidor.podeCorrer == false && competidor.mensagemValidacao != null && competidor.mensagemValidacao!.isNotEmpty) {
      return competidor.mensagemValidacao!;
    }

    if (widget.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty && competidor.id != '0') {
      return 'Esse competidor já foi selecionado.';
    }

    if (competidor.ativo == 'Não') {
      return 'Competidor já fez todas as inscrições.';
    }

    if (competidor.ativo == 'Somatoria') {
      return 'HandiCap do competidor estoura a somatória.';
    }

    if (competidor.ativo == 'HCMinMax') {
      return 'HandiCap do competidor não é compatível com a prova.';
    }

    return 'Esse competidor não pode ser selecionado.';
  }

  Future<void> _abrirSelecaoParceiro() async {
    var item = widget.item;
    var parceiro = widget.parceiro;

    if (item.provas[0].permitirEditarParceiros != 'Sim') {
      return;
    }

    final comprasServico = context.read<ComprasServico>();

    final competidor = await Navigator.of(context).push<CompetidoresModelo>(
      MaterialPageRoute(
        builder: (_) => PaginaSelecionarCompetidor(
          idCabeceira: widget.item.idCabeceira,
          idProva: parceiro.idProva,
          destacarCardsStatus: true,
          idsJaSelecionados: widget.parceiros.map((e) => e.idParceiro).toList(),
          jaSelecionado: (competidor) => widget.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty,
          podeSelecionar: (competidor) {
            if (competidor.id == '0') {
              return true;
            }

            if (_competidorEstaBloqueado(competidor)) {
              return false;
            }

            return competidor.ativo == 'Sim';
          },
          mensagemBloqueio: _mensagemBloqueioCompetidor,
        ),
      ),
    );

    if (competidor == null || !mounted) {
      return;
    }

    if (_competidorEstaBloqueado(competidor)) {
      _mostrarMensagemBloqueio(competidor);
      return;
    }

    showDialog<String>(
      context: context,
      builder: (BuildContext contextDialog) {
        final parceiroAtualNome = parceiro.nomeParceiro;
        final novoParceiroNome = competidor.apelido.isNotEmpty ? competidor.apelido : competidor.nome;

        return AlertDialog(
          title: const Text('Substituir'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você vai substituir "$parceiroAtualNome" por "$novoParceiroNome".'),
                const SizedBox(height: 6),
                const Text('Deseja realmente confirmar essa troca?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(contextDialog).pop();
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                await comprasServico.editarParceiro(parceiro.id, parceiro.idParceiro, competidor.id, parceiro.nomeModalidade).then((value) {
                  var (sucesso, mensagem) = value;

                  if (sucesso) {
                    if (mounted) {
                      widget.aoSalvar();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(mensagem),
                        backgroundColor: Colors.red,
                      ));
                    }
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    var parceiro = widget.parceiro;
    return Card(
      margin: const EdgeInsets.only(bottom: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: parceiro.parceiroTemCompra == 'Confirmado'
                ? Colors.green
                : parceiro.parceiroTemCompra == 'Pendente'
                    ? const Color.fromARGB(255, 209, 130, 3)
                    : Colors.transparent,
          )),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: _abrirSelecaoParceiro,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(parceiro.nomeModalidade),
                  const SizedBox(height: 5),
                  Text(
                    parceiro.nomeParceiro,
                    style: const TextStyle(color: Colors.green),
                  ),
                  const SizedBox(height: 5),
                  if (parceiro.nomeCidade.isNotEmpty) Text('${parceiro.nomeCidade} - ${parceiro.siglaEstado}'),
                ],
              ),
              SizedBox(
                width: 100,
                height: 95,
                child: Stack(
                  children: [
                    if (item.provas[0].permitirEditarParceiros == 'Sim')
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: _abrirSelecaoParceiro,
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Positioned(
                      bottom: 10,
                      right: 5,
                      child: Text(
                        parceiro.parceiroTemCompra == 'Pendente'
                            ? 'À Confirmar'
                            : parceiro.parceiroTemCompra == 'Confirmado'
                                ? 'Confirmado'
                                : '',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: parceiro.parceiroTemCompra == 'Confirmado'
                                ? Colors.green
                                : parceiro.parceiroTemCompra == 'Pendente'
                                    ? Colors.red
                                    : null),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
