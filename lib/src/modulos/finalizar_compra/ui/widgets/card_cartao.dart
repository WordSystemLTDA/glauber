import 'package:flutter/material.dart';

class CardCartao extends StatefulWidget {
  final Function() aoClicar;
  final double? tamanhoCard;
  final bool? aparecerSeta;
  final bool? aparecerVazio;
  final bool? selecionado;
  final double? aparecerSombra;
  const CardCartao({super.key, required this.aoClicar, this.tamanhoCard, this.aparecerSeta, this.aparecerVazio, this.aparecerSombra, this.selecionado});

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
                if (widget.aparecerVazio ?? false) ...[
                  const Align(
                    alignment: Alignment.center,
                    child: Text('Selecione um cartão'),
                  ),
                ],
                if (widget.aparecerVazio != null ? widget.aparecerVazio == false : true) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          CircleAvatar(
                            child: FlutterLogo(),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'JOAO P S CHIQUITIN',
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Text(
                                '**** **** **** 8751',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Column(
                            children: [
                              Text(
                                'Venc.',
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Text(
                                '08/2025',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          if (widget.aparecerSeta ?? false) ...[
                            const SizedBox(width: 10),
                            const Icon(Icons.arrow_forward_ios_outlined, size: 16),
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
