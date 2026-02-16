import 'package:flutter/material.dart';
import 'package:provadelaco/data/repositories/provas_repository.dart';
import 'package:provadelaco/domain/models/animal/animal.dart';
import 'package:provadelaco/domain/models/evento/evento.dart';
import 'package:provadelaco/domain/models/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/domain/models/prova/prova.dart';
import 'package:provadelaco/ui/features/animais/widgets/pagina_animais.dart';
import 'package:provadelaco/ui/features/provas/widgets/card_provas.dart';
import 'package:provadelaco/ui/features/provas/widgets/modal_denunciar.dart';
import 'package:provider/provider.dart';

class PageViewProvas extends StatefulWidget {
  final EventoModelo evento;
  final ModeloAnimal? animalPadrao;
  final List<ProvaModelo> provas;
  final List<NomesCabeceiraModelo>? nomesCabeceira;
  final List<ProvaModelo> provasCarrinho;

  final String modalidade;
  final Function(ProvaModelo prova, EventoModelo evento, String quantParceiros, String modalidade) adicionarNoCarrinho;
  final Function(int quantidade, ProvaModelo prova, EventoModelo evento, String modalidade) adicionarAvulsaNoCarrinho;

  const PageViewProvas({
    super.key,
    required this.evento,
    required this.animalPadrao,
    required this.provas,
    this.nomesCabeceira,
    required this.provasCarrinho,
    required this.adicionarNoCarrinho,
    required this.adicionarAvulsaNoCarrinho,
    required this.modalidade,
  });

  @override
  State<PageViewProvas> createState() => _PageViewProvasState();
}

class _PageViewProvasState extends State<PageViewProvas> {
  @override
  Widget build(BuildContext context) {
    final provedor = context.watch<ProvasProvedor>();

    return CustomScrollView(
      key: PageStorageKey(widget.modalidade),
      physics: const BouncingScrollPhysics(),
      // padding: const EdgeInsets.only(bottom: 100), // Slivers handle padding differently
      slivers: [
        if (widget.modalidade == '3') SliverToBoxAdapter(child: _buildAnimalSelectionCard(provedor)),
        if (widget.provas.isEmpty)
          SliverFillRemaining(child: _buildEmptyState())
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final prova = widget.provas[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: CardProvas(
                      prova: prova,
                      evento: widget.evento,
                      nomesCabeceira: widget.nomesCabeceira,
                      idEvento: widget.evento.id,
                      modalidade: widget.modalidade,
                      provasCarrinho: widget.provasCarrinho,
                      adicionarNoCarrinho: (prova, evento, quantParceiros) => widget.adicionarNoCarrinho(prova, evento, quantParceiros, widget.modalidade),
                      adicionarAvulsaNoCarrinho: (quantidade, prova, evento) => widget.adicionarAvulsaNoCarrinho(quantidade, prova, evento, widget.modalidade),
                      removerDoCarrinho: (p) => setState(() => widget.provasCarrinho.remove(p)),
                    ),
                  );
                },
                childCount: widget.provas.length,
              ),
            ),
          ),
        SliverToBoxAdapter(child: _buildEventFooterInfo()),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }

  Widget _buildAnimalSelectionCard(ProvasProvedor provedor) {
    final animal = provedor.animalSelecionado;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: selecionarAnimal,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            border: Border.all(color: animal == null ? const Color(0xFFF71808).withValues(alpha: 0.3) : Colors.transparent),
          ),
          child: Row(
            children: [
              _buildAnimalImage(animal),
              const SizedBox(width: 16),
              Expanded(
                child: animal == null
                    ? const Text('Toque para selecionar um animal', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(animal.nomedoanimal, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('${animal.racadoanimal} • ${animal.sexo}', style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
              ),
              const Icon(Icons.swap_horiz, color: Color(0xFFF71808)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimalImage(ModeloAnimal? animal) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: animal == null
          ? const Icon(Icons.pets, size: 30, color: Colors.grey)
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(animal.foto, fit: BoxFit.cover),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Nenhuma prova nesta modalidade.', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildEventFooterInfo() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(widget.evento.descricao1, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, height: 1.5)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: abrirDenunciar, icon: const Icon(Icons.flag, color: Colors.red), label: const Text('Denunciar Evento', style: TextStyle(color: Colors.red))),
            ],
          )
        ],
      ),
    );
  }

  void selecionarAnimal() async {
    final animal = await Navigator.pushNamed(context, '/animais', arguments: PaginaAnimaisArgumentos(selecionarAnimais: true));
    if (animal != null) {
      if (mounted) {
        context.read<ProvasProvedor>().animalSelecionado = animal as ModeloAnimal;
      }
    }
  }

  void abrirDenunciar() => showDialog(context: context, builder: (_) => ModalDenunciar());
}
