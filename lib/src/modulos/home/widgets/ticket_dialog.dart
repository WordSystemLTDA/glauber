import 'package:flutter/material.dart';

class TicketDialog extends StatefulWidget {
  const TicketDialog({super.key});

  @override
  State<TicketDialog> createState() => _TicketDialogState();
}

class _TicketDialogState extends State<TicketDialog> {
  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: SizedBox(
        height: 230,
        width: 300,
      ),
    );
  }
}
