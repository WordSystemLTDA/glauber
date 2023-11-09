import 'package:flutter/material.dart';

class CardPropagandas extends StatefulWidget {
  const CardPropagandas({super.key});

  @override
  State<CardPropagandas> createState() => _CardPropagandasState();
}

class _CardPropagandasState extends State<CardPropagandas> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            // Navigator.pushNamed(context, '/provas');
          },
          child: Stack(
            children: [
              Image.network(
                'https://lh3.googleusercontent.com/p/AF1QipOo4kxjmXxQ0HW2TxQ177AFo3MwbxabQAMptjdu=w1080-h608-p-no-v0',
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     height: 100,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         end: const Alignment(0.0, -0.6),
              //         begin: const Alignment(0.0, 0),
              //         colors: <Color>[const Color(0x8A000000), Colors.black12.withOpacity(0.0)],
              //       ),
              //     ),
              //   ),
              // ),
              // const Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         Text(
              //           "Propaganda",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 18,
              //           ),
              //         ),
              //         SizedBox(height: 5),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
