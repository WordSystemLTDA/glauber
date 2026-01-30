import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/cartao/cartao_modelo.dart';

class CardCartao extends StatefulWidget {
  final Function() aoClicar;
  final Function(CartaoModelo cartao)? aoExcluir;
  final double? tamanhoCard;
  final bool? aparecerSeta;
  final bool aparecerVazio;
  final bool? selecionado;
  final double? aparecerSombra;
  final CartaoModelo cartao;

  const CardCartao({
    super.key,
    required this.aoClicar,
    this.aoExcluir,
    this.tamanhoCard,
    this.aparecerSeta,
    required this.aparecerVazio,
    this.aparecerSombra,
    this.selecionado,
    required this.cartao,
  });

  @override
  State<CardCartao> createState() => _CardCartaoState();
}

class _CardCartaoState extends State<CardCartao> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: widget.tamanhoCard ?? width,
      height: 70,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: widget.aparecerSombra ?? 0,
        shape: RoundedRectangleBorder(
          side: (widget.selecionado ?? false) ? const BorderSide(width: 1, color: Colors.green) : BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: InkWell(
          onTap: () {
            widget.aoClicar();
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.aparecerVazio) ...[
                  const Align(
                    alignment: Alignment.center,
                    child: Text('Selecione um cartão'),
                  ),
                ],
                if (widget.aparecerVazio == false) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.cartao.nomeCartao,
                                style: const TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Text(
                                widget.cartao.numeroCartao.toString().replaceAll(RegExp(r'.(?=.{4})'), '*'),
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Venc.',
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Text(
                                widget.cartao.expiracaoCartao,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          if (widget.aparecerSeta ?? false) ...[
                            const SizedBox(width: 10),
                            const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                          ],
                          if ((widget.aoExcluir != null)) ...[
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                widget.aoExcluir!(widget.cartao);
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
