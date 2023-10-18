import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/home/widgets/ticket_dialog.dart';

class Compras extends StatefulWidget {
  const Compras({super.key});

  @override
  State<Compras> createState() => _ComprasState();
}

class _ComprasState extends State<Compras> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Card(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const TicketDialog();
                      });
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('hjh'),
                      SizedBox(height: 10),
                      Text('njkhkh'),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('11/10/2023'), Text('14:48'), Text('Cancelado')],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: const Column(children: [
                Icon(
                  Icons.telegram,
                  size: 35,
                ),
                SizedBox(height: 10),
                Icon(
                  Icons.qr_code,
                  size: 35,
                )
              ]),
            ),
          ]),
        ),
      ],
    );
  }
}
