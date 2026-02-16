import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/data/services/competidores_servico.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/domain/models/evento/evento.dart';
import 'package:provadelaco/domain/models/prova/prova.dart';
import 'package:provadelaco/ui/features/provas/widgets/card_parceiros.dart';
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
    mudarQuantidade();
  }

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
      listaCompetidores = List.from(widget.provasCarrinho.where((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira).first.competidores ?? []);

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
          listaCompetidores.add(CompetidoresModelo(
            id: itemNovo.id,
            nome: itemNovo.nome,
            idProva: widget.prova.id,
            apelido: itemNovo.apelido,
            nomeCidade: itemNovo.nomeCidade,
            siglaEstado: itemNovo.siglaEstado,
            ativo: itemNovo.ativo,
            jaExistente: itemNovo.jaExistente,
            idParceiroTrocado: itemNovo.idParceiroTrocado,
          ));
        }
      }

      if (widget.quantParceiros != null && int.parse(widget.quantParceiros!) > 0 && widget.prova.avulsa == 'Não') {
        int jaSelecionados = widget.prova.permitirCompra.competidoresJaSelecionados?.length ?? 0;
        for (var i = 0; i < int.parse(widget.quantParceiros!) - jaSelecionados; i++) {
          listaCompetidores.add(_gerarCompetidorVazio());
        }
      } else if (widget.permVincularParceiro == 'Sim') {
        int jaSelecionados = widget.prova.permitirCompra.competidoresJaSelecionados?.length ?? 0;
        for (var i = 0; i < quantidade - jaSelecionados; i++) {
          listaCompetidores.add(_gerarCompetidorVazio());
        }
      }
    }
  }

  CompetidoresModelo _gerarCompetidorVazio() {
    return CompetidoresModelo(
      id: widget.prova.permitirSorteio == 'Sim' ? '0' : '',
      nome: '',
      apelido: '',
      nomeCidade: '',
      idProva: widget.prova.id,
      siglaEstado: '',
      ativo: 'Sim',
      jaExistente: false,
    );
  }

  void adicionarQuantidade() {
    if (quantidade < int.parse(widget.prova.quantMaxima)) {
      setState(() {
        quantidade++;
        if (widget.permVincularParceiro == 'Sim') {
          listaCompetidores.add(_gerarCompetidorVazio());
        }
      });
    }
  }

  void removerQuantidade() {
    if (widget.prova.avulsa == 'Sim') {
      if (quantidade > int.parse(widget.prova.quantMinima)) {
        setState(() {
          quantidade--;
          if (widget.permVincularParceiro == 'Sim') {
            listaCompetidores.removeLast();
          }
        });
      } else if (widget.provasCarrinho.any((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira)) {
        widget.adicionarNoCarrinho(0, [], sorteio);
        Navigator.pop(context);
      }
    } else {
      if (widget.provasCarrinho.any((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira)) {
        widget.adicionarNoCarrinho(0, [], sorteio);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchSection(),
                  const SizedBox(height: 20),
                  if (listaCompetidores.isNotEmpty && widget.permVincularParceiro == 'Sim') ...[
                    const Text('SEUS PARCEIROS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1)),
                    const SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listaCompetidores.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => CardParceiros(
                        item: listaCompetidores[index],
                        idProva: widget.prova.id,
                        listaCompetidores: listaCompetidores,
                        idCabeceira: widget.prova.idCabeceira,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (widget.prova.permitirSorteio == 'Sim' && widget.permVincularParceiro == 'Sim')
                    _buildSorteioCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildFixedBottomActions(width),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 45,
      height: 5,
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.prova.nomeProva, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(widget.evento.nomeEvento, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return SearchAnchor(
      builder: (context, controller) => InkWell(
        onTap: () => controller.openView(),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.blue),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Buscar competidores no banco...', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue.shade300),
            ],
          ),
        ),
      ),
      suggestionsBuilder: (context, controller) async {
        final competidores = await context.read<CompetidoresServico>().listarBancoCompetidores(
          widget.prova.idCabeceira,
          context.read<UsuarioProvider>().usuario,
          controller.text,
          widget.prova.id,
        );
        return competidores.map((c) => ListTile(
          leading: Text(c.id),
          title: Text(c.nome),
          subtitle: Text(c.apelido),
          onTap: () => controller.closeView(c.nome),
        ));
      },
    );
  }

  Widget _buildSorteioCard() {
    return Container(
      decoration: BoxDecoration(
        color: sorteio ? Colors.orange.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: sorteio ? Colors.orange : Colors.grey.shade200),
      ),
      child: CheckboxListTile(
        title: const Text('HABILITAR SORTEIO', style: TextStyle(fontWeight: FontWeight.bold)),
        value: sorteio,
        activeColor: Colors.orange,
        onChanged: (val) {
          setState(() {
            sorteio = val!;
            for (var element in listaCompetidores) {
              if (sorteio && element.id == '') element.id = '0';
              if (!sorteio && element.id == '0') element.id = '';
            }
          });
        },
      ),
    );
  }

  Widget _buildFixedBottomActions(double width) {
    double valorFinal = double.parse(widget.prova.valor) * quantidade;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 15, 20, MediaQuery.of(context).padding.bottom + 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Inscrições:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              _qtyBtn(Icons.remove, removerQuantidade, isRemoveAction: true),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(quantidade.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              _qtyBtn(Icons.add, adicionarQuantidade),
            ],
          ),
          const SizedBox(height: 15),
          if (mensagemAlerta.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(mensagemAlerta, style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: quantidade == 0 ? null : () {
                var retorno = widget.adicionarNoCarrinho(quantidade, listaCompetidores, sorteio);
                if (retorno == false) {
                  setState(() {
                    mensagemAlerta = widget.prova.permitirSorteio == 'Sim'
                        ? 'Selecione todos os parceiros ou habilite o Sorteio.'
                        : 'Selecione todos os parceiros antes de continuar.';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF71808),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                'SALVAR $quantidade ${quantidade == 1 ? 'ITEM' : 'ITENS'} • ${valorFinal.obterReal()}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, {bool isRemoveAction = false}) {
    bool canRemove = (widget.prova.avulsa == 'Sim' && (quantidade > int.parse(widget.prova.quantMinima)));
    bool isDeleteIcon = !canRemove && widget.provasCarrinho.any((element) => element.id == widget.prova.id && element.idCabeceira == widget.prova.idCabeceira);
    
    Color btnColor = isRemoveAction ? Colors.red : Colors.green;
    if (isRemoveAction && !canRemove && !isDeleteIcon) btnColor = Colors.grey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: btnColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          isRemoveAction && isDeleteIcon ? Icons.delete_outline : icon,
          color: btnColor,
          size: 26,
        ),
      ),
    );
  }
}