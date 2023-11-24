import 'package:flutter/services.dart';

class RgInputFormatter extends TextInputFormatter {
  // Define um limite de caracteres
  final int maxLength = 9;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove todos os caracteres não numéricos da nova entrada
    String unformattedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limita a entrada ao número máximo de caracteres
    if (unformattedText.length >= maxLength) {
      unformattedText = unformattedText.substring(0, maxLength);
    }

    // Formata o RG no padrão XX.XXX.XXX-X
    String formattedText = '';
    for (int i = 0; i < unformattedText.length; i++) {
      if (i == 2 || i == 5) {
        formattedText += '.';
      } else if (i == 8) {
        formattedText += '-';
      }
      formattedText += unformattedText[i];
    }

    // Retorna o valor formatado
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
