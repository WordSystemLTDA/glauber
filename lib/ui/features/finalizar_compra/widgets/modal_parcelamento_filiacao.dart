import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/listar_informacoes_modelo.dart';

class ModalParcelamentoFiliacao extends StatefulWidget {
  final ListarInformacoesModelo dados;
  final void Function(int parcelas) aoConfirmar;
  final int? parcelasInicial;

  const ModalParcelamentoFiliacao({
    super.key,
    required this.dados,
    required this.aoConfirmar,
    this.parcelasInicial,
  });

  @override
  State<ModalParcelamentoFiliacao> createState() => _ModalParcelamentoFiliacaoState();
}

class _ModalParcelamentoFiliacaoState extends State<ModalParcelamentoFiliacao> {
  late int parcelasFiliacao;

  @override
  void initState() {
    super.initState();
    parcelasFiliacao = widget.parcelasInicial ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final valorFiliacao = double.parse(widget.dados.valorAdicional!.valor);
    final valor1x = valorFiliacao;
    final valor2x = valorFiliacao + 50.0;

    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Row(
                children: [
                  const Icon(Icons.card_membership, color: Color(0xFFF71808), size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Parcelamento de Filiação',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        if (widget.dados.valorAdicional!.titulo.isNotEmpty)
                          Text(
                            widget.dados.valorAdicional!.titulo,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Opção 1x
              _buildOpcaoParcela(
                selected: parcelasFiliacao == 1,
                parcelas: 1,
                valor: valor1x,
                onTap: () => setState(() => parcelasFiliacao = 1),
              ),
              const SizedBox(height: 12),

              // Opção 2x
              _buildOpcaoParcela(
                selected: parcelasFiliacao == 2,
                parcelas: 2,
                valor: valor2x,
                onTap: () => setState(() => parcelasFiliacao = 2),
              ),
              const SizedBox(height: 24),

              // Resumo
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total da filiação:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        if (parcelasFiliacao == 2) ...[
                          Text(
                            'R\$ ${(valor2x / 2).toStringAsFixed(2).replaceAll('.', ',')}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFF71808)),
                          ),
                          const SizedBox(width: 8),
                          const Text('x 2', style: TextStyle(fontWeight: FontWeight.bold)),
                        ] else
                          Text(
                            _formatarReal(valor1x),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFF71808)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFF71808)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          'Voltar',
                          style: TextStyle(color: Color(0xFFF71808), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF71808),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          widget.aoConfirmar(parcelasFiliacao);
                          Navigator.of(context).pop(true);
                        },
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

  Widget _buildOpcaoParcela({
    required bool selected,
    required int parcelas,
    required double valor,
    required VoidCallback onTap,
  }) {
    final valorPorParcela = valor / parcelas;
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF71808).withOpacity(0.05) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFFF71808) : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Radio<int>(
              value: parcelas,
              groupValue: parcelas == 1 ? (selected ? 1 : -1) : (selected ? 2 : -1),
              onChanged: (_) => onTap(),
              activeColor: const Color(0xFFF71808),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$parcelas x de ${_formatarReal(valorPorParcela)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    'Total: ${_formatarReal(valor)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatarReal(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
