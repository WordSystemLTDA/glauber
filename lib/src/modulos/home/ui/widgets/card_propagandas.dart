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
                'https://static.wixstatic.com/media/11062b_521aef9283304ce89dd2e4d8c48d841e~mv2.jpg/v1/fill/w_640,h_172,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/11062b_521aef9283304ce89dd2e4d8c48d841e~mv2.jpg',
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
